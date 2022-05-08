@isTest
public class CreateWillBankingDetails_IH_v1_Test {
    
    @isTest static void testCreateWillBankingDetailsPositive(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WillBankingDetailsMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_WILL_BANKING_DETAILS});
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = CreateWillBankingDetails_IH_v1.createWillBankingDetails('41000993807', '632005', 'ABSA CENTURION MALL', 'ABSA', '8443', 'SAVINGS', '9083331111', 'MR RAY MANO', '20190131');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testCreateWillBankingDetailsNegative(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WillBankingDetailsMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_WILL_BANKING_DETAILS});
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = CreateWillBankingDetails_IH_v1.createWillBankingDetails('41000993807', '632005', 'ABSA CENTURION MALL', 'ABSA', '8443', 'SAVINGS', '9083331111', 'MR RAY MANO', '20190131');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testCreateWillBankingDetailsNoIntegrationSettings(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WillBankingDetailsMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = CreateWillBankingDetails_IH_v1.createWillBankingDetails('41000993807', '632005', 'ABSA CENTURION MALL', 'ABSA', '8443', 'SAVINGS', '9083331111', 'MR RAY MANO', '20190131');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void testCreateWillBankingDetailsNoMock(){
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CREATE_WILL_BANKING_DETAILS});
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = CreateWillBankingDetails_IH_v1.createWillBankingDetails('41000993807', '632005', 'ABSA CENTURION MALL', 'ABSA', '8443', 'SAVINGS', '9083331111', 'MR RAY MANO', '20190131');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
}