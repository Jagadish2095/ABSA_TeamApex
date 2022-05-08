@isTest
public class CheckDigitVerification_IH_v1_Test {
    
    @isTest static void checkDigitVerification(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CheckDigitVerificationMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CHECK_DIGIT_VERIFICATION});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        CheckDigitVerification_IH_v1.checkDigitVerification('0000009050515220', '632005', '01', 'DR', '', '0', 'Sales', 'Salesforce', 'E', 'STD', 'N');
        Test.stopTest();
    }
	    
    @isTest static void checkDigitVerificationException(){
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CHECK_DIGIT_VERIFICATION});
        Test.startTest();
        // This causes a fake response to be sent from the class without implementing HttpCalloutMock to cause an exception.
        CheckDigitVerification_IH_v1.checkDigitVerification('0000009050515220', '632005', '01', 'DR', '', '0', 'Sales', 'Salesforce', 'E', 'STD', 'N');
        Test.stopTest();
    }
    
    @isTest static void checkDigitVerificationDummyTest(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CheckDigitVerificationMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CHECK_DIGIT_VERIFICATION});
        
        Test.startTest();
        CheckDigitVerification_Req_IB_v1 req = new CheckDigitVerification_Req_IB_v1();
        req.createDummyRequest();
        Test.stopTest();
    }
    
    @isTest static void checkDigitVerificationNegative(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CheckDigitVerificationMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CHECK_DIGIT_VERIFICATION});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        CheckDigitVerification_IH_v1.checkDigitVerification('0000009050515220', '632005', '01', 'DR', '', '0', 'Sales', 'Salesforce', 'E', 'STD', 'N');
        Test.stopTest();
    }
    
    @isTest static void checkDigitVerificationNoIntegrationSettings(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CheckDigitVerificationMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
        CheckDigitVerification_IH_v1.checkDigitVerification('0000009050515220', '632005', '01', 'DR', '', '0', 'Sales', 'Salesforce', 'E', 'STD', 'N');
        Test.stopTest();
    }
}