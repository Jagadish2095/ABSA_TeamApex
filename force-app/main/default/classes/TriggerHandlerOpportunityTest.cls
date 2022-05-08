/**
 * @description       :
 * @author            : Tawanda M.
 * @last modified on  : 2021-11-30
 * @last modified by  : vineel.rudroju@absa.africa
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   2021-07-24   Tawanda M.   Initial Version
**/        
@isTest
public class TriggerHandlerOpportunityTest {
    public static Map<String, Schema.RecordTypeInfo> OpportunityRecordTypeMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

    @isTest
	public static void testOpportunityTrigger() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator (Custom)'];

		//User
		String orgId = userInfo.getOrganizationId();
		String dateString = Datetime.now().format('yyyMMddHHmmss');
		Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
		String uniqueName = dateString + randomInt + '@test' + orgId + '.org';
		User testUser = new User();
		testUser.FirstName = 'WillTestUser';
		testUser.LastName = 'WillTtestData';
		testUser.Email = uniqueName;
		testUser.Username = uniqueName;
		testUser.BRID__c = '45789';
		testUser.EmailEncodingKey = 'ISO-8859-1';
		testUser.Alias = 'WillUser';
		testUser.TimeZoneSidKey = 'Africa/Johannesburg';
		testUser.LocaleSidKey = 'en_US';
		testUser.LanguageLocaleKey = 'en_US';
		testUser.ProfileId = p.id;
		testUser.Advisor_Code__c = 'A12345';
		testUser.mobilePhone = '0658992600';
		testUser.Business_Area__c = 'WIMI';
		insert testUser;

		Test.startTest();

		System.runAs(testUser) {
			Opportunity opp = new Opportunity();
			opp = testDataFactory.testOpportunity;
			opp.Id = null;
			insert opp;

            System.assert(opp.Email_Status__c != 'Valid');

			opp.StageName = 'Sale Successful';
			opp.WBIF_Policy_Number__c = '123456789';
			opp.ownerid = testUser.id;
			update opp;
		}

		Test.stopTest();
	}

    @isTest
	public static void testOpportunityEPPValidations() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		Test.startTest();

		Opportunity opp = new Opportunity();
		opp = testDataFactory.testOpportunity;
		opp.RecordTypeId = OpportunityRecordTypeMap.get('Virtual_Advisor').getRecordTypeId();
		opp.Id = null;
		insert opp;
        System.assert(opp.Originating_Agent__c == null);

		//OpportunityTriggerFunctions.qualityAssuranceCalculation(opp, null);
		List<sObject> oppTriggerNew = new List<sObject>();
		oppTriggerNew.add(opp);
		OpportunityTriggerFunctions.eppInsertValidations(oppTriggerNew);

		Test.stopTest();
	}

	@isTest
	static void testDirectDeliveryOpp() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Test.startTest();

		Account acc = new Account();
		acc.Name = 'Test account';
		acc.ExecutionLayerRequestID__c = '12345';
		insert acc;

		Opportunity opp = new Opportunity();
		opp = testDataFactory.testOpportunity;
		opp.AccountId = acc.Id;
		opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Direct_Delivery_Sales_Opportunity').getRecordTypeId();
		opp.Id = null;
		opp.Pricing_Decision__c = 'Approve';
		opp.VC_Application_Number__c = 'RBB Manager';
		insert opp;
        System.assert(opp.Entity_Type__c == null);
		opp.Available_Cover__c = null;
		opp.StageName = 'Not Interested';
		opp.QA_Complex_Approval_Status__c = 'Not Submitted';
		opp.Pricing_Decision__c = 'Approve';
		update opp;

		opp.QA_Complex_Approval_Status__c = 'Submitted';
		opp.StageName = 'Closed';
		try {
			update opp;
		} catch (Exception ex) {
			System.assert(ex != null);
		}

		Test.stopTest();
	}

    @isTest
    static void testComplecCredit(){

        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Test.startTest();

        Account acc = new Account();
        acc.Name = 'Test account';
        acc.ExecutionLayerRequestID__c = '12345';
        insert acc;

        Opportunity opp = new Opportunity();
        opp = testDataFactory.testOpportunity;
        opp.AccountId = acc.Id;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Complex Credit Onboarding').getRecordTypeId();
        opp.Id = null;
        insert opp;

        opp.CheckMandatoryDocuments__c = false;
        opp.StageName = 'Closed';
        update  opp;

        opp.Pricing_Decision__c = 'Approve';
        update  opp;

        opp.Allocated__c = true;
        opp.More_Info_Decision__c = true;
        update  opp;
        System.assert(opp != null);

        Test.stopTest();

    }
}