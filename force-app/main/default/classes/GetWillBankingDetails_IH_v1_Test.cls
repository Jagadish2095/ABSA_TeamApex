@isTest
public class GetWillBankingDetails_IH_v1_Test {
    
    @isTest static void testGetWillBankingDetailsPositive(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WillBankingDetailsMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_WILL_BANKING_DETAILS});
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = GetWillBankingDetails_IH_v1.getWillBankingDetails('41000003904');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testGetWillBankingDetailsNegative(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WillBankingDetailsMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_WILL_BANKING_DETAILS});
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = GetWillBankingDetails_IH_v1.getWillBankingDetails('');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testGetWillBankingDetailsNoIntegrationSettings(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WillBankingDetailsMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = GetWillBankingDetails_IH_v1.getWillBankingDetails('41000003904');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testGetWillBankingDetailsNoMock(){
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_WILL_BANKING_DETAILS});
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = GetWillBankingDetails_IH_v1.getWillBankingDetails('41000003904');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
}