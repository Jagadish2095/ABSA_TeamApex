@isTest 
private class PriceSchemesSelectorTest {
	@TestSetup
	static void makeData() {
		// Instantiating the Pricing Test Data Factory creates pricing related records
		PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();
	}
	@isTest
	private static void testselectById() {
		Price_Scheme__c priceScheme = [SELECT Id FROM Price_Scheme__c LIMIT 1];
		Set<Id> IdSet = new Set<Id>();
		IdSet.add(priceScheme.Id);
		List<Price_Scheme__c> priceSchemes = new PriceSchemesSelector().selectById(IdSet);
		System.assert(priceSchemes.size() > 0, 'Assert Failed');
	}
	@isTest
	private static void testSelectByAccountTypeProductFamily() {
		Account account = [SELECT Id FROM Account LIMIT 1];
		List<Price_Scheme__c> priceSchemes = new PriceSchemesSelector()
			.selectByAccountTypeProductFamily(account.Id, 'Merchant', StringConstants.PRICE_SCHEME_TYPE_NEGOTIATED, 1);
		List<Price_Scheme__c> priceSchemesEnddate = new PriceSchemesSelector().selectByEndDate();
		List<Price_Scheme__c> priceSchemesProdName = new PriceSchemesSelector().selectByProductFamilyProductName('productFamily', 'ProductName', 'ProductCode');
		List<Price_Scheme__c> priceSchemesProdFam = new PriceSchemesSelector().selectByTypeProductFamily('productFamily', 'type', 1);
		System.assert(priceSchemes.size() > 0, 'Assert Failed');
	}

	@isTest
	private static void testSelectByNameSet() {
		Test.startTest();
		List<Price_Scheme__c> priceSchemes = new PriceSchemesSelector().selectByNameSet(new Set<String>{ 'standardPriceScheme' });
		Test.stopTest();
		System.assert(priceSchemes.size() > 0, 'Assert Failed');
	}
}