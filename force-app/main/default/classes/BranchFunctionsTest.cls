/*
Controller Test Class For BranchFunctions class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2021-01-21
*
*/
@isTest
public class BranchFunctionsTest {
	@testSetup
	static void dataCreation() {
		String translationId = TestMetaDataFactory.insertTestObject('Integration_Translation__c', 'DefaultTranslation');
		String bankInfoId = TestMetaDataFactory.insertTestObject('BankInfo__c', 'DefaultBankInfo');
		Map<String, String> accMap = new Map<String, String>();
		accMap.put('RecordTypeId', TestMetaDataFactory.getRecordTypeId('Individual_Client'));
		String accountId = TestMetaDataFactory.insertTestObject('Account', 'BranchNTPAccount', accMap);
		Map<String, String> opportunityMap = new Map<String, String>();
		opportunityMap.put('AccountId', accountId);
		String opportunityId = TestMetaDataFactory.insertTestObject('Opportunity', 'DefaultOpportunity', opportunityMap);
	}

	@isTest
	public static void getFieldPickListValues() {
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			SObject objObject = Address__c.SObjectType.newSObject();
			String objField = 'Shipping_Country__c';
			Test.startTest();
			List<String> listValues = BranchAddressController.getFieldPickListValues(objObject, objField);
			System.assert(!listValues.isEmpty(), 'PickListValues List should not be empty!');
			Test.stopTest();
		}
	}

	@isTest
	public static void getTranslationValues() {
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			String systemName = 'CIF';
			String valueType = 'Country';
			String direction = 'Outbound';
			SObject objObject = Address__c.SObjectType.newSObject();
			String objField = 'Shipping_Country__c';
			Test.startTest();
			Map<String, String> translationValues = BranchCustomerController.getTranslationValues(systemName, valueType, direction, objObject, objField);
			Boolean contains = translationValues.containsKey('South Africa');
			System.assertEquals(true, contains, 'TranslationValues should include South Africa');
			System.assert(!translationValues.isEmpty(), 'TranslationValues List should not be empty');
			Test.stopTest();
		}
	}

	@isTest
	public static void getBankInfo() {
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			List<String> bankNames = BranchFunctions.getBankInfo();
			System.assert(!bankNames.isEmpty(), 'BankNames List should not be empty!');
			Test.stopTest();
		}
	}

	@isTest
	public static void getAccountIdFromAccount() {
		string accountId = TestMetaDataFactory.getRecordId('Account', 'BranchNTPAccount');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			String oppId = BranchFunctions.getAccountId(accountId);
			System.assert(oppId != '', 'OpportunityId should not be empty!');
			Test.stopTest();
		}
	}

	@isTest
	public static void getAccountIdFromOpportunity() {
		string opportunityId = TestMetaDataFactory.getRecordId('Opportunity', 'DefaultOpportunity');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			String oppId = BranchFunctions.getAccountId(opportunityId);
			System.assert(OppId != '', 'OpportunityId should not be empty!');
			Test.stopTest();
		}
	}

	@isTest
	public static void getOpportunityIdFromOpportunity() {
		string opportunityId = TestMetaDataFactory.getRecordId('Opportunity', 'DefaultOpportunity');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			String oppId = BranchFunctions.getOpportunityId(opportunityId);
			System.assert(oppId != '', 'OpportunityId should not be empty!');
			Test.stopTest();
		}
	}

	@isTest
	public static void getApplicationIdFromOpportunity() {
		string opportunityId = TestMetaDataFactory.getRecordId('Opportunity', 'DefaultOpportunity');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			String appId = BranchFunctions.getApplicationId(opportunityId);
			System.assert(appId != '', 'OpportunityId should not be empty!');
			Test.stopTest();
		}
	}

	@isTest
	public static void isBusinessProspect() {
		string accountId = TestMetaDataFactory.getRecordId('Account', 'BranchNTPAccount');
		System.runAs(TestMetaDataFactory.getUser('Standard User (Branch)')) {
			Test.startTest();
			Boolean isBusinessProspect = BranchFunctions.isBusinessProspect(accountId);
			System.assert(!isBusinessProspect, 'OpportunityId should not be empty!');
			Test.stopTest();
		}
	}

}