@isTest
public class AccountVerification_IH_v1_Test {
    
    @isTest static void testAccountVerificationPositive(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AccountVerificationMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ACCOUNT_VERIFICATION_DETAILS});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        // Call the method to test
        AccountVerification_Resp_IB_v1 responseBean = AccountVerification_IH_v1.accountVerification('56464', '632005', 'ABSA BANK LIMITED', 'Savings', testDataFactory.testAccount, 'AVSR004000', '', '');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testAccountVerificationNegative(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AccountVerificationMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ACCOUNT_VERIFICATION_DETAILS});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        // Call the method to test
        AccountVerification_Resp_IB_v1 responseBean = AccountVerification_IH_v1.accountVerification('56464', '632005', 'ABSA BANK LIMITED', 'Savings', testDataFactory.testAccount, 'AVSR004000', '', '');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testAccountVerificationNoIntegrationSettings(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AccountVerificationMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        // Call the method to test
        AccountVerification_Resp_IB_v1 responseBean = AccountVerification_IH_v1.accountVerification('56464', '632005', 'ABSA BANK LIMITED', 'Savings', testDataFactory.testAccount, 'AVSR004000', '', '');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testAccountVerificationNoIntegrationTranslations(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AccountVerificationMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ACCOUNT_VERIFICATION_DETAILS});
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        // Call the method to test
        AccountVerification_Resp_IB_v1 responseBean = AccountVerification_IH_v1.accountVerification('56464', '632005', 'ABSA BANK LIMITED', 'Savings', testDataFactory.testAccount, 'AVSR004000', '', '');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testAccountVerificationNoMock(){
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ACCOUNT_VERIFICATION_DETAILS});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        
        Test.startTest();
        // Call the method to test
        AccountVerification_Resp_IB_v1 responseBean = AccountVerification_IH_v1.accountVerification('56464', '632005', 'ABSA BANK LIMITED', 'Savings', testDataFactory.testAccount, 'AVSR004000', '', '');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    
    @isTest static void testAccountVerificationCreateDummy(){
        AccountVerification_Req_IB_v1 requestBean = AccountVerification_Req_IB_v1.createDummy();
    }
    
}