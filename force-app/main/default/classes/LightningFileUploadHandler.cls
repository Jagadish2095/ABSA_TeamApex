/**
 *
 * @author  Kamil Rega
 * @since   2021-05-10
 *  @description : LightningFileUploadHandler
**/
public with sharing class LightningFileUploadHandler {
    /**
     * @comment : assignCase
     * @description : FICCaseRemediateDisputeCaseController
     * @return Case 
      * @param recordId 
     * */
    @AuraEnabled  
    public static List<ContentDocument> getFiles(string recordId){ 
        // TO avoid following exception 
        // System.QueryException: Implementation restriction: ContentDocumentLink requires
        // a filter by a single Id on ContentDocumentId or LinkedEntityId using the equals operator or 
        // multiple Id's using the IN operator.
        // We have to add sigle record id into set or list to make SOQL query call
        Set<Id> recordIds=new Set<Id>{recordId};
        Set<Id> documentIds = new Set<Id>(); 
        List<ContentDocumentLink> cdl= new List<ContentDocumentLink>();
        if(ContentDocumentLink.SObjectType.getDescribe().isAccessible()){
        
            cdl = [SELECT id,LinkedEntityId,ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN:recordIds]; 
        }else{
        return null;
        }
 
        for(ContentDocumentLink cdLink:cdl){  
            documentIds.add(cdLink.ContentDocumentId);  
        }    
        if(ContentDocument.SObjectType.getDescribe().isAccessible()){  
        return [SELECT Id,Title,FileType FROM ContentDocument WHERE id IN: documentIds];  
        }
        else{
            return null;
        }
    } 
    /**
     * @comment : assignCase
     * @description  FICCaseRemediateDisputeCaseController
     * 
     * @param sdocumentId
     * */
    @AuraEnabled  
    public static void deleteFiles(string sdocumentId){ 
        if(ContentDocument.SObjectType.getDescribe().isAccessible()){  
        delete [SELECT Id,Title,FileType from ContentDocument WHERE id=:sdocumentId];       
    }}  
    

 }