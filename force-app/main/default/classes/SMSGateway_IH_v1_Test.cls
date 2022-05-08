@isTest
public class SMSGateway_IH_v1_Test {
    
    @isTest static void testSmsSubmitPositive(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ITOUCH_SUBMIT});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SMSGatewayMock_APIRest(StringConstants.POSITIVE_STRING, 'Success'));
        
        Test.startTest();
        // Call the method to test
        SMSGateway_Resp_IB_v1 responseBean = SMSGateway_IH_v1.submit('0000000000','test message', StringConstants.ITOUCH_SUBMIT);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testSmsSubmitPositiveWithError(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ITOUCH_SUBMIT});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SMSGatewayMock_APIRest(StringConstants.POSITIVE_STRING, 'Error'));
        
        Test.startTest();
        // Call the method to test
        SMSGateway_Resp_IB_v1 responseBean = SMSGateway_IH_v1.submit('0000000000','test message', StringConstants.ITOUCH_SUBMIT);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testSmsSubmitWithoutMock(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ITOUCH_SUBMIT});
        
        Test.startTest();
        // Call the method to test
        SMSGateway_Resp_IB_v1 responseBean = SMSGateway_IH_v1.submit('0000000000','test message', StringConstants.ITOUCH_SUBMIT);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testSmsSubmitNoIntegrationSettings(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SMSGatewayMock_APIRest(StringConstants.POSITIVE_STRING, 'Error'));
        
        Test.startTest();
        // Call the method to test
        SMSGateway_Resp_IB_v1 responseBean = SMSGateway_IH_v1.submit('0000000000','test message', StringConstants.ITOUCH_SUBMIT);
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testSmsSubmitPositive1(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ITOUCH_SUBMIT});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SMSGatewayMock_APIRest(StringConstants.POSITIVE_STRING, 'Success'));
        
        Test.startTest();
        // Call the method to test
        SMSGateway_Resp_IB_v1 responseBean = SMSGateway_IH_v1.submit('0000000000','test message', 'Test Name', testDataFactory.testOpportunity.Id, Userinfo.getUserId());
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testSmsSubmitPositiveOldParameters(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.ITOUCH_SUBMIT});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new SMSGatewayMock_APIRest(StringConstants.POSITIVE_STRING, 'Error'));
        
        Test.startTest();
        // Call the method to test
        SMSGateway_Resp_IB_v1 responseBean = SMSGateway_IH_v1.submit('0000000000','test message', 'Test Name', testDataFactory.testOpportunity.Id, Userinfo.getUserId());
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
}