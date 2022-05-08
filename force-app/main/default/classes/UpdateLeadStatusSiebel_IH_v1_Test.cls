@IsTest
public class UpdateLeadStatusSiebel_IH_v1_Test {
        
	@isTest static void updateLeadStatusSiebel() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings and Insert Integration Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_LEAD_STATUS_SIEBEL});
        IntegrationTestDataFactory.insertIntegrationTranslations();

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateLeadStatusSiebelMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        UpdateLeadStatusSiebel_Resp_IB_v1 siebelResponse = UpdateLeadStatusSiebel_IH_v1.updateLeadStatusSiebel(testDataFactory.testOpportunity.id, 'Sale Successful', '1-BSGP6F', 'Estate Provider Plan', 'Closed');
        System.assertEquals(200, siebelResponse.statusCode);
        Test.stopTest();
	}
    
	@isTest static void updateLeadStatusSiebelNegativeResponse() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings and Insert Integration Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_LEAD_STATUS_SIEBEL});
        IntegrationTestDataFactory.insertIntegrationTranslations();

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateLeadStatusSiebelMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        UpdateLeadStatusSiebel_Resp_IB_v1 siebelResponse = UpdateLeadStatusSiebel_IH_v1.updateLeadStatusSiebel(testDataFactory.testOpportunity.id, 'Sale Successful', null, 'Estate Provider Plan', 'Closed');
        System.assertEquals(400, siebelResponse.statusCode);
        Test.stopTest();
	}
    
	@isTest static void updateLeadStatusSiebelNoClosedReason() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings and Insert Integration Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_LEAD_STATUS_SIEBEL});
        IntegrationTestDataFactory.insertIntegrationTranslations();

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateLeadStatusSiebelMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        UpdateLeadStatusSiebel_Resp_IB_v1 siebelResponse = UpdateLeadStatusSiebel_IH_v1.updateLeadStatusSiebel(testDataFactory.testOpportunity.id, 'No Reason', '1-BSGP6F', 'Estate Provider Plan', 'Closed');
        System.assertEquals(500, siebelResponse.statusCode);
        Test.stopTest();
	}
    
	@isTest static void updateLeadStatusSiebelEmptyClosedReason() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings and Insert Integration Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_LEAD_STATUS_SIEBEL});
        IntegrationTestDataFactory.insertIntegrationTranslations();

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateLeadStatusSiebelMock_ApiRest(StringConstants.POSITIVE_STRING));
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        UpdateLeadStatusSiebel_Resp_IB_v1 siebelResponse = UpdateLeadStatusSiebel_IH_v1.updateLeadStatusSiebel(testDataFactory.testOpportunity.id, '', '1-BSGP6F', 'Estate Provider Plan', 'Closed');
        System.assertEquals(200, siebelResponse.statusCode);
        Test.stopTest();
	}
    
	@isTest static void updateLeadStatusSiebelNoOpportunityProduct() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings and Insert Integration Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_LEAD_STATUS_SIEBEL});
        IntegrationTestDataFactory.insertIntegrationTranslations();

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateLeadStatusSiebelMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        UpdateLeadStatusSiebel_Resp_IB_v1 siebelResponse = UpdateLeadStatusSiebel_IH_v1.updateLeadStatusSiebel(testDataFactory.testOpportunity.id, 'Sale Successful', '1-BSGP6F', 'No Product', 'Closed');
        System.assertEquals(500, siebelResponse.statusCode);
        Test.stopTest();
	}
    
	@isTest static void updateLeadStatusSiebelNullOpportunity() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings and Insert Integration Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_LEAD_STATUS_SIEBEL});
        IntegrationTestDataFactory.insertIntegrationTranslations();

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateLeadStatusSiebelMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        UpdateLeadStatusSiebel_Resp_IB_v1 siebelResponse = UpdateLeadStatusSiebel_IH_v1.updateLeadStatusSiebel(null, 'Sale Successful', '1-BSGP6F', 'Estate Provider Plan', 'Closed');
        System.assertEquals(500, siebelResponse.statusCode);
        Test.stopTest();
	}
    
    @isTest static void updateLeadStatusSiebelException() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Settings and Insert Integration Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.UPDATE_LEAD_STATUS_SIEBEL});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        // This causes a fake response to be sent from the class without implementing HttpCalloutMock to cause an exception.
        UpdateLeadStatusSiebel_IH_v1.updateLeadStatusSiebel(testDataFactory.testOpportunity.id, 'Sale Successful', '1-BSGP6F', 'Estate Provider Plan', 'Closed');
        Test.stopTest();
    }
    
	@isTest static void updateLeadStatusSiebelNoIntegrationSettings() {
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        //Insert Integration Translations
        IntegrationTestDataFactory.insertIntegrationTranslations();

        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new UpdateLeadStatusSiebelMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        Test.startTest();
        // This causes a fake response to be sent from the class that implements HttpCalloutMock. 
        UpdateLeadStatusSiebel_Resp_IB_v1 siebelResponse = UpdateLeadStatusSiebel_IH_v1.updateLeadStatusSiebel(testDataFactory.testOpportunity.id, 'Sale Successful', null, 'Estate Provider Plan', 'Closed');
        System.assertEquals(500, siebelResponse.statusCode);
        Test.stopTest();
	}
}