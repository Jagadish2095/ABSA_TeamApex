@isTest
public class ComplianceSummaryControllerTest {
    
	public static testMethod void testComplianceSummaryCasa(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2});
        
        Test.startTest();
        
        ComplianceSummaryController.getSummaryData(testDataFactory.testOpportunity.id);
        
        Test.stopTest();
    }
    
    public static testMethod void testComplianceSummaryInvolvedParties(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        Test.startTest();
        
        ComplianceSummaryController.getSummaryData(testDataFactory.testOpportunity.id);
        
        Test.stopTest();
    }
    
    public static testMethod void testComplianceSummaryCasaBusinessClient(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2});
        
        Test.startTest();
        
        testDataFactory.testOpportunity.AccountId = testDataFactory.testJointAccount.Id;
        update testDataFactory.testOpportunity;
        
        ComplianceSummaryController.getSummaryData(testDataFactory.testOpportunity.id);
        
        Test.stopTest();
    }
    
    public static testMethod void testComplianceSummaryBusinessClient(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        testDataFactory.testOpportunity.AccountId = testDataFactory.testJointAccount.Id;
        update testDataFactory.testOpportunity;
        
        Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesJointMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        Test.startTest();
                
        ComplianceSummaryController.getSummaryData(testDataFactory.testOpportunity.id);
        
        Test.stopTest();
    }
}