@isTest
public class GetRiskProfileClient_IH_v1_Test {
    
    @isTest static void getRiskProfileClient() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        GetRiskProfileClient_Req_IB_v1 dummyBean = new GetRiskProfileClient_Req_IB_v1();
        dummyBean.createDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetRiskProfileClientMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_RISK_PROFILE_CLIENT});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetRiskProfileClient_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId(), new list<String> {''}, new list<String> {''}, new list<String> {'South Africa'}, '61');
        Test.stopTest();
    }
    
    @isTest static void getRiskProfileClientWithInvalidAccountId() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();      
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetRiskProfileClientMock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_RISK_PROFILE_CLIENT});
        
        Test.startTest();
        GetRiskProfileClient_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId(), new list<String> {''}, new list<String> {''}, new list<String> {'South Africa'},'61');
        Test.stopTest();
    }
    
    @isTest static void getRiskProfileClientForReadTimedOut() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();      
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetRiskProfileClientMock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_RISK_PROFILE_CLIENT});
        
        Test.startTest();
        GetRiskProfileClient_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId(), new list<String> {''}, new list<String> {''}, new list<String> {'South Africa'},'61');
        Test.stopTest();
    }
    
    @isTest static void getRiskProfileClientException(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();    
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_RISK_PROFILE_CLIENT});
        
        Test.startTest();
        // This causes a fake response to be sent from the class without implementing HttpCalloutMock to cause an exception.
        GetRiskProfileClient_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId(), new list<String> {''}, new list<String> {''}, new list<String> {'South Africa'},'61');
        Test.stopTest();
    }
    
    @isTest static void getRiskProfileClientNegativeTranslation(){
        
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();    
        testDataFactory.testAccount.Occupation_Status__pc=null;
        testDataFactory.testAccount.Occupation_Category__pc=null;
        testDataFactory.testAccount.Income_Source__pc=null;
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_RISK_PROFILE_CLIENT});
        
        Test.startTest();
        
        GetRiskProfileClient_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId(), new list<String> {''}, new list<String> {''}, new list<String> {'South Africa'},'61');
        Test.stopTest();
    }
    
    @isTest static void getRiskProfileClientNoIntegrationSettings(){
        
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();    
        testDataFactory.testAccount.Occupation_Status__pc=null;
        testDataFactory.testAccount.Occupation_Category__pc=null;
        testDataFactory.testAccount.Income_Source__pc=null;
        
        Test.startTest();
        
        GetRiskProfileClient_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId(), new list<String> {''}, new list<String> {''}, new list<String> {'South Africa'},'61');
        Test.stopTest();
    }
    
    @isTest static void getRiskProfileClientNoCountries() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        GetRiskProfileClient_Req_IB_v1 dummyBean = new GetRiskProfileClient_Req_IB_v1();
        dummyBean.createDummyRequest();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetRiskProfileClientMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Translation records
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_RISK_PROFILE_CLIENT});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetRiskProfileClient_IH_v1.getRiskProfileClient(testDataFactory.testAccount, UserInfo.getUserId(), new list<String> {''}, new list<String> {''}, new list<String> {''},'61');
        Test.stopTest();
    }
  
}