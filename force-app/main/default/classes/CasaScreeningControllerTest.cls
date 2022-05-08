@isTest
public class CasaScreeningControllerTest {
    
    public static testMethod void testCasaScreening(){        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING, StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2});
        
        Test.startTest();
        
        CasaScreeningController.getAccountData(testDataFactory.testOpportunity.id);
        CasaScreeningController.checkInitValidity(testDataFactory.testOpportunity.id);
        CasaScreeningController.updateAccountAndDoCasaScreening(testDataFactory.testOpportunity.id, testDataFactory.testAccount);
        CasaScreeningController.checkCasaFieldsAndDoCasaScreening(testDataFactory.testOpportunity.id);
        CasaScreeningController.getselectOptions(testDataFactory.testFna, 'Life_Policies_Action__c');

        Test.stopTest();
    }
    
    public static testMethod void testCasaScreeningStatus(){        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetCasaDetailsByRefMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetCasaDetailsByRef_IH_v1.GET_CASA_DETAILS_BY_REF_SERVICE});
        
        Test.startTest();
        
        CasaScreeningController.getCasaStatus(testDataFactory.testOpportunity.id);
        CasaScreeningController.refreshCasaStatus(testDataFactory.testOpportunity.id);

        Test.stopTest();
    }
    
    public static testMethod void testCasaScreeningStatusJoint(){        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        testDataFactory.testOpportunity.AccountId = testDataFactory.testJointAccount.Id;
        update testDataFactory.testOpportunity;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetCasaDetailsByRefMock_ApiRest(StringConstants.POSITIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetCasaDetailsByRef_IH_v1.GET_CASA_DETAILS_BY_REF_SERVICE});
        
        Test.startTest();
        
        CasaScreeningController.refreshCasaStatus(testDataFactory.testOpportunity.id);

        Test.stopTest();
    }
    
    public static testMethod void testCasaScreeningStatusNegative(){        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new GetCasaDetailsByRefMock_ApiRest(StringConstants.NEGATIVE_STRING));
        //Insert Integration Settings
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {GetCasaDetailsByRef_IH_v1.GET_CASA_DETAILS_BY_REF_SERVICE});
    
        Test.startTest();
        
        CasaScreeningController.refreshCasaStatus(testDataFactory.testOpportunity.id);

        Test.stopTest();
    }
    
    
    public static testMethod void testCasaScreeningVersion6(){        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING, StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2});
        
        CASA_Version__c casaVersion = CASA_Version__c.getOrgDefaults();
        String version = 'Version 6';
		casaVersion.Value__c = version;
        upsert casaVersion;
        
        Test.startTest();
        
        CasaScreeningController.updateAccountAndDoCasaScreening(testDataFactory.testOpportunity.id, testDataFactory.testAccount);
        
        Test.stopTest();
    } 
    public static testMethod void testCasaScreeningGenericCasa(){        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING});
        
        Test.startTest();
        
        CasaScreeningController.checkCasaFieldsAndDoCasaScreening(testDataFactory.testOpportunity.id);
        
        Test.stopTest();
    }
    
    public static testMethod void testCasaScreeningJointAccount(){
		
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        testDataFactory.testOpportunity.AccountId = testDataFactory.testJointAccount.Id;
        update testDataFactory.testOpportunity;
        
        testDataFactory.testProspectAccount.ID_Type__pc = 'SA Identity Document';
        testDataFactory.testProspectAccount.ID_Number__pc = '9012125012084';
        testDataFactory.testProspectAccount.PersonBirthdate = Date.parse('1990/12/12');
        update testDataFactory.testProspectAccount;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedParty_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2, StringConstants.CASA_SCREEN_RELATED_PARTY});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        Test.startTest();
        
        CasaScreeningController.getAccountData(testDataFactory.testOpportunity.id);
        CasaScreeningController.getPartcicpantAccountData(testDataFactory.testOpportunity.id);
        CasaScreeningController.updateAccountAndDoCasaScreening(testDataFactory.testOpportunity.id, testDataFactory.testJointAccount);
        
        Test.stopTest();
    } 
    
    public static testMethod void testCasaScreeningJointAccountVersion6(){
		
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        testDataFactory.testOpportunity.AccountId = testDataFactory.testJointAccount.Id;
        update testDataFactory.testOpportunity;
        
        testDataFactory.testProspectAccount.ID_Type__pc = 'SA Identity Document';
        testDataFactory.testProspectAccount.ID_Number__pc = '9012125012084';
        testDataFactory.testProspectAccount.PersonBirthdate = Date.parse('1990/12/12');
        update testDataFactory.testProspectAccount;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedParty_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING, StringConstants.CASA_SCREEN_RELATED_PARTY_V6});
        IntegrationTestDataFactory.insertIntegrationTranslations();
        
        CASA_Version__c casaVersion = CASA_Version__c.getOrgDefaults();
        String version = 'Version 6';
		casaVersion.Value__c = version;
        upsert casaVersion;
        
        Test.startTest();
        
        CasaScreeningController.updateAccountAndDoCasaScreening(testDataFactory.testOpportunity.id, testDataFactory.testJointAccount);
        
        Test.stopTest();
    }
    
    public static testMethod void testCasaScreeningAutoCasa(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING, StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2});
        
        Test.startTest();
        
        CasaScreeningController.checkCasaFieldsAndDoCasaScreening(testDataFactory.testOpportunity.id);

        Test.stopTest();
    }
    
    public static testMethod void testCasaScreeningAutoCasaVersion6(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAPrimaryClientScreeningMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationTranslations();
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING, StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2});
        
        CASA_Version__c casaVersion = CASA_Version__c.getOrgDefaults();
        String version = 'Version 6';
		casaVersion.Value__c = version;
        upsert casaVersion;
        
        Test.startTest();
        
        CasaScreeningController.checkCasaFieldsAndDoCasaScreening(testDataFactory.testOpportunity.id);

        Test.stopTest();
    }
    
    public static testMethod void testCasaScreeningJointAccountNagative(){
        
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        testDataFactory.testOpportunity.AccountId = testDataFactory.testJointAccount.Id;
        update testDataFactory.testOpportunity;
        
        testDataFactory.testProspectAccount.FirstName = null;
        testDataFactory.testProspectAccount.Nationality__pc = null;
        testDataFactory.testProspectAccount.Country_of_Residence__pc = null;
        testDataFactory.testProspectAccount.Country_of_Birth__pc = null;
        update testDataFactory.testProspectAccount;
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CASAScreenRelatedParty_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.CASA_PRIMARY_CLIENT_SCREENING_V2, StringConstants.CASA_SCREEN_RELATED_PARTY});
        IntegrationTestDataFactory.insertIntegrationTranslations();
                
        Test.startTest();        
        
        CasaScreeningController.updateAccountAndDoCasaScreening(testDataFactory.testOpportunity.id, testDataFactory.testJointAccount);
        
        Test.stopTest();
    } 
}