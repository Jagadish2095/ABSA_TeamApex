/**
 * @description DomicileChangeTest
 * @author  Mbuyiseni Mbhokane
 * @version v1.0
 * @since   2020-01-31
 * @updated 2021-05-27 : Anka Ganta
 */
@isTest
public class DomicileChangeTest {
	/**
	 * @description dataCreation
	 */
	@testSetup
	static void dataCreation() {
		Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque');
		insert prod;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = Test.getStandardPricebookId();
		update pb;

		Account acc = new Account();
		acc.name = 'testcreateCif';
		acc.Type = 'Business Prospect Clinet';
		acc.CIF__c = 'SACOMPE259';
		insert acc;

		Opportunity testOpp = new Opportunity();
		testOpp.Name = 'Test Opp Onboarding';
		testOpp.CloseDate = Date.today();
		testOpp.StageName = 'New';
		testOpp.Pricebook2Id = Test.getStandardPricebookId();
		testOpp.AccountId = acc.id;
		insert testOpp;
	}
	/**
	 * @description chequeDomicileChangePositiveTest
	 */
	@isTest
	static void chequeDomicileChangePositiveTest() {
		//Get the opportunity record
		Opportunity newOrppRecord = [SELECT Id, Name FROM Opportunity LIMIT 1];

		//Get the product record
		Product2 prodRecord = [SELECT Id, Name FROM Product2 LIMIT 1];

		//Create the pricebook entry
		PricebookEntry customPrice = new PricebookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = prodRecord.Id,
			UnitPrice = 12000,
			IsActive = true
		);
		insert customPrice;

		//Create the OpportunityLineItems
		OpportunityLineItem oli = new OpportunityLineItem(
			OpportunityId = newOrppRecord.Id,
			Quantity = 5,
			PricebookEntryId = customPrice.Id,
			TotalPrice = 5 * customPrice.UnitPrice,
			Policy_Number__c = '4048358221'
		);
		insert oli;

		Test.setMock(HttpCalloutMock.class, new CqUpdAcctDomicileChangev2_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.CQ_UPDATEACC_DOMICILE_CHANGE_STRING }
		);

		test.startTest();
		Map<Opportunity, List<Sys_Log_Integration__c>> domicleMapList = DomicileChange.domicileChangeCall(newOrppRecord);
		System.assert(domicleMapList.get(newOrppRecord) == null);
        test.stopTest();
	}
	/**
	 * @description savingsDomicileChangePositiveTest
	 */
	@isTest
	static void savingsDomicileChangePositiveTest() {
		//get Product Onboarding recordType Id
		Id productOnbaordingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Product_Onboarding').getRecordTypeId();

		//Create savings product
		Product2 savingsProd = new Product2(Name = 'Savings Product', Family = 'Savings');
		insert savingsProd;

		//Create the pricebook entry for savings
		PricebookEntry savingsCustomPrice = new PricebookEntry(
			Pricebook2Id = Test.getStandardPricebookId(),
			Product2Id = savingsProd.Id,
			UnitPrice = 12000,
			IsActive = true
		);
		insert savingsCustomPrice;

		//Get the account record
		Account acc = [SELECT Id, Name FROM Account LIMIT 1];

		//Create opportunity for Savings
		Opportunity testSavingsOpp = new Opportunity();
		testSavingsOpp.Name = 'Saving Test Opp Onboarding';
		testSavingsOpp.CloseDate = Date.today();
		testSavingsOpp.StageName = 'New';
		testSavingsOpp.Pricebook2Id = Test.getStandardPricebookId();
		testSavingsOpp.AccountId = acc.id;
		testSavingsOpp.RecordTypeId = productOnbaordingRecordTypeId;

		insert testSavingsOpp;

		//Create the OpportunityLineItems for savings
		OpportunityLineItem savingsOppLinItem = new OpportunityLineItem(
			OpportunityId = testSavingsOpp.Id,
			Quantity = 5,
			PricebookEntryId = savingsCustomPrice.Id,
			TotalPrice = 5 * savingsCustomPrice.UnitPrice,
			Policy_Number__c = '9051324101'
		);
		insert savingsOppLinItem;

		Test.setMock(
			HttpCalloutMock.class,
			new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, SVChangeAccountDomcileBranch_IH_v1_Test.POSITIVE_RESPONSE_BODY)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ SVChangeAccountDomcileBranch_IH_v1.INTEGRATION_SERVICE_NAME }
		);

		test.startTest();
        Map<Opportunity, List<Sys_Log_Integration__c>> domicleMapList = DomicileChange.domicileChangeCall(testSavingsOpp);
		System.assert(domicleMapList.get(testSavingsOpp) == null);
		test.stopTest();
	}
}