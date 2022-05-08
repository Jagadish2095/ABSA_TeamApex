@isTest
public class ComplianceViewControllerTest {
    
    public static testMethod void testComplianceView(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.setMock(HttpCalloutMock.class, new GetRegulatoryComplianceMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_COMPLIANCE_INFO});

        Test.startTest();
        
        ComplianceViewController.getMissingData(testDataFactory.testOpportunity.id);
       	ComplianceViewController.updateCheckboxes(testDataFactory.testOpportunity.id, true, true);
        
        Test.stopTest();
    }
    
    public static testMethod void testComplianceViewContact(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.setMock(HttpCalloutMock.class, new GetRegulatoryComplianceMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_COMPLIANCE_INFO});

        Test.startTest();
        
        ComplianceViewController.getMissingData(testDataFactory.testContact.id);
       	ComplianceViewController.updateCheckboxes(testDataFactory.testContact.id, true, true);
        
        Test.stopTest();
    }
}