@isTest
public class RiskProfileJointClient_IH_v1_Test {
    
    @isTest 
    public static void testRiskProfileJntClientPositive(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RiskProfileJointClientMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings and Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.RISK_PROFILE_JOINT_CLIENT});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Contact testContact = new Contact();
        testContact.Occupation_Status__c = 'Full Time Employed';
        testContact.Occupation_Category__c = 'Advertising';
        testContact.Income_Source__c = 'Bonus';
        
        //Code coverage for the dummy request method in the request bean class
        RiskProfileJointClient_Req_IB_v1 requestBean = RiskProfileJointClient_Req_IB_v1.createDummy();
        
        Test.startTest();
        // Call the method to test
        RiskProfileJointClient_Resp_IB_v1 responseBean = RiskProfileJointClient_IH_v1.riskProfileJntClient(testDataFactory.testAccount, new List<Account>{testDataFactory.testProspectAccount}, new List<String>{''}, new List<String>{''}, new List<String>{'South Africa'}, '','61');
       // System.debug('responseBean :' + responseBean);
       System.assertNotEquals('', responseBean.riskRating);
        Test.stopTest();
    }
    
    @isTest 
    
    public static void testRiskProfileJntClientNegative(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RiskProfileJointClientMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings and Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.RISK_PROFILE_JOINT_CLIENT});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Contact testContact = new Contact();
        testContact.Occupation_Status__c = 'Full Time Employed';
        testContact.Occupation_Category__c = 'Advertising';
        testContact.Income_Source__c = 'Bonus';
        
        Test.startTest();
        // Call the method to test
        RiskProfileJointClient_Resp_IB_v1 responseBean = RiskProfileJointClient_IH_v1.riskProfileJntClient(testDataFactory.testAccount, new List<Account>{testDataFactory.testProspectAccount}, new List<String>{''}, new List<String>{''}, new List<String>{'South Africa'}, '','61');
        System.assertNotEquals('', responseBean.riskRating);
        Test.stopTest();
    }
    
    @isTest 
    public static void testRiskProfileJntClientNoIntegrationSettings(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RiskProfileJointClientMock_ApiRest(StringConstants.NEGATIVE_STRING));
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Contact testContact = new Contact();
        testContact.Occupation_Status__c = 'Full Time Employed';
        testContact.Occupation_Category__c = 'Advertising';
        testContact.Income_Source__c = 'Bonus';
        
        Test.startTest();
        // Call the method to test
        RiskProfileJointClient_Resp_IB_v1 responseBean = RiskProfileJointClient_IH_v1.riskProfileJntClient(testDataFactory.testAccount, new List<Account>{testDataFactory.testProspectAccount}, new List<String>{''}, new List<String>{''}, new List<String>{'South Africa'}, '','61');
        System.assertNotEquals('', responseBean.riskRating);
        Test.stopTest();
    }
    
    @isTest 
    public static void testRiskProfileJntClientNoIntegrationTranslations(){
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new RiskProfileJointClientMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.RISK_PROFILE_JOINT_CLIENT});
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Contact testContact = new Contact();
        testContact.Occupation_Status__c = 'Full Time Employed';
        testContact.Occupation_Category__c = 'Advertising';
        testContact.Income_Source__c = 'Bonus';
        
        Test.startTest();
        // Call the method to test
        RiskProfileJointClient_Resp_IB_v1 responseBean = RiskProfileJointClient_IH_v1.riskProfileJntClient(testDataFactory.testAccount, new List<Account>{testDataFactory.testProspectAccount}, new List<String>{''}, new List<String>{''}, new List<String>{'South Africa'}, '','61');
       System.assertNotEquals('', responseBean.riskRating);
        Test.stopTest();
    }
    
    @isTest 
    public static void testRiskProfileJntClientNoMock(){
        
        //Insert Integration Settings and Translations
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.RISK_PROFILE_JOINT_CLIENT});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Contact testContact = new Contact();
        testContact.Occupation_Status__c = 'Full Time Employed';
        testContact.Occupation_Category__c = 'Advertising';
        testContact.Income_Source__c = 'Bonus';
        
        Test.startTest();
        // Call the method to test
        RiskProfileJointClient_Resp_IB_v1 responseBean = RiskProfileJointClient_IH_v1.riskProfileJntClient(testDataFactory.testAccount, new List<Account>{testDataFactory.testProspectAccount}, new List<String>{''}, new List<String>{''}, new List<String>{'South Africa'}, '','61');
        System.assertNotEquals('', responseBean.riskRating);
        Test.stopTest();
    }
    
}