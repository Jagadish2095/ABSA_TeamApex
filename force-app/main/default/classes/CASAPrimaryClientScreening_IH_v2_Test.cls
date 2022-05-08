@isTest
public class CASAPrimaryClientScreening_IH_v2_Test {
    
    //Primary Account
    @isTest static void CASAPrimaryClientScreeningPositiveResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2});
        
        Test.startTest();
        CASAPrimaryClientScreening_Resp_IB_v2 response = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreening(testDataFactory.testAccount, UserInfo.getUserId(), '', '', '');
        System.assertEquals(200, response.statusCode);
        Test.stopTest();
    }
    
    
    @isTest static void CASAPrimaryClientScreeningNegativeResponseWithInvalidAccAndUserID() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2});
        
        Test.startTest();
        CASAPrimaryClientScreening_Resp_IB_v2 response = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreening(null, testDataFactory.testOpportunity.Id, '', '', '');
        System.assertEquals(500, response.statusCode);
        Test.stopTest();
    }
    
    @isTest static void CASAPrimaryClientScreeningNegativeNoMockResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        CASAPrimaryClientScreening_Resp_IB_v2 response = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreening(testDataFactory.testAccount, UserInfo.getUserId(), '', '', '');
        System.assertEquals(500, response.statusCode);
        Test.stopTest();
    }
    
    @isTest static void CASAPrimaryClientScreeningDummyRequest() {
        
        Test.startTest();
        CASAPrimaryClientScreening_Req_IB_v1 casaPrimaryClientScreeningRequest = new CASAPrimaryClientScreening_Req_IB_v1();
        casaPrimaryClientScreeningRequest.createDummyRequest();
        Test.stopTest();
        
    }
    
    @isTest static void CASAPrimaryClientScreeningNoTranslations() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2});
        
        Test.startTest();
        CASAPrimaryClientScreening_Resp_IB_v2 response = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreening(testDataFactory.testAccount, UserInfo.getUserId(), '', '', '');
        System.assertEquals(500, response.statusCode);
        Test.stopTest();
    }
    
    //Primary Account & Related Party
    @isTest static void screenRelatedPartyJointAccPositive() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedParty_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2, StringConstants.CASA_SCREEN_RELATED_PARTY});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        testDataFactory.testAccount.Country_of_Registration__c = 'South Africa';
        
        List<User> userList = [Select AB_Number__c From User Where AB_Number__c != null];
        
        Test.startTest();
        
        CASAPrimaryClientScreening_IH_v2.cls_jointScreening responseBean = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreeningJointClient(testDataFactory.testAccount, new List<Account> {testDataFactory.testProspectAccount}, userInfo.getUserId(), '', '', '');
        System.debug('CASA Primary Client Screen responseBean: '+ responseBean);
        //System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
        @isTest static void screenRelatedPartyJointAccNoIntegrationSettings() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedParty_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        testDataFactory.testAccount.Country_of_Registration__c = 'South Africa';
        
        List<User> userList = [Select AB_Number__c From User Where AB_Number__c != null];
        
        Test.startTest();
        
        CASAPrimaryClientScreening_IH_v2.cls_jointScreening responseBean = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreeningJointClient(testDataFactory.testAccount, new List<Account> {testDataFactory.testProspectAccount}, userInfo.getUserId(), '', '', '');
        System.debug('CASA Primary Client Screen responseBean: '+ responseBean);
        //System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
        @isTest static void screenRelatedPartyJointAccNoIntegrationTranslations() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedParty_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2, StringConstants.CASA_SCREEN_RELATED_PARTY});
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        testDataFactory.testAccount.Country_of_Registration__c = 'South Africa';
        
        List<User> userList = [Select AB_Number__c From User Where AB_Number__c != null];
        
        Test.startTest();
        
        CASAPrimaryClientScreening_IH_v2.cls_jointScreening responseBean = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreeningJointClient(testDataFactory.testAccount, new List<Account> {testDataFactory.testProspectAccount}, userInfo.getUserId(), '', '', '');
        System.debug('CASA Primary Client Screen responseBean: '+ responseBean);
        //System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void screenRelatedPartyJointAccNoMock() {
        
        // Set mock callout class 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2, StringConstants.CASA_SCREEN_RELATED_PARTY});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        testDataFactory.testAccount.Country_of_Registration__c = 'South Africa';
        
        List<User> userList = [Select AB_Number__c From User Where AB_Number__c != null];
        
        Test.startTest();
        
        CASAPrimaryClientScreening_IH_v2.cls_jointScreening responseBean = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreeningJointClient(testDataFactory.testAccount, new List<Account> {testDataFactory.testProspectAccount}, userInfo.getUserId(), '', '', '');
        System.debug('CASA Primary Client Screen responseBean: '+ responseBean);
        //System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    @isTest static void screenRelatedPartyJointAccNegative() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedParty_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2, StringConstants.CASA_SCREEN_RELATED_PARTY});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        testDataFactory.testAccount.Country_of_Registration__c = 'South Africa';
        
        List<User> userList = [Select AB_Number__c From User Where AB_Number__c != null];
        
        Test.startTest();
        
        CASAPrimaryClientScreening_IH_v2.cls_jointScreening responseBean = CASAPrimaryClientScreening_IH_v2.casaPrimaryClientScreeningJointClient(new Account(), new List<Account> {testDataFactory.testProspectAccount}, testDataFactory.testAccount.Id, '', '', '');
        System.debug('CASA Primary Client Screen responseBean: '+ responseBean);
        //System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
}