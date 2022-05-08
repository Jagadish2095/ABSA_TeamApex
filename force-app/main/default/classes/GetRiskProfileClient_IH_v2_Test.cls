/*
        * Test class for GetRiskProfileClient_IH_v2 for test coverage
        * @author Srikanth N : Absa
        * @version v1.0
        * @since   2019-12-03
        *
   */

  @isTest
  public class GetRiskProfileClient_IH_v2_Test {
      
      @isTest static void getRiskProfileClient() {
          
          WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
          GetRiskProfileClient_Req_IB_v2 dummyBean = new GetRiskProfileClient_Req_IB_v2();
          dummyBean.createDummyRequest();
          GetRiskProfileClient_IU_v2 dummyBean2 = new  GetRiskProfileClient_IU_v2();
          
          // Set mock callout class 
          Test.setMock(HttpCalloutMock.class, new GetRiskProfileClientMock_ApiRest(StringConstants.POSITIVE_STRING));
          //Insert Integration Translation records
          IntegrationTestDataFactory.insertIntegrationTranslations();
          IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_RISK_PROFILE_CLIENT});
          
         
          Account testAccount= new Account();
         // testAccount.Client_Group__c = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.CLIENT_TYPE_GROUP, testAccount.Client_Group__c.replace('Non Individual', 'Non-Individual'), StringConstants.OUTBOUND_RECORD_TYPE);    
          testAccount.Name = 'Test Name';
          testAccount.Country_of_Registration__c='South Africa';
          testAccount.Client_Group__c = 'Non Individual';
          testAccount.CASA_Reference_Number__c = '12233';
          testAccount.CIF__c = '';
          testAccount.Countries_Traded_With__c = 'South Africa';
          testAccount.Country_of_Operation__c = 'South Africa';
          testAccount.Country_of_Registration__c = 'South Africa';
          testAccount.Source_of_Income__c = 'Donation';
          insert testAccount;
          
          Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode = '1234' );
          insert prod;
          //system.debug('testAccount'+testAccount);
          
          Test.startTest();
          // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
          Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
          Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
          Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
          PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
          OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
          List<OpportunityLineItem> lineItemList = new  List<OpportunityLineItem>();
          lineItemList.add(testOpportunityLineItem); 
          //GetRiskProfileClient_IU_v2.mapRequestFields(testAccount, UserInfo.getUserId(),'1234');
          GetRiskProfileClient_IH_v2.getRiskProfileClient(testAccount, UserInfo.getUserId(),lineItemList);
          CVDashboardRiskRating_IH_v1.getRiskProfileClient(testAccount, UserInfo.getUserId());
          GetRiskProfileClient_IH_v2.getRiskProfileClientforSPM(testDataFactory.testAccount, UserInfo.getUserId(),testOpportunity);
          GetRiskProfileClient_IU_v2.mapRequestFieldsforSPM(testAccount, UserInfo.getUserId(), testOpportunity);
          GetRiskProfileClient_IH_v2.getRiskProfileClientCAF(testAccount, UserInfo.getUserId());
          GetRiskProfileClient_IU_v2.mapCAFRequestFields(testAccount, UserInfo.getUserId());
          GetRiskProfileClient_Resp_IB_v2 checkresponse = GetRiskProfileClient_IH_v2.getRiskProfileClient(testAccount, UserInfo.getUserId(),lineItemList);
          system.assertNotEquals(testDataFactory.testAccount, null);
          Test.stopTest();
          GetRiskProfileClient_Resp_IB_v2.dummyResponse();
      }
      
     /* @isTest static void getRiskProfileClientWithInvalidAccountId() {
          
          WimiTestDataFactory testDataFactory = new WimiTestDataFactory();      
          
          // Set mock callout class 
          Test.setMock(HttpCalloutMock.class, new GetRiskProfileClientMock_ApiRest(StringConstants.NEGATIVE_STRING)); 
          IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_RISK_PROFILE_CLIENT});
          
          Test.startTest();
          GetRiskProfileClient_IH_v2.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId(),'1234');
          Test.stopTest();
          GetRiskProfileClient_Resp_IB_v2.dummyResponse();
      }*/
      
      
      @isTest static void getRiskProfileClientException(){
          
          WimiTestDataFactory testDataFactory = new WimiTestDataFactory();    
          IntegrationTestDataFactory.insertIntegrationTranslations();
          IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_RISK_PROFILE_CLIENT});
          
          Test.startTest();
          // This causes a fake response to be sent from the class without implementing HttpCalloutMock to cause an exception.
           Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
          Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
          Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
          PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
          OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
             List<OpportunityLineItem> lineItemList = new  List<OpportunityLineItem>();
          lineItemList.add(testOpportunityLineItem); 
          CVDashboardRiskRating_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId());
          GetRiskProfileClient_IH_v2.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId(),lineItemList);
          GetRiskProfileClient_IH_v2.getRiskProfileClientforSPM(testDataFactory.testAccount, UserInfo.getUserId(),testOpportunity);
          GetRiskProfileClient_IH_v2.getRiskProfileClientCAF(testDataFactory.testAccount, UserInfo.getUserId());
          system.assertNotEquals(testDataFactory.testAccount, null);
          Test.stopTest();
          GetRiskProfileClient_Resp_IB_v2.dummyResponse();
      }
      
      @isTest static void getRiskProfileClientNoIntegrationSettings(){
          
          
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
          List<OpportunityLineItem> lineItemList = new  List<OpportunityLineItem>();
          lineItemList.add(testOpportunityLineItem); 
          CVDashboardRiskRating_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId());
         GetRiskProfileClient_IH_v2.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId(),lineItemList);
         GetRiskProfileClient_IH_v2.getRiskProfileClientforSPM(testDataFactory.testAccount, UserInfo.getUserId(),testOpportunity);
         GetRiskProfileClient_IH_v2.getRiskProfileClientCAF(testDataFactory.testAccount, UserInfo.getUserId());
          system.assertNotEquals(testDataFactory.testAccount, null);
          Test.stopTest();
          GetRiskProfileClient_Resp_IB_v2.dummyResponse();
      }
      
      @isTest static void getRiskProfileClientNoSettings() {
          
          WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
         
          GetRiskProfileClient_Req_IB_v1 dummyBean = new GetRiskProfileClient_Req_IB_v1();
          dummyBean.createDummyRequest();
          
          // Set mock callout class 
          Test.setMock(HttpCalloutMock.class, new GetRiskProfileClientMock_ApiRest(StringConstants.NEGATIVE_STRING));
          //Insert Integration Translation records
          IntegrationTestDataFactory.insertIntegrationTranslations();
          IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_RISK_PROFILE_CLIENT});
           List<Integration_API__c> integrationRec= [select id from Integration_API__c];
          delete integrationRec;
          Test.startTest();
          // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
           Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
          Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
          Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
          PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
          OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
          List<OpportunityLineItem> lineItemList = new  List<OpportunityLineItem>();
          lineItemList.add(testOpportunityLineItem); 
          CVDashboardRiskRating_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId());
          GetRiskProfileClient_IH_v2.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId(),lineItemList);
          GetRiskProfileClient_IH_v2.getRiskProfileClient(null, UserInfo.getUserId(),null);
          GetRiskProfileClient_IH_v2.getRiskProfileClientforSPM(testDataFactory.testAccount, UserInfo.getUserId(),testOpportunity);
          GetRiskProfileClient_IH_v2.getRiskProfileClientforSPM(null, UserInfo.getUserId(),null);
          GetRiskProfileClient_IH_v2.getRiskProfileClientCAF(testDataFactory.testAccount, UserInfo.getUserId());
          GetRiskProfileClient_IH_v2.getRiskProfileClientCAF(null, UserInfo.getUserId());
          system.assertNotEquals(testDataFactory.testAccount, null);
          Test.stopTest();
          GetRiskProfileClient_Resp_IB_v2.dummyResponse();
      }
  
  }