/**
* Apex controller class for the Aura bundle CaseCloseAction.
* Allow a user to close a case and provide the out-of-SLA reason
* and comments
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-07-02
*
**/
public class CaseCloseActionExt {
    
     /*RN - Cloudmiths
      * 
     * Load initial data                     
     * <p>
     * Load all closed status picklist values and the 
     * current SLA status of the Case into a inner class
     * and pass it back to the calling client side
     * 
     * @param recId String Case Id
     * @return DataLoad Inner class
    */
    @AuraEnabled
    public static DataLoad loadData(String recId){
        
        Set<Id> idSet = new Set<Id>();
        idSet.add(recId);
        List<Case> caseList = new CasesSelector().selectByIdWithClassification(idSet, 1);
        
        DataLoad at = new DataLoad();
        String rtypeName;
        List<String> options = new List<String>();
        
        Close_Status_Mapping__mdt closeStatusMapping;
        List<String> closeStatusList = new List<String>();
        //Smanga - Start
        at.caseBeforeClosure                    = caseList[0];
        String priorityServGroupsmdtValueString = (String) [SELECT Value__c FROM Org_Wide_Lookup_Value__mdt WHERE DeveloperName = 'Case_Classify_Service_Groups'].Value__c;
        at.priorityServiceGroupsNames           = (List<String>) priorityServGroupsmdtValueString.split(';');
        List<GroupMember> memberShip            = new List<GroupMember>();
        if(at.priorityServiceGroupsNames.contains(caseList[0].sd_Service_Group__c)){
            
            at.isPriorityServiceGroup = true;
            memberShip = [SELECT UserOrGroupId FROM GroupMember WHERE Group.Name = :caseList[0].sd_Service_Group__c  AND Group.Type='Regular' AND UserOrGroupId = :UserInfo.getUserId()];
            if(!memberShip.isEmpty()){
                at.isUserPriorityGroupMember = true;
            }
        }
        // Smanga -End
        
        
        //Use metadata api to get all the close statuses per record type
        /* Koketso - Commented out the call to method that calls the metadata api, to be replaced with custom metadata types because of slow responses
        Map<String, String> pickListMap = getPickListValues('Case', caseList[0].RecordTypeId, 'Status');
        
        for(CaseStatus cs :[Select MasterLabel From CaseStatus Where IsClosed = true]){
            
            if( (pickListMap.containsKey(cs.MasterLabel)) && (cs.MasterLabel != 'Unwanted')){
                 options.add(cs.MasterLabel);
            }
        }*/
        
        //Koketso - check case recordtype and get all close statuses assigned to it in the custom metadata type
        if(caseList[0].RecordTypeId != null){
            if(caseList[0].Owner_Queue_Name__c == 'Advisers, Wealth, Investments and Trust' && caseList[0].RecordType.Name == 'Service Request'){
                   rtypeName = caseList[0].Owner_Queue_Name__c;
                   rtypeName = rtypeName.replace(' ','');
                   rtypeName = rtypeName.replace(',','');
            }
            else
               rtypeName = [Select DeveloperName From RecordType Where Id =:caseList[0].RecordTypeId].DeveloperName;
            System.debug('rtypeName'+rtypeName);
            closeStatusMapping = [Select MasterLabel, DeveloperName, Close_Status__c From Close_Status_Mapping__mdt Where DeveloperName =:rtypeName];
            closeStatusList = (closeStatusMapping.Close_Status__c).split(';');
            
               // Poulami Added to pass the field data for Case record Type NBFS
            if (rtypeName == 'NBFS_Dispute_Resolution' ||rtypeName == 'Short_term_Complaint')
             {
                at.isNBFSRecordType = true;// Added to pass the Case record Type for NBFS
                at.NBFSServiceGroup = caseList[0].sd_Service_Group__c;
                at.NBFSCategory = caseList[0].NBFS_Category__c;
                at.NBFSSource = caseList[0].Source__c;
                at.ClaimAmount = caseList[0].Claim_Amount__c;
               	String servicegroupname = caseList[0].sd_Service_Group__c;
                at.NBFSServiceGroup = servicegroupname;
				NBFS_Dispute_Resolution_Configuration__mdt decisionsMapping = [Select Regulatory_Decision__c,Product_Type__c,Region__c,Problem_Area__c From NBFS_Dispute_Resolution_Configuration__mdt Where MasterLabel =:servicegroupname];
                at.mappings = decisionsMapping;
                List<ContentDocument> DocumentList = new List<ContentDocument>();
                Set<Id> documentIds = new Set<Id>();
            	List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:caseList[0].Id];
                if(cdl.size() > 0){
                  if(closeStatusList.size() > 0){
        			for(ContentDocumentLink cdLink:cdl){
            			documentIds.add(cdLink.ContentDocumentId);
           			} 
                  	DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds and Description != ''];
                  	at.DocumentsList = DocumentList;
                  }
                 }
        		
			} 
        }
        system.debug(LoggingLevel.FINE, '**closeStatusList**:'+closeStatusList);        
        if(closeStatusList.size() > 0){
            for(String cs :closeStatusList){
                options.add(cs);
            }
        }
        
        at.closeStatusList.addAll(options);

        if(at.closeStatusList.size() == 1){
            at.defaultStatus = at.closeStatusList[0];
            System.debug(at.defaultStatus);
        }

        String slaStatus = caseList[0].External_SLA_Status__c;

        if( slaStatus.contains('Overdue') ){
            at.isOutOfSla = true;
        }
        
        if( caseList[0].isClosed ){
            at.isClosed = true;
        } 
        
        if(String.isBlank(caseList[0].Type__c) ){
            if(caseList[0].Owner_Queue_Name__c == 'Advisers, Wealth, Investments and Trust' && caseList[0].RecordType.Name == 'Service Request')
                at.isNotClassified = false;
            else
            at.isNotClassified = true;
        }
        
        if(String.isBlank(caseList[0].AccountId)){
            if(caseList[0].Owner_Queue_Name__c == 'Advisers, Wealth, Investments and Trust' && caseList[0].RecordType.Name == 'Service Request')
                at.isNotLinked = false;
            else
            at.isNotLinked = true;
            //at.isNotLinked = true;
        }
        
        return at;
    } 
   
    /*
     * Changes to fetch the advior details for NBFS Case Record Type
     * Search Advisor User records                         
     * <p>
     * Search and return a single User object
     * based on the record Id
     *
     * @param  advisorid String User object Id  
     * @return A single User object 
    */
     @AuraEnabled
    public static User getAdvisorInfo(String advisorid) {
     
        if(String.isNotBlank(advisorid)){
       
            User advisordetails = [Select Advisor_Code__c,Name From User Where Id =:advisorid];
             if(advisordetails != null){
                return advisordetails;
            }else{
                return null;
            }
        }else{
            return null;
        }
    } 
    
    
     /*
     * Changes to fetch the document type details for NBFS Case Record Type
     * Search Document Type records for Service Groups                      
     * <p>
     * Search and return a single Document Types string
     * based on the service group
     *
     * @param  servicegroup String Service Group Name
     * @param  source String Case Object Source  field
     * @param  resolutiontype String Resolution type
     * @return all document type List 
    */
     @AuraEnabled
    public static List<String> getDocumentTypeInfo(String servicegroup,String category,String resolutiontype) {
     
        String searchspec = servicegroup+category+resolutiontype;
        searchspec = searchspec.replace(' ','');
        NBFS_Dispute_Resolution_Configuration__mdt documentMapping = [Select MasterLabel, DeveloperName, Document_type__c From NBFS_Dispute_Resolution_Configuration__mdt Where Document_Type_Name__c =:searchspec];
       
        if(String.isNotBlank(documentMapping.Document_type__c)){
            List<String> documenttypeList = (documentMapping.Document_type__c).split(';');
        	return documenttypeList;
        }
        else
            return null;
    } 
    
     /*
     * Changes to upload and link documents uploaded for NBFS Case Record Type
     * Search existing documents linked to the case                        
     * <p>
     * Update the description with the document type uploaded for the case
     * based on the document Id
     * Search and return a ContentDocument object
     * based on the case record Id
     *
     * @param  documentId String ContentDocument Object Id 
     * @param  recordId String Case Object Id
     * @param description String DocumentType uploaded
     * @return All ContentDocument object 
    */
     @AuraEnabled 
    public static List<ContentDocument> UpdateFiles(string documentId,string recordId,string description){
        
        ContentDocument cd = [select id,title from ContentDocument where Id=:documentId]; // Getting files from Parent record
        cd.Description = description;
        try{
            update cd;  // Update ContentDocument (File)
        } 
        catch(DMLException e){ 
            system.debug('Exception has occurred! ' +e.getMessage());
        }
        List<ContentDocument> DocumentList = new List<ContentDocument>();
        
        Set<Id> documentIds = new Set<Id>();
        
        List<ContentDocumentLink> cdl=[select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where LinkedEntityId=:recordId];
        for(ContentDocumentLink cdLink:cdl){
            documentIds.add(cdLink.ContentDocumentId);
           } 
        DocumentList = [select Id,Title,FileType,ContentSize,Description from ContentDocument where id IN: documentIds and Description != ''];
        
        return DocumentList;
    }
    

    /* RN - Cloudsmiths
     * Retrieve picklist value by recordtype via REST API
     * 
     * @param  objectType String
     * @param  recordTypeId String
     * @param  fieldName String
     * @return Map<String, String>
     * Koketso - Commented out the method that calls the metadata api, to be replaced with custom metadata types because of slow responses
     @AuraEnabled
    public static Map<String, String> getPickListValues(String objectType, String recordTypeId, String fieldName) {
        
        String endpoint = 'callout:MetaDataAccess/services/data/v43.0';
        endpoint += '/ui-api/object-info/{0}/picklist-values/{1}/{2}';
        endpoint = String.format(endpoint, new String[]{ objectType, recordTypeId, fieldName });
        EncodingUtil.urlEncode(endpoint,'UTF-8');
        
        System.debug(LoggingLevel.FINE, 'OAuth {!$Credential.OAuthToken}');
        
        //HTTP Request send
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setHeader('Authorization', 'OAuth {!$Credential.OAuthToken}');
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);
         
        //Parse response
        Map<String,String> result = new Map<String,String>();
        
        Map<String,Object> root = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
        
        if(!root.containsKey('values')){ 
            return result; 
        }
        
        List<Object> pValues = (List<Object>)root.get('values');
        
        for(Object pValue : pValues){
            
            Map<String,Object> pValueMap = (Map<String,Object>)pValue;
            
            result.put((String)pValueMap.get('label'), (String)pValueMap.get('value'));
            
            System.debug(LoggingLevel.FINE, result);
        
        }
         
        return result;
    }*/
    
     /*
     * Close a case(complaint,Service Request,NBFS)                      
     * <p>
     * 
     * 
     * @param  recId String Case Id
     * @param  reason String Ou-of-SLA reason
     * @param  status String Case close status
     * @param  comment String Ou-of-SLA comments
     * @param  unresolve String
     * @return void
    */
    @AuraEnabled
    public static void resolveCase(String recId,Case caseRecord ){
          
        Set<Id> idSet = new Set<Id>();
        idSet.add(recId);
        List<Case> caseList = new CasesSelector().selectByIdWithClassification(idSet, 1);
        caseRecord.Id = recId;
                                              
        //Check if the current owner is a queue, if yes, change the owner to 
        //the running user.
        if(!String.valueOf( caseList[0].OwnerId ).startsWith('005')){
            if(caseList[0].RecordType.Name == 'NBFS Dispute Resolution'){
                    System.debug('You cannot Close a Case. Please change the Case Owner.');
                    throw new AuraHandledException('You cannot Close a Case. Please change the Case Owner.');
             }
            else{
                //caseList[0].OwnerId = UserInfo.getUserId();    
            	caseRecord.OwnerId = UserInfo.getUserId();
            }
        }
        else if(caseList[0].OwnerId != UserInfo.getUserId() && caseList[0].RecordType.Name == 'NBFS Dispute Resolution'){
              System.debug('You cannot Close a Case. Please change the Case Owner.');
              throw new AuraHandledException('You cannot Close a Case.');
        }
        try{
            //update caseList[0];
            update caseRecord;
        }catch(DmlException ex){
            System.debug(LoggingLevel.Finest,'Exception : CaseCloseActionExt : closeCase - ' + ex.getMessage()); 
            
            //TdB - Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
            String msg = '';
            //Get All DML Messages
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ ex.getDmlMessage(i) +  '\n' ;
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
            
            
        } catch (Exception ex){
            System.debug(LoggingLevel.Finest,'Exception : CaseCloseActionExt : closeCase - ' + ex.getMessage()); 
            throw new AuraHandledException(ex.getMessage()); 


        }
    } 
    
    /*RN - Cloudsmiths
      * 
     * Close a case                        
     * <p>
     * Close a case and update the Out-of-SLA Reason if applicable
     * 
     * @param  recId String Case Id
     * @param  reason String Ou-of-SLA reason
     * @param  status String Case close status
     * @param  comment String Ou-of-SLA comments
     * @param  unresolve String
     * @return void
    */
    @AuraEnabled
   public static void closeCase(String recId, String status, String reason, String comment, 
                                String whoCausedIt, String summaryOfResolution, String resolvedInFavour, 
                                String unresolvedReason,String whereDidThisHappen,String responsibleSite, String tradeLoss, Double amountRefunded,boolean gestureOfGoodwill){
          
        Set<Id> idSet = new Set<Id>();
        idSet.add(recId);
        List<Case> caseList = new CasesSelector().selectByIdWithClassification(idSet, 1);
      
        caseList[0].Status = status;
        caseList[0].Out_of_SLA_Reason__c = reason;
        caseList[0].Out_of_SLA_Comments__c = comment;
        caseList[0].Who_Caused_It__c = whoCausedIt;
        caseList[0].Summary_of_Resolution__c = summaryOfResolution;
        caseList[0].Resolved_in_Favour_of__c = resolvedInFavour;
        caseList[0].Unresolved_Reason__c = unresolvedReason;
        caseList[0].Where_Did_This_Happen__c = whereDidThisHappen;
        caseList[0].Responsible_Site__c = responsibleSite;
        caseList[0].Trade_Loss__c = tradeLoss;
        caseList[0].Amount_Refunded__c = amountRefunded;
        caseList[0].Who_Caused_It_Options__c = whoCausedIt;
        if(gestureOfGoodwill != null){
        	caseList[0].Gesture_Of_Goodwill__c = gestureOfGoodwill;
        }
                                    
        //Check if the current owner is a queue, if yes, change the owner to 
        //the running user.
        if(!String.valueOf( caseList[0].OwnerId ).startsWith('005')){
           caseList[0].OwnerId = UserInfo.getUserId();    
        }
       
        try{
            update caseList[0];
            
        }catch(DmlException ex){
            System.debug(LoggingLevel.Finest,'Exception : CaseCloseActionExt : closeCase - ' + ex.getMessage()); 
            
            //TdB - Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
            String msg = '';
            //Get All DML Messages
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ ex.getDmlMessage(i) +  '\n' ;
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
            
            
        } catch (Exception ex){
            System.debug(LoggingLevel.Finest,'Exception : CaseCloseActionExt : closeCase - ' + ex.getMessage()); 
            throw new AuraHandledException(ex.getMessage()); 


        }
    } 
     /* RN - Cloudsmiths
      * 
     * Inner data class                   
     * <p>
     * Inner data class that stores the 
     * closed status picklist values and SLA status
     * of a Case
    */
    public class DataLoad{
        
        @AuraEnabled public List<String> closeStatusList {get;set;}
        @AuraEnabled public Boolean isOutOfSla {get;set;}
        @AuraEnabled public Boolean isClosed {get;set;}
        @AuraEnabled public Boolean isNotClassified {get;set;}
        @AuraEnabled public Boolean isNotLinked {get;set;}
        @AuraEnabled public String defaultStatus {get;set;}
        //to display additional fields for NBFS Case record type
        @AuraEnabled public Boolean isNBFSRecordType {get;set;}
        @AuraEnabled public String NBFSServiceGroup {get;set;}
        @AuraEnabled public String NBFSCategory {get;set;}
        @AuraEnabled public String NBFSSource {get;set;}
        @AuraEnabled public List<String> regulatorydecisionList {get;set;}
        @AuraEnabled public NBFS_Dispute_Resolution_Configuration__mdt mappings {get;set;}
        @AuraEnabled public List<ContentDocument> DocumentsList {get;set;}
        @AuraEnabled public Decimal ClaimAmount {get;set;}
        //Smanga Start
        @AuraEnabled public List<String> priorityServiceGroupsNames {get;set;}
        @AuraEnabled public Boolean isUserPriorityGroupMember {get;set;}
        @AuraEnabled public Boolean isPriorityServiceGroup{get;set;}
        @AuraEnabled public Case caseBeforeClosure {get;set;}
        //Smanga End


        public DataLoad(){
            closeStatusList = new List<String>();
            isOutOfSla = false;
            isClosed = false;
            isNotClassified = false;
            isNotLinked = false;
            defaultStatus = '--None--';
             // to display additional fields for NBFS Case record type
            isNBFSRecordType = false;
            NBFSServiceGroup = '';
            NBFSCategory = '';
            NBFSSource = '';
            regulatorydecisionList = new List<String>();
            priorityServiceGroupsNames = new List<String>();
            isUserPriorityGroupMember        = false;
            isPriorityServiceGroup           = false;
            caseBeforeClosure                = new Case();
        }
    }
    
    @AuraEnabled
    public static String getRecordTypenName(String developerName, String sobjectName) {
        
        String recordTypenName = RecordTypeIdController.getRecordTypeName(developerName,sobjectName);
         
        return recordTypenName;
    }

     
    /*
	* linking document to case
	* @params - Case Id, ContentDocument Ids  
	* @return String
	* @Created by : Simangaliso Mathenjwa: 15 Oct 2020
	*/
    @AuraEnabled
    public static String uploadContentDocuments(String caseId, List<String> contentDocumentIds) {
        String uploadResult;
        List<ContentDocumentLink> docsToUpsert = new List<ContentDocumentLink>();
        try{
            List<ContentDocumentLink> cdlList = [select Id, LinkedEntityId, ContentDocumentId, Sharetype From ContentDocumentLink Where ContentDocumentId in: contentDocumentIds];
            if(cdlList.size() > 0){
                for(ContentDocumentLink cdl: cdlList){
                    ContentDocumentLink cDoc = cdl.clone();
                    cDoc.LinkedEntityId = caseId;
                    cDoc.Sharetype = 'V';
                    docsToUpsert.add(cDoc);
                }
            }
            if(docsToUpsert.size() > 0){
               upsert docsToUpsert; 
            }
            
            uploadResult = 'Files successfully uploaded';
        }catch (Exception ex){
            uploadResult = ex.getMessage();
        }
        
        system.debug(LoggingLevel.FINE, '**uploadResult**'+uploadResult);
        return uploadResult;
    }
}