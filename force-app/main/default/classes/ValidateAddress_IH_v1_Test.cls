@isTest
public class ValidateAddress_IH_v1_Test {

    @isTest static void validateAddressPositive() {
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_ADDRESS});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ValidateAddressMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        ValidateAddress_Resp_IB_v1 responseBean = ValidateAddress_IH_v1.validateAddressDetails('E', 1, 10, '5 Libertas Road', 'PostalAddressLine2', 'Bryanston', 'Johannesburg', '2191');
        Test.stopTest();
	}
    
    @isTest static void validateAddressNegative() {
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_ADDRESS});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        ValidateAddress_Resp_IB_v1 responseBean = ValidateAddress_IH_v1.validateAddressDetails('E', 1, 10, '5 Libertas Road', 'PostalAddressLine2', 'Bryanston', 'Johannesburg', '2191');
        Test.stopTest();
	}
    
    @isTest static void validateAddressNoIntegrationSettings() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ValidateAddressMock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        ValidateAddress_Resp_IB_v1 responseBean = ValidateAddress_IH_v1.validateAddressDetails('E', 1, 10, '5 Libertas Road', 'PostalAddressLine2', 'Bryanston', 'Johannesburg', '2191');
        Test.stopTest();
	}
}