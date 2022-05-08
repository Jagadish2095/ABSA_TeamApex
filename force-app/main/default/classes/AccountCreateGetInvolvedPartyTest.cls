@isTest
public class AccountCreateGetInvolvedPartyTest {
    
    public static testMethod void testinvolvedPartyCreation(){
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();

        Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        Test.startTest();
        
        AccountCreateGetInvolvedParty.createAccount('CIF','AKHILAM001');
        
        Test.stopTest();
    }
    
    public static testMethod void testinvolvedPartyCreationUpdateId(){
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
		testDataFactory.testAccount.ID_Number__pc = '8405200852088';
        update testDataFactory.testAccount;
            
        Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        Test.startTest();
        
        AccountCreateGetInvolvedParty.createAccount('ID Number','8701057648086');
        
        Test.stopTest();
    }
    
    public static testMethod void testinvolvedPartyCreationUpdateCIF(){
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
		testDataFactory.testAccount.CIF__c = 'AKHILAM001';
        update testDataFactory.testAccount;
            
        Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesMock_ApiRest(StringConstants.POSITIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        Test.startTest();
        
        AccountCreateGetInvolvedParty.createAccount('CIF','AKHILAM001');
        
        Test.stopTest();
    }
    
    public static testMethod void testinvolvedPartyCreationNegative(){
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();

        Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesMock_ApiRest(StringConstants.NEGATIVE_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        Test.startTest();
        
        AccountCreateGetInvolvedParty.createAccount('ID Number','8701057648086');
        
        Test.stopTest();
    }
    
    public static testMethod void testinvolvedPartyCreationNegativeUnauthorized(){
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();

        Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesMock_ApiRest(StringConstants.INTEGRATION_STATUS_FAILED));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        Test.startTest();
        
        AccountCreateGetInvolvedParty.createAccount('ID Number','8701057648086');
        
        Test.stopTest();
    }
    
    public static testMethod void testinvolvedPartyCreationNegativeNotFound(){
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();

        Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesMock_ApiRest(StringConstants.ERROR_STRING));
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        Test.startTest();
        
        AccountCreateGetInvolvedParty.createAccount('ID Number','8701057648086');
        
        Test.stopTest();
    }
    
    public static testMethod void testinvolvedPartyCreationJoint(){
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();

        Test.setMock(HttpCalloutMock.class, new RegSer_InvlovedPartiesJointMock_ApiRest(StringConstants.POSITIVE_STRING));

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT, StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        Test.startTest();
        
        AccountCreateGetInvolvedParty.createAccount('CIF','NAIARA+001');
        
        Test.stopTest();
    }
    
    public static testMethod void testinvolvedPartyCreationJointParticipantInsert(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT, StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});

        // Set mock callout class 		
        Test.setMock(HttpCalloutMock.class, new AccountCreateGetInvolvedPartyMock(StringConstants.POSITIVE_STRING));
       
        Test.startTest();
        
        testDataFactory.testJointAccount.Id = null;
        testDataFactory.testJointAccount.Name = 'TESTER MR J & TESTER MRS JA';
        testDataFactory.testJointAccount.CIF__c = 'NAIARA+002';
        AccountCreateGetInvolvedParty.createParticipants('AKHILAM002', testDataFactory.testJointAccount, 'Insert');

        Test.stopTest();
    }
    
    public static testMethod void testinvolvedPartyCreationJointParticipantUpdate(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new list<String> {StringConstants.GET_JOINT_PARTICIPANT, StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES});
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new AccountCreateGetInvolvedPartyMock(StringConstants.POSITIVE_STRING));
       
        Test.startTest();
        
        AccountCreateGetInvolvedParty.createParticipants('AKHILAM001', testDataFactory.testJointAccount, 'Update');

        Test.stopTest();
    }

    
}