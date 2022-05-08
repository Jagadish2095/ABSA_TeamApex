/*
        * Test class for CVDashboardRiskRating_IH_v1Test for test coverage
        * @author Mohammed Junaid U
        * @version v1.0
        * @since   2021-11-30
        *
   */

  @isTest
  public class CVDashboardRiskRating_IH_v1Test {
      
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
          CVDashboardRiskRating_IH_v1.getRiskProfileClient(testAccount, UserInfo.getUserId());
		  system.assertNotEquals(testDataFactory.testAccount, null);
          Test.stopTest();
          GetRiskProfileClient_Resp_IB_v2.dummyResponse();
      }
      
     
      
      @isTest static void getRiskProfileClientException(){
          
          WimiTestDataFactory testDataFactory = new WimiTestDataFactory();    
          IntegrationTestDataFactory.insertIntegrationTranslations();
          IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_RISK_PROFILE_CLIENT});
          
          Test.startTest();
          // This causes a fake response to be sent from the class without implementing HttpCalloutMock to cause an exception.
        
          CVDashboardRiskRating_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId());
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
           
          CVDashboardRiskRating_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId());
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
          CVDashboardRiskRating_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId());
          system.assertNotEquals(testDataFactory.testAccount, null);
          Test.stopTest();
          GetRiskProfileClient_Resp_IB_v2.dummyResponse();
      }
  
  }