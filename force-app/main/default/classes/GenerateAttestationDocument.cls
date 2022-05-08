/** 
* @description - GenerateAttestationDocument for Attestation Process
*
* @author  Saiteja : ABSA
* @version v1.0
* @since   2021-03-24
* @W-010215
**/

public with sharing class GenerateAttestationDocument {
     /**
* @description - Method to generate Document.
* @param accountId 
* @param templateName 
* @return - Document
**/
    @AuraEnabled
    public static List<Document__c> generateAttestation(Id accountId, String templateName){
        // if (templateName == 'Attestation')
        List<Document__c> docmts = new List<Document__c>();
        System.debug('Generating new document for Account : ' + accountId + ', templateName : ' + templateName);
        Map<String, String> result = new Map<String, String>();
        try{
            Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(templateName);
            
            DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
            DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
            
            Account accountRecord = new AccountsSelector().selectAllById(accountId);
            List<Application_Product__c> appProdRecord = new ApplicationProductSelector().applicationProdRelatedToAcc(accountId);
            List<Address__c> addr = new AddressesSelector().addressesRelatedToAcc(accountId);
            
            contextBuilder.add('Account', accountRecord);
            contextBuilder.add('Application_Product__c', appProdRecord);
            if(addr.size() > 0){ //To handle null pointer exception by mohammed junaid U
                contextBuilder.add('Address__c', addr[0]); }
            
            String req = contextBuilder.serialize(documentTemplate.XML__c);
            
            Map<String, String> params = setECMParam(accountRecord, documentTemplate);
            
            
            CC_GenerateContentResponse response = documentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);
            document__c doc = createDoc(documentTemplate, response, accountId );
            docmts = new DocumentsSelector().selectByDocsId(doc.id);
            result.put('success', 'true');
            result.put('message', 'Successfully generated');
            
        } catch (Exception ex){
            result.put('success', 'false');
            result.put('message', 'Error generating document ' + ex.getMessage()+' at ' + ex.getLineNumber()+' getStackTraceString ' + ex.getStackTraceString());
            system.debug(ex.getMessage());
            system.debug(ex.getLineNumber());
        }
        return docmts;
    }
     /**
* @description - Method to create document
* @param docTemp 
* @param response
* @param accId
* @return - Document
**/ 
    public static document__c createDoc( Document_Template__c docTemp, CC_GenerateContentResponse response, Id accId){
        Document__c doc = new Document__c();
        doc.Name = docTemp.Name.left(75)+'.pdf';
        doc.Type__c = docTemp.Document_Type__c;
        if(!test.isRunningTest()){
        	doc.Reference__c = response.contentStoreToken;    
        }else{
            doc.Reference__c = 'Test';
        }
        
        doc.Account__c = accId;
        doc.ECM_Type__c = docTemp.ECM_Item_Type__c;
        insert doc;
        
        return doc; 
        
    }
   /**
* @description - Method to get fields and credentials
* @param acc 
* @param template 
* @return - Fields & credentials
**/    
    public static Map<String, String> setECMParam(Account acc, Document_Template__c template){
        Map<String, String> fields = new Map<String, String>();
        
        fields.put('CIFNr', acc.CIF__c == null ? '0' : acc.CIF__c);
        fields.put('IdNr', acc.Registration_Number__c == null ? '0' : acc.Registration_Number__c);
        fields.put('AcctNr', acc.AccountNumber == null ? '0' : acc.AccountNumber);
        fields.put('Origin', 'Salesforce B2C');
        fields.put('BusinessUnit', 'RBB');
        
        if (!Test.isRunningTest()){
            Map<String, String> credentials = ECM_IH_V1.getCredentials();
            fields.put('ECM_Account', credentials.get('username'));
            fields.put('ECM_Password', credentials.get('password'));
            fields.put('ECMItemType', template.ECM_Item_Type__c); 
        }
        
        return fields;
    }
}