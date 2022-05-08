@isTest
public class CASAScreenRelatedParty_IH_v1_Test {    
    
    @isTest static void screenRelatedPartyPositive() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedParty_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_SCREEN_RELATED_PARTY});
        User testUser = new User();
        testUser.AB_Number__c = 'ABAB111';
        Test.startTest();
        Map<CASAScreenRelatedParty_Resp_IB_v1, Sys_Log_Integration__c>  responseMap = CASAScreenRelatedParty_IH_v1.screenRelatedPartyMap(testDataFactory.testAccount, 'South Africa', 'South Africa', 'South African', 'iDTypeAccountP', testUser, 'primaryClientRefP', 'South Africa', 'SALESFORCE', 'sbuP', 'branchP', 'J', 'J');       
        Test.stopTest();
    }
    
    @isTest static void screenRelatedPartyNoIntegrationSettings() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedParty_ApiRest(StringConstants.POSITIVE_STRING));
        User testUser = new User();
        testUser.AB_Number__c = 'ABAB111';
        Test.startTest();
        Map<CASAScreenRelatedParty_Resp_IB_v1, Sys_Log_Integration__c>  responseMap = CASAScreenRelatedParty_IH_v1.screenRelatedPartyMap(testDataFactory.testAccount, 'South Africa', 'South Africa', 'South African', 'iDTypeAccountP', testUser, 'primaryClientRefP', 'South Africa', 'SALESFORCE', 'sbuP', 'branchP', 'J', 'J');       
        Test.stopTest();
    }
}