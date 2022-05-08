/**
* Test class for RiskScreeningContoller class
* @author  Kyle Alexander
* @created 2018-09-26
*/

@isTest
public class RiskScreeningControllerTest {
    
    public static testMethod void testRiskScreening(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RiskProfileJointClientMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings and Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.RISK_PROFILE_JOINT_CLIENT});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        RiskScreeningController.getAccountData(testDataFactory.testOpportunity.id);
        RiskScreeningController.getCountriesTradedData(testDataFactory.testOpportunity.id);
        RiskScreeningController.checkInitValidity(testDataFactory.testOpportunity.id);
        RiskScreeningController.checkCASAValidity(testDataFactory.testOpportunity.id);
        RiskScreeningController.getCasaStatus(testDataFactory.testOpportunity.id);
        RiskScreeningController.getRiskRatingData(testDataFactory.testOpportunity.id);
        RiskScreeningController.getRiskRatingData(testDataFactory.willOpportunity.id);
        RiskScreeningController.getAccountRecordType(testDataFactory.testOpportunity.id);
        RiskScreeningController.updateAccountAndDoRiskScreening(testDataFactory.testOpportunity.id, testDataFactory.testAccount);
        RiskScreeningController.updateAccountAndDoRiskScreening(testDataFactory.willOpportunity.id, testDataFactory.testAccount);
        RiskScreeningController.getselectOptions(testDataFactory.testFna, 'Life_Policies_Action__c');
        
        Test.stopTest();
    }
    
    public static testMethod void testRiskScreeningJointAccount(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RiskProfileJointClientMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings and Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.RISK_PROFILE_JOINT_CLIENT});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        testDataFactory.testOpportunity.AccountId = testDataFactory.testJointAccount.Id;
        update testDataFactory.testOpportunity;
        testDataFactory.willOpportunity.AccountId = testDataFactory.testJointAccount.Id;
        update testDataFactory.willOpportunity;

        RiskScreeningController.getAccountRecordType(testDataFactory.testOpportunity.id);
        RiskScreeningController.updateAccountAndDoRiskScreening(testDataFactory.testOpportunity.id, testDataFactory.testJointAccount);
        RiskScreeningController.updateAccountAndDoRiskScreening(testDataFactory.willOpportunity.id, testDataFactory.testJointAccount);
        RiskScreeningController.getCasaStatus(testDataFactory.testOpportunity.id);
        
        Test.stopTest();
    }
    
    public static testMethod void testRiskScreeningJointAccountNegative(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RiskProfileJointClientMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings and Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.RISK_PROFILE_JOINT_CLIENT});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        testDataFactory.testProspectAccount.CASA_Reference_Number__pc = null;
        testDataFactory.testProspectAccount.Occupation__pc = null;
		testDataFactory.testProspectAccount.Income_Source__pc = null;
        testDataFactory.testProspectAccount.Occupation_Status__pc = null;
        testDataFactory.testProspectAccount.Income_Bracket__pc = null;
        testDataFactory.testProspectAccount.Occupation_Category__pc = null;
        update testDataFactory.testProspectAccount;
        
        testDataFactory.testOpportunity.AccountId = testDataFactory.testJointAccount.Id;
        update testDataFactory.testOpportunity;       

        RiskScreeningController.getAccountRecordType(testDataFactory.testOpportunity.id);
        RiskScreeningController.updateAccountAndDoRiskScreening(testDataFactory.testOpportunity.id, testDataFactory.testJointAccount);
        
        Test.stopTest();
    }
}