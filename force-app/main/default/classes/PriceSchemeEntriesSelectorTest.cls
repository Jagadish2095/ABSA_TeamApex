/**
 * @description       : 
 * @author            : Manish.battu@absa.africa
 * @last modified on  : 2021-06-11
 * @last modified by  : Manish.battu@absa.africa
 * Modifications Log 
 * Ver   Date         Author                     Modification
 * 1.0   2021-06-11   Manish.battu@absa.africa   Initial Version
**/
@isTest
private class PriceSchemeEntriesSelectorTest {
	@TestSetup
	static void makeData() {
		// Instantiating the Pricing Test Data Factory creates pricing related records
		PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();
	}

	@isTest
	private static void testSelectById() {
		Price_Scheme_Entry__c priceSchemeEntry = [SELECT Id FROM Price_Scheme_Entry__c LIMIT 1];

		Set<Id> IdSet = new Set<Id>();
		IdSet.add(priceSchemeEntry.Id);
		Test.startTest();
		List<Price_Scheme_Entry__c> priceSchemeEntries = new PriceSchemeEntriesSelector().selectById(IdSet);

		System.assertEquals(priceSchemeEntries.size(), 1, 'Assert Failed');

		//PJAIN: 20200422
		priceSchemeEntries = new PriceSchemeEntriesSelector().selectById(priceSchemeEntry.Id);
		Test.stopTest();
		System.assertEquals(priceSchemeEntries.size(), 1, 'Assert Failed');
	}

	/**
	 * @description PJAIN: 20200422
	 */
	@isTest
	private static void testSelectByPriceSchemeId() {
		Price_Scheme__c priceScheme = [SELECT Id FROM Price_Scheme__c LIMIT 1];
		Test.startTest();
		List<Price_Scheme_Entry__c> priceSchemeEntries = new PriceSchemeEntriesSelector().selectByPriceSchemeId(priceScheme.Id);
		Test.stopTest();
		System.assert(priceSchemeEntries.size() > 0, 'Assert Failed');
	}

	@isTest
	private static void testSelectByPriceSchemeIdAndTransactionTypeId() {
		Price_Scheme__c priceScheme = [SELECT Id FROM Price_Scheme__c LIMIT 1];
		Set<Id> priceSchemeIdSet = new Set<Id>{ priceScheme.Id };
		Transaction_Type__c transactionType = [SELECT Id FROM Transaction_Type__c LIMIT 1];
		Set<Id> transactionTypeIdSet = new Set<Id>{ transactionType.Id };

		Test.startTest();
		List<Price_Scheme_Entry__c> priceSchemeEntryList = new PriceSchemeEntriesSelector()
			.selectByPriceSchemeIdAndTransactionTypeId(priceSchemeIdSet, transactionTypeIdSet);
		Test.stopTest();

		System.assert(priceSchemeEntryList.size() > 0, 'Assert Failed');
	}
    @isTest
	private static void testSelectByPriceSchemeByAccountIdId() {
		Price_Scheme__c priceScheme = [SELECT Id FROM Price_Scheme__c LIMIT 1];
		Account acc = new Account();
        acc.Name ='Test Account';
        insert acc;
		Test.startTest();
		List<Price_Scheme_Entry__c> priceSchemeEntryList = new PriceSchemeEntriesSelector()
			.selectByPriceSchemeByAccountId(acc.Id);
		Test.stopTest();

		System.assert(priceSchemeEntryList.size() == 0, 'Assert Failed');
	}
}