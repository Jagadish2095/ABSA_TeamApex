/**
* Apex controller class for the Aura bundle CaseResolutionAndClosure.
*
* @author  Tracy de Bruin : CloudSmiths
* @since   2018-06-14
*
**/
public class CaseResolutionAndClosureController {
    
/*
* Get the Case record with SLA Information
* 
* @param recId - Case Id
* @return Case record
*/
    @AuraEnabled
    public static Case getCaseRecord(String recId){
        //Get Case record
        Try{
           
            List<Case> caseRecord = new CasesSelector().selectByIdWithSLAInfo( recId, 1);
            
            //Update caseRecord;
            return caseRecord[0];
        }Catch(Exception ex){
            System.debug('There was an error getting the Case Record - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage()); 
        } 
    } 
    
/*
* Navigate to correct page layout
* 
* @param RecordTypeId
* @return URL string
*/
    @AuraEnabled
    public static Case updateAndCloseCase(Case caseRecord, Service_Type__c serviceTypeRecord){

        Try{
            caseRecord.Status = 'Resolved';
            caseRecord.Type__c = serviceTypeRecord.Type__c;
            caseRecord.Subtype__c = serviceTypeRecord.Subtype__c;
            caseRecord.Product__c = serviceTypeRecord.Product__c; 
            caseRecord.FAIS_NCA__c = serviceTypeRecord.FAIS_NCA__c;
            caseRecord.sd_Service_Type_Id__c = serviceTypeRecord.Id;
			caseRecord.sd_Service_Type__c = serviceTypeRecord.Name;
           
            update caseRecord;
            
            return caseRecord;
            
        }catch(DmlException ex){
            System.debug(LoggingLevel.Finest,'Exception : CaseResolutionAndClosureController : updateAndCloseCase - ' + ex.getMessage());
            
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
            System.debug(LoggingLevel.Finest,'Exception : CaseResolutionAndClosureController : updateAndCloseCase - ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage()); 
        }
    } 
    
    /*
     * Search case classification records                         
     * <p>
     * Search and return a single Service_Type__c object
     * based on the record Id
     *
     * @param  recId String Service_Type__c object Id  
     * @return A single Service_Type__c object 
    */
    @AuraEnabled
    public static Service_Type__c findServiceType(String recId) {
        
        //Add Id to a Set
        Set<Id> serviceTypes = new Set<Id>();
        serviceTypes.add(recId);
        list<Service_Type__c> returnRec = new ServiceTypesSelector().selectById(serviceTypes);
        
        if(returnRec.size() > 0){
            return returnRec[0];
        }else{
            return null;
        }
    } 
    
    /*
	* linking document to case
	* @params - Case Id, ContentDocument Ids  
	* @return String
	* @Created by : Koketso Mpshane : 04-12-2019
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
    
    /*
     * Koketso Mpshane - Get Products based on the service group Id
     * @param  String productId 
     * @return List<SelectOptionWrapper> 
     */
	@AuraEnabled    
    public static List<SelectOptionWrapper> findProductsByServiceGroup(String serviceGroupId){
        
        List<SelectOptionWrapper> selectOptionList = new List<SelectOptionWrapper>();
        List<Service_Group_Type__c> linkedProducts = new ServiceGroupTypesSelector().getProductsByServiceGroupId(serviceGroupId);
        
        Set<String> productIds = new Set<String>(); 
        Map<String, String> productIdMap = new Map<String, String>();
        
        if(linkedProducts.size() > 0){
            for(Service_Group_Type__c sgt: linkedProducts){
                productIds.add(sgt.Service_Type__r.Linked_Product__c);
                productIdMap.put(sgt.Service_Type__r.Linked_Product__c, sgt.Service_Type__r.Linked_Product__r.Name);
            }
        }
        
        if(productIds.size() > 0){
            for(String pId: productIds){
                selectOptionList.add(new SelectOptionWrapper(productIdMap.get(pId), pId));
            }
        }
        
        return selectOptionList;
    }
    
     /*
     * Koketso Mpshane - Search Service Types based on the product Id
     * @param  String productId 
     * @return List<SelectOptionWrapper> 
     */
	@AuraEnabled    
    public static List<SelectOptionWrapper> findServiceTypesByProductAndServiceGroup(String caseId, String productId, String serviceGroupId){
        List<SelectOptionWrapper> selectOptionList = new List<SelectOptionWrapper>();
        
        if(serviceGroupId == null){
            String serviceGroupName = [Select sd_Service_Group__c From Case Where Id =:caseId].sd_Service_Group__c;
            Service_Group__c serviceGroup = [Select Id From Service_Group__c Where Name =:serviceGroupName];
            if(serviceGroup != null){
                serviceGroupId = serviceGroup.Id;
            }
        }
        
        List<Service_Group_Type__c> linkedProductServiceTypes = new ServiceGroupTypesSelector().selectByProductIdAndServiceGroup(productId, serviceGroupId);
        
        for(Service_Group_Type__c sgt: linkedProductServiceTypes){
            selectOptionList.add(new SelectOptionWrapper(sgt.Service_Type__r.Name, sgt.Service_Type__c));
        }
        
        return selectOptionList;
    }
    
    public class SelectOptionWrapper{
        
        @AuraEnabled
        public String name{get;set;}
        @AuraEnabled
        public String id{get;set;}
        
        public selectOptionWrapper(String name, String id){
            this.name = name;
            this.id = id;
        }
    }

}