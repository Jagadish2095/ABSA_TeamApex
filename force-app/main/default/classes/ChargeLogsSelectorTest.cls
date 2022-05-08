/**
 * @description test class for the ChargeLogsSelector
 * @createdBy Jason Quevauvilliers
 * @createdDate 2021-05-11
 */
@isTest
public class ChargeLogsSelectorTest {
	/**
	* @description Creates the data
	* @author Lehlohonolo.Matsoso@absa.africa | 2021-11-29 
	**/
	@TestSetup
	static void makeData() {
		Transaction_Group__c transactionGroup = PricingTestDataFactory.createTransactionGroup('Funds Transfer');
		Transaction_Type__c transactionType = PricingTestDataFactory.createTransactionType('Funds Transfer - IVR', transactionGroup.Id);
		transactionType.Transaction_Code__c = '15';
		update transactionType;
		Price_Scheme__c standardPriceScheme = PricingTestDataFactory.createPriceScheme('IVR - Individual', 'Standard', null, null);
		Price_Scheme_Entry__c standardFixedPriceSchemeEntry = PricingTestDataFactory.createFixedPriceSchemeEntry(standardPriceScheme.Id, transactionType.Id);

		Account account = new Account(Name = 'Test Account');
		account.RecordTypeId = schema.SObjectType.account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
		account.CIF__c = 'MULLEBM001';
		account.Telebanking_Charge_Account_Number__c = '0000001234567893';
		insert account;

		Charge_Log__c cl = new Charge_Log__c();
		cl.Account_CIF_Code__c = 'MULLEBM001';
		cl.Transaction_Code__c = '15';
		cl.Transaction_Date__c = Date.Today();
		cl.Source__c = 'IVR';
		insert cl;
	}

	/**
	* @description test SelectByIdSet
	* @author Lehlohonolo.Matsoso@absa.africa | 2021-11-29
	**/
	@isTest
	private static void testSelectByIdSet() {
		Charge_Log__c chargeLog = [SELECT Id FROM Charge_Log__c LIMIT 1];
		Test.startTest();
		List<Charge_Log__c> chargeLogList = new ChargeLogsSelector().selectById(new Set<Id>{ chargeLog.Id });
		Test.stopTest();
		System.assert(chargeLogList.size() > 0, 'Assert Failed');
	}

	/**
	* @description test SelectById
	* @author Lehlohonolo.Matsoso@absa.africa | 2021-11-29
	**/
	@isTest
	private static void testSelectById() {
		Charge_Log__c chargeLog = [SELECT Id FROM Charge_Log__c LIMIT 1];
		Test.startTest();
		Charge_Log__c chargeLogReturned = new ChargeLogsSelector().selectById(chargeLog.Id);
		Test.stopTest();
		System.assert(chargeLogReturned != null, 'Assert Failed');
	}

	/**
	* @description test SelectChagresByAccountId
	* @author Lehlohonolo.Matsoso@absa.africa | 2021-11-29
	**/
	@isTest
	private static void testSelectChagresByAccountId() {
		List<Charge_Log__c> result;
		Account acc = [SELECT Id FROM Account][0];
		Test.startTest();
		result = new ChargeLogsSelector().selectChargesByAccountId(acc.Id);
		Test.stopTest();
		System.assert(result != null, 'Assert Failed');
	}

}