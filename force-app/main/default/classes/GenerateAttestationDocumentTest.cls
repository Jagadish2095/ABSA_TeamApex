/**
* @description -Test class for GenerateAttestationDocument
* @author   Saiteja : ABSA
* @since   2021-04-02 
*
**/
@isTest
public class GenerateAttestationDocumentTest {
    @TestSetup
    static void makeData() {
        Account acc = new Account(Name = 'Test New Bus Client', Client_Type__C = 'Private Company',Registration_Number__c='5678',CIF__c ='3574',
                                  AccountNumber='6478');
        insert acc;
        Address__c addr = new Address__c(Address_Type__c='Head Office',Address1__c='pretoria',Account__c=acc.id);
        insert addr;
    }
    /**
* @description - testMethod for generate Document.
**/
    @isTest
    public static  void testGenerateDocument() {
        // WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        List<Address__c> addr = new List<Address__c>();
        List<Document__c> docts = new List<Document__c>();
        Account acct = [Select id, Name,CIF__c,Registration_Number__c,AccountNumber from Account where Name = 'Test New Bus Client'];
        Address__c addrs =[Select Address_Type__c,Address1__c from Address__c where Account__c=:acct.id  ];
        addr.add(addrs);
        system.debug('address'+addr);
        
        Test.startTest();
        DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
        DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
        
        Account accountRecord = new AccountsSelector().selectAllById(acct.id);
        List<Application_Product__c> appProdRecord = new ApplicationProductSelector().applicationProdRelatedToAcc(acct.id);
        
        contextBuilder.add('Account', accountRecord);
        contextBuilder.add('Application_Product__c', appProdRecord);
        contextBuilder.add('Address__c', addr);
        
        
        List<String> endpoints = new List<String>();
        endpoints.add(CC_ContentService_IH_v1.GENERATE_CONTENT_PATH); 
        endpoints.add(JitterbitAuth_IH_V1.JITTERBIT_AUTH_PATH);
        IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit', endpoints);
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ 'ECM Authenication Path' });
        
        
        endpoints.add('Document Template Processor');
        IntegrationTestDataFactory.insertIntegrationSettings('Jitterbit2', endpoints);
        
        JitterbitAuthResponse authResponse = JitterbitAuthResponse.getExample();
        authResponse.token = '127168272819';
        CC_GenerateContentResponse res = CC_GenerateContentResponse.getExample();
        RestClientUtils.QueueHttpMock mock = new RestClientUtils.QueueHttpMock();
        mock.addResponse(JSON.serialize(authResponse));
        mock.addResponse(JSON.serialize(res));
        Test.setMock(HttpCalloutMock.class, mock);
        
        CC_GenerateContentRequest request = new CC_GenerateContentRequest();
        String templateName = 'Attestation';
        request.fileName = 'Attestation.pdf';
        
        Document_Template__c dt = new Document_Template__c();
        dt = new Document_Template__c();
        dt.Name = 'Attestation';
        dt.Document_Type__c = 'Attestation';
        
        dt.ECM_Item_Type__c = 'Ent_Agreement';
        dt.XML__c = '<Account><LastName>{Account.LastName}</LastName>';
        insert dt;
        
        Document__c doc = new Document__c();
        doc.Name = 'Attestation.pdf';
        doc.Type__c = 'Attestation';
        doc.Reference__c = '2683723-293892-kajska';
        doc.Account__c = acct.id;
        doc.ECM_Type__c = 'Ent_Agreement';
        insert doc;
        
       
        
        docts = GenerateAttestationDocument.generateAttestation(acct.id,templateName);
        GenerateAttestationDocument.setECMParam(acct,dt);
        system.assertnotEquals(null,docts);
        Test.stopTest();
    }
    
    
}