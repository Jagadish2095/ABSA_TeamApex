@isTest
public class GetBankClearanceCodes_IH_v1_Test {

    @isTest static void getBankClearanceCodes() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetBankClearanceCodesMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_BANK_CLEARANCE_CODES});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetBankClearanceCodes_IH_v1.getBankClearanceCodes('Sales', 'Salesforce', 'N', 'E', 'STD', 'AOL', 'ABSA', '');
        Test.stopTest();
	}
    
    @isTest static void getBankClearanceCodesException(){
        
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_BANK_CLEARANCE_CODES});
        
        Test.startTest();
        // This causes a fake response to be sent from the class without implementing HttpCalloutMock to cause an exception.
        GetBankClearanceCodes_IH_v1.getBankClearanceCodes('Sales', 'Salesforce', 'N', 'E', 'STD', 'AOL', 'ABSA', '');
        Test.stopTest();
    }
    
    @isTest static void getBankClearanceCodesNoIntegrationSettings() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetBankClearanceCodesMock_ApiRest(StringConstants.POSITIVE_STRING)); 
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetBankClearanceCodes_IH_v1.getBankClearanceCodes('Sales', 'Salesforce', 'N', 'E', 'STD', 'AOL', 'ABSA', '');
        Test.stopTest();
	}
    
    @isTest static void getBankClearanceCodesNegative() {
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetBankClearanceCodesMock_ApiRest(StringConstants.NEGATIVE_STRING)); 
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_BANK_CLEARANCE_CODES});
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        GetBankClearanceCodes_IH_v1.getBankClearanceCodes('Sales', 'Salesforce', 'N', 'E', 'STD', 'AOL', 'ABSA', '');
        Test.stopTest();
	}
}