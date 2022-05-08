@isTest 
private class TransactionTypesSelectorTest {
	@TestSetup
	static void makeData() {
		//Insert test Transaction Group
		Transaction_Group__c transactionGroupTest = new Transaction_Group__c();
		insert transactionGroupTest;

		//Insert test Pricing Formula
		Pricing_Formula__c pricingFormulaTest = new Pricing_Formula__c();
		pricingFormulaTest.Pricing_Template__c = 'Fixed Fee per Item';
		insert pricingFormulaTest;

		//Insert test Transaction Type
		Transaction_Type__c transactionTypeTest = new Transaction_Type__c();
		transactionTypeTest.Transaction_Group__c = transactionGroupTest.id;
		insert transactionTypeTest;
	}

	@isTest
	private static void testSelectById() {
		Transaction_Type__c transType = [SELECT Id FROM Transaction_Type__c LIMIT 1];
		Set<Id> IdSet = new Set<Id>();
		IdSet.add(transType.Id);
		Test.startTest();
		List<Transaction_Type__c> transactionTypeList = new TransactionTypesSelector().selectById(IdSet);
		Test.stopTest();
		System.assertEquals(transactionTypeList.size(), 1, 'Assert Failed');
	}

	@isTest
	private static void testSelectByTransactionCode() {
		Transaction_Type__c transType = [SELECT Transaction_Code__c FROM Transaction_Type__c LIMIT 1];

		Set<String> transactionCodeSet = new Set<String>();
		transactionCodeSet.add(transType.Transaction_Code__c);
		Test.startTest();
		List<Transaction_Type__c> transactionTypeEntryLst = new TransactionTypesSelector().selectByTransactionCode(transactionCodeSet);
		Test.stopTest();
		System.assertEquals(transactionTypeEntryLst.size(), 1, 'Assert Failed');
	}
}