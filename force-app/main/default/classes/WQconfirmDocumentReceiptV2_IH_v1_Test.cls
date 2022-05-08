/**
* Main class : WQconfirmDocumentReceiptV2_IH_v1 service
* Test Class Name: WQconfirmDocumentReceiptV2_IH_v1_Test
* @author  Anka Ganta : Absa
* @since   2020-04-24
*
**/
@isTest
public class WQconfirmDocumentReceiptV2_IH_v1_Test {
    @isTest static void confirmDocumentReceipt() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        WQconfirmDocumentReceiptV2_Req_IB_v1.createDummyRequest();
 
         
        Test.setMock(HttpCalloutMock.class, new WQconfirmDocumentReceiptV2_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new list<String> {'Jitterbit Auth Path'});
        IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.WQconfirmDocumentReceiptV2_STRING});
        Integration_API__c apiIntRec =Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.WQconfirmDocumentReceiptV2_STRING);
        system.debug('********apiIntRec**********'+apiIntRec);
        system.assertNotEquals(apiIntRec,null);
        
       
        Account testAccount= new Account();
        testAccount.Name = 'Test Name';
        testAccount.Country_of_Incorporation__c='South Africa';
        testAccount.Client_Group__c = 'Non Individual';
        testAccount.CASA_Reference_Number__c = '12233';
        testAccount.CIF__c = '';
        testAccount.Countries_Traded_With__c = 'South Africa';
        testAccount.Source_of_Income__c = 'Donation';
        insert testAccount;
       Test.startTest();
        List<String> docCodes = new List<String>();
        docCodes.add('001');
        docCodes.add('005');
        Map<WQconfirmDocumentReceiptV2_Resp_IB_v1, Sys_Log_Integration__c> respLog;
        respLog = WQconfirmDocumentReceiptV2_IH_v1.confirmDocumentReceipt(testAccount, docCodes,'1','1',false);
        System.assertNotEquals(null, respLog);
        Test.stopTest();
        WQconfirmDocumentReceiptV2_Resp_IB_v1.createdummyResponse();
        WQconfirmDocumentReceiptV2_IU_v1.mapRequestFields(testAccount,docCodes,'1','1');
    }

    
    @isTest static void confirmDocumentReceiptClientException(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();    
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.WQconfirmDocumentReceiptV2_STRING});
        
        Test.startTest();
        // This causes a fake response to be sent from the class without implementing HttpCalloutMock to cause an exception.
         Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
        
         List<String> docCodes = new List<String>();
        docCodes.add('001');
        docCodes.add('005');
        Map<WQconfirmDocumentReceiptV2_Resp_IB_v1, Sys_Log_Integration__c> respLog;
        respLog = WQconfirmDocumentReceiptV2_IH_v1.confirmDocumentReceipt(testDataFactory.testAccount, docCodes,'1','1',false);
        System.assertNotEquals(null, respLog);
        Test.stopTest();
        WQconfirmDocumentReceiptV2_Resp_IB_v1.createdummyResponse();
    }
    
    @isTest static void confirmDocumentReceiptClientNoIntegrationSettings(){
        
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();    
        testDataFactory.testAccount.Occupation_Status__pc=null;
        testDataFactory.testAccount.Occupation_Category__pc=null;
        testDataFactory.testAccount.Income_Source__pc=null;
        
        Test.startTest();
          Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
        
         List<String> docCodes = new List<String>();
        docCodes.add('001');
        docCodes.add('005');
        Map<WQconfirmDocumentReceiptV2_Resp_IB_v1, Sys_Log_Integration__c> respLog;
        respLog = WQconfirmDocumentReceiptV2_IH_v1.confirmDocumentReceipt(testDataFactory.testAccount, docCodes,'1','1',false);
        System.assertNotEquals(null, respLog);
        Test.stopTest();
        WQconfirmDocumentReceiptV2_Resp_IB_v1.createdummyResponse();
    }
    
    @isTest static void confirmDocumentReceiptClientNoSettings() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
       
       
        WQconfirmDocumentReceiptV2_Req_IB_v1.createDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WQconfirmDocumentReceiptV2_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.WQconfirmDocumentReceiptV2_STRING});
         List<Integration_API__c> integrationRec= [select id from Integration_API__c];
        delete integrationRec;
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
        List<String> docCodes = new List<String>();
        docCodes.add('001');
        docCodes.add('005');
        Map<WQconfirmDocumentReceiptV2_Resp_IB_v1, Sys_Log_Integration__c> respLog;
        respLog = WQconfirmDocumentReceiptV2_IH_v1.confirmDocumentReceipt(testDataFactory.testAccount, docCodes,'1','1',false);
        System.assertNotEquals(null, respLog);
        Test.stopTest();
        WQconfirmDocumentReceiptV2_Resp_IB_v1.createdummyResponse();
    }
}