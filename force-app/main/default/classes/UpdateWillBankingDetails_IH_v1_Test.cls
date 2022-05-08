@isTest
public class UpdateWillBankingDetails_IH_v1_Test {

    @isTest static void updateWillBankingDetailsPositiveTest(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WillBankingDetailsMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_WILL_BANKING_DETAILS});
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = UpdateWillBankingDetails_IH_v1.updateWillBankingDetails('41002347654', '632008', 'ABSA', '8145', 'ABSA CENTURION MALL', 'SAVINGS', '9573338765', 'MRS GINA XABA', '20190130');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void updateWillBankingDetailsNegativeTest(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WillBankingDetailsMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_WILL_BANKING_DETAILS});
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = UpdateWillBankingDetails_IH_v1.updateWillBankingDetails('41002347654', '632008', 'ABSA', '8145', 'ABSA CENTURION MALL', 'SAVINGS', '9573338765', 'MRS GINA XABA', '20190130');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void updateWillBankingDetailsNoIntegrationSettingsTest(){
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = UpdateWillBankingDetails_IH_v1.updateWillBankingDetails('41002347654', '632008', 'ABSA', '8145', 'ABSA CENTURION MALL', 'SAVINGS', '9573338765', 'MRS GINA XABA', '20190130');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
    
    @isTest static void updateWillBankingDetailsExceptionTest(){
        
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_WILL_BANKING_DETAILS});
        
        Test.startTest();
        // Call the method to test
        WillBankingDetails_IB_v1 responseBean = UpdateWillBankingDetails_IH_v1.updateWillBankingDetails('41002347654', '632008', 'ABSA', '8145', 'ABSA CENTURION MALL', 'SAVINGS', '9573338765', 'MRS GINA XABA', '20190130');
        System.debug('responseBean :' + responseBean);
        Test.stopTest();
    }
}