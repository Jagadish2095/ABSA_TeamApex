/**
 * @description test class for the ChargeControlSelector
 * @createdBy Jason Quevauvilliers
 * @createdDate 2021-05-11
 * @updated Koketso Mpshane 2021-08-25
 */
@isTest
public class ChargeControlsSelectorTest {
	@TestSetup
	static void makeData() {
		ChargeControlTestDataFactory.createChargeControlRecord();
	}

	@isTest
	private static void testSelectByIdSet() {
		Charge_Control__c chargeControl = [SELECT Id FROM Charge_Control__c LIMIT 1];
		Test.startTest();
		List<Charge_Control__c> chargeControlList = new ChargeControlsSelector().selectById(new Set<Id>{ chargeControl.Id });
		Test.stopTest();
		System.assert(chargeControlList.size() > 0, 'Assert Failed');
	}

	@isTest
	private static void testSelectByAccountIdSet() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		Test.startTest();
		List<Charge_Control__c> chargeControlList = new ChargeControlsSelector().selectByAccountIdSet(new Set<Id>{ acc.Id });
		Test.stopTest();
		System.assert(chargeControlList.size() > 0, 'Assert Failed');
	}

	@isTest
	private static void testSelectByCompositeKeySet() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		String currentMonth = String.valueOf(Date.Today().Month());
		Test.startTest();
		List<Charge_Control__c> chargeControlList = new ChargeControlsSelector()
			.selectByCompositeKeySet(new Set<String>{ currentMonth + String.valueOf(acc.Id) });
		Test.stopTest();
		System.assert(chargeControlList.size() > 0, 'Assert Failed');
	}

    @isTest
	private static void testFilterByChargeProcessCode() {
		Test.startTest();
		List<Charge_Control__c> chargeControlList = new ChargeControlsSelector().filterByChargeProcessCode('0000');
		Test.stopTest();
		System.assert(chargeControlList.size() > 0, 'Assert Failed');
	}

}