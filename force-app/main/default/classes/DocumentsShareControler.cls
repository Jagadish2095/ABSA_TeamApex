/**
* Controller for Documents used by Lightning components
* (DocumentShareHistoryEmail)
* @author Danie Booysen
* @created 2020-01-08
*/
public with sharing class DocumentsShareControler {
    
    /**
    * @author Danie Booysen
    * Method that gets a list of all documents (email) for an Opportunity
    *
    * @param opportunityId
    * @return a list of documents linked to the opportunityId parameter
    */
    @AuraEnabled
    public static List<Document__c> getDocAuditHistoryEmail(Id opportunityId) {
        
        /*List<Document__c> docList = [SELECT Id, Name, Type__c, Owner.Name, OwnerId, CreatedDate
                                     FROM Document__c 
                                     WHERE Opportunity__c =: opportunityId
                                     ORDER BY CreatedDate DESC];
        
        return docList;*/
        
        List<Document__c> docList = new DocumentsSelector().selectDocumentsByOppId(opportunityId);
        return docList;
    }
    
    /**
    * @author Vladimir Panajic
    * @modified Danie Booysen
    * Method that downloads a document to the desktop
    *
    * @param documentId
    * @return ECM_GetResult_IB_V1.Content.data
    */
    @AuraEnabled
    public static String getDocumentContent(Id documentId) {
        
        System.debug('***DOCUMENT ID: ' + documentId);
        //Document__c doc = [SELECT Id, Reference__c From Document__c WHERE Id =: documentId];
        List<Document__c> docContentList = new DocumentsSelector().selectByDocId(documentId);
        
        ECM_LoginResult_IB_V1 login = ECMLogin();
        ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, docContentList[0].Reference__c);
        
        if(getResult.Content != null){
            return getResult.Content.data;
        }else{
            return 'ECM returned no results.';
        }
        
    }
    
    /**
    * @author Vladimir Panajic
    * Method that logs to ECM
    */
    public static ECM_LoginResult_IB_V1 ECMLogin() {
        
        Map<String, String> credentials = ECM_IH_V1.getCredentials();        
        ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));        
        return login;
    }
    
}