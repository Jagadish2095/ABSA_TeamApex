@isTest
public class IntegrationTestDataFactoryTest {

    @isTest static void insertIntegrationSettingsTest() {
        
        Test.startTest();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.VALIDATE_CLIENT_DETAILS});
        Test.stopTest();
    }
    
    @isTest static void insertTranslationsTest() {
        
        Test.startTest();
        IntegrationTestDataFactory.insertIntegrationTranslations();
        Test.stopTest();
    }
}