/*
 * Test Integration Handler for SVcreateLinkSavingsDepAccount_IH_v1 Service
 * @author Srikanth N
 * @created 2020-02-06
 */   


@isTest
public class SVcreateLinkSavingsDepAccount_IH_v1_Test {



     @isTest static void SVcreateLinkSavingsDepAccountPositive() {
          Test.startTest();
         SVcreateLinkSavingsDepAccount_Req_IB_v1 dummyReqBean = SVcreateLinkSavingsDepAccount_Req_IB_v1.createDummyRequest();
         SVcreateLinkSavingsDepAccount_Resp_IB_v1 dummyResponseBean = SVcreateLinkSavingsDepAccount_Resp_IB_v1.dummyResponse();
         
          
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        insert testOpp;
        
       Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
         
          
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SVcreateLinkSavingsDepAcountMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.SVcreateLinkSavingsDepAccount_STRING});
        SVcreateLinkSavingsDepAccount_IH_v1.callToSVcreateLinkSavingsDepAccount(testOpportunity.Id,testOpportunityLineItem.Id,'Test','Test','Test','Test','Test','L');


        
        //SVcreateLinkSavingsDepAccount_IU_v1.mapRequestdFields();
       
          Test.stopTest();
    }
        @isTest static void SVcreateLinkSavingsDepAccountNoIntegrationSettings() {
          SVcreateLinkSavingsDepAccount_Req_IB_v1.createDummyRequest();
          SVcreateLinkSavingsDepAccount_Resp_IB_v1.dummyResponse();
        Opportunity testOpp = new Opportunity();
        testOpp.Name = 'Test Opp';
        testOpp.CloseDate = Date.today();
        testOpp.StageName = 'Drafting';
        insert testOpp;
        
       Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        Test.startTest();
        
        Map<SVcreateLinkSavingsDepAccount_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SVcreateLinkSavingsDepAccount_IH_v1.callToSVcreateLinkSavingsDepAccount(testOpportunity.Id,testOpportunityLineItem.Id,'Test','Test','Test','Test','Test','L');
        // Get first key from the map
        SVcreateLinkSavingsDepAccount_Resp_IB_v1 responseBean = (new List<SVcreateLinkSavingsDepAccount_Resp_IB_v1>(responseMap.keySet()))[0];
        
        Test.stopTest();
    }
}