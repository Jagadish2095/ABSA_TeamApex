/**
* Apex controller class for the comp CaseSplitAction.
* Gives an agent the ability to split a case into multiple 
* requests
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-10-10
*
**/
public class CaseSplitActionExt {
    
    @AuraEnabled
    public static void splitCase(String jsonString, String parentCaseId) {
        
        Set<Id> idSet = new Set<Id>();
        idSet.add(parentCaseId);
        
        List<Case> parentCaseLst = new CasesSelector().selectById(idSet);
        List<ContentVersion> parentCaseCVList = new List<ContentVersion>(); //Simangaliso
        
        Set<Id> parentServiceGroupId = new Set<Id>();
        parentServiceGroupId.add(parentCaseLst[0].sd_Service_Group_Id__c);
        List<Service_Group__c> parentServiceGroup = new ServiceGroupsSelector().selectById(parentServiceGroupId);
        
        jsonString = jsonString.replaceAll('\\["', '"');
        jsonString = jsonString.replaceAll('\\"]', '"');
        
        //System.debug(jsonString);
        
        List<Case> caseList = (List<Case>)JSON.deserialize(jsonString, List<Case>.class);
        
        Set<Id> groupIdSet = new Set<Id>();
        groupIdSet.add(parentServiceGroup[0].id);
        
        for(Case c :caseList){
            System.debug('###c.Service_Group_Search__c : ' + c.Service_Group_Search__c);
            groupIdSet.add(c.Service_Group_Search__c);
        }
        
        List<Service_Group_Type__c> sgtList = new ServiceGroupTypesSelector().selectByServiceGroupWithServiceLevelInfo(groupIdSet);
        Map<Id,Service_Group_Type__c> groupTypeMap = new Map<Id,Service_Group_Type__c>();
        
        for(Service_Group_Type__c sgt :sgtList){
            System.debug('### Service Group Type : ' + sgt);
            groupTypeMap.put(sgt.Service_Group__c, sgt);
        }
        
        Map<String, Id> queueMap = new Map<String, Id>();
        List<Group> caseQueues = new GroupsSelector().selectByType('Queue');
        
        //Add all Queues to a Map
        for(Group eachQueue : caseQueues) {
            queueMap.put(eachQueue.Name, eachQueue.id);
        }
        
        List<Case> insertCaseList = new List<Case>();
        
        if(!parentCaseLst.isEmpty()){
            
            for(Case c :caseList){
                System.debug('### Each Case : ' + c);
                
                //Assign fields
                c.ParentId = parentCaseId;
                c.AccountId = parentCaseLst[0].AccountId;
                c.ContactId = parentCaseLst[0].ContactId;
                c.Bypass_Validation_Rules__c = true;
                c.Email_From_Address__c = parentCaseLst[0].Email_From_Address__c;
                c.Email_From_Name__c = parentCaseLst[0].Email_From_Name__c;
                c.Communication_Method__c = parentCaseLst[0].Communication_Method__c;
                c.Phone__c = parentCaseLst[0].Phone__c;
                c.Mobile__c = parentCaseLst[0].Mobile__c;
                c.Email__c = parentCaseLst[0].Email__c;
                c.Postal_Address__c = parentCaseLst[0].Postal_Address__c;
                c.Originated_By__c = parentCaseLst[0].Originated_By__c;
                
                
                
                if(c.Service_Group_Search__c == null || String.isBlank(c.Service_Group_Search__c)) {
                    if(parentServiceGroup.size() > 0) {
                        c.Service_Group_Search__c = parentServiceGroup[0].id;
                    }
                }
                
                if (groupTypeMap.containsKey(c.Service_Group_Search__c)){
                    
                    System.debug('### Service Group Type : ' + groupTypeMap.get(c.Service_Group_Search__c));
                    c.sd_Service_Group_Type_Id__c = groupTypeMap.get(c.Service_Group_Search__c).Id;
                    c.sd_Service_Level_Id__c = groupTypeMap.get(c.Service_Group_Search__c).Service_Level__c;
                    c.sd_Service_Group_Id__c = c.Service_Group_Search__c;
                    c.sd_Communication_Plan_Id__c = groupTypeMap.get(c.Service_Group_Search__c).sd_Communication_Plan__c; 
                    c.sd_Service_Group__c = groupTypeMap.get(c.Service_Group_Search__c).Service_Group__r.Name;
                    c.sd_Original_Service_Group__c = groupTypeMap.get(c.Service_Group_Search__c).Service_Group__r.Name;
                    c.sd_Original_Service_Queue__c = groupTypeMap.get(c.Service_Group_Search__c).Service_Group__r.Queue__c;
                    c.BusinessHoursId = groupTypeMap.get(c.Service_Group_Search__c).Service_Group__r.Business_Hours__c;
                    c.sd_Response_Email_Address__c = groupTypeMap.get(c.Service_Group_Search__c).Service_Group__r.Response_Email_Address__c;
                    c.sd_Email_Template_Case_Creation__c = groupTypeMap.get(c.Service_Group_Search__c).Service_Group__r.Email_Template_Case_Creation__c;
                    c.Internal_SLA_Notification_User__c  = groupTypeMap.get(c.Service_Group_Search__c).Service_Group__r.Internal_SLA_Notification_User__c;     
                    c.External_SLA_Notification_User__c = groupTypeMap.get(c.Service_Group_Search__c).Service_Level__r.External_SLA_Notification_User__c;
                    
                    if(groupTypeMap.get(c.Service_Group_Search__c).Service_Group__r.Skip_Split_Auto_Response__c){
                        c.Skip_Auto_Response__c = true;
                    }
                    String queueName = groupTypeMap.get(c.Service_Group_Search__c).Service_Group__r.Queue__c;
                    if (queueName != null && queueMap.containsKey(queueName)) {
                        c.OwnerId = queueMap.get(queueName);
                    }
                } 
                
                
                System.debug('### Each Case : ' + c);
                insertCaseList.add(c);
            }

            // Get Parent Case ContentVersions - Simangaliso
            parentCaseCVList = [SELECT Checksum,ContentDocumentId,ContentLocation,ContentSize,ContentUrl,Description,FileExtension,FileType,FirstPublishLocationId,Id,IsAssetEnabled,IsDeleted,Origin,OwnerId,PathOnClient,PublishStatus,RatingCount,ReasonForChange,SharingOption,Title,VersionData,VersionNumber 
            FROM ContentVersion 
            WHERE FirstPublishLocationId = :parentCaseLst[0].Id];
            
        }
        
        try{
            
            insert insertCaseList;
            
            //Clone Parent Case ContentVersion and publish them on child cases - Simangaliso
            if(!parentCaseCVList.isEmpty()){
                List<ContentVersion> childCVListToInsert = new List<ContentVersion>(); 
                for(Case childCase: insertCaseList){

                    for(ContentVersion parentAtt : parentCaseCVList){
                        ContentVersion childCV          = new ContentVersion();
                        childCV.Title                   = parentAtt.Title;
                        childCV.PathOnClient            = parentAtt.PathOnClient;
                        childCV.VersionData             = parentAtt.VersionData;
                        childCV.FirstPublishLocationId  = childCase.Id;
                        childCVListToInsert.add(childCV);
                    }

                }
                insert childCVListToInsert;
            }

            
        }catch(DmlException ex){
            System.debug(LoggingLevel.Finest,'Exception : CaseSplitActionExt : splitCase - ' + ex.getMessage());
            
            //Any type of Validation Rule error message, Required field missing error message, Trigger error message etc..
            String msg = '';
            //Get All DML Messages
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ ex.getDmlMessage(i) +  '\n' ;
            }
            //throw DML exception message
            throw new AuraHandledException(msg);
            
        } catch (Exception ex){
            System.debug(LoggingLevel.Finest,'Exception : CaseSplitActionExt : splitCase - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage()); 
        }
    }
}