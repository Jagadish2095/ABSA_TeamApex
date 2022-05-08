@isTest 
private class PriceSchemeProductEntriesSelectorTest {

    @TestSetup
    static void makeData(){
        
        // Instantiating the Pricing Test Data Factory creates pricing related records
        PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();
    }

    @isTest
    private static void testSelectById() {
        Price_Scheme_Product_Entry__c priceSchemeProdutEntryTest = [SELECT Id FROM Price_Scheme_Product_Entry__c LIMIT 1];

        Set<Id> IdSet = new Set<Id>();
        IdSet.add(priceSchemeProdutEntryTest.Id);
        List<Price_Scheme_Product_Entry__c> priceSchemeProdutEntryEntryLst = new PriceSchemeProductEntriesSelector().selectById(IdSet);
        
        System.assertEquals(priceSchemeProdutEntryEntryLst.size(), 1);
    }

    @isTest
    private static void testSelectByActiveTypeAccountProduct() {
        Account account = [SELECT Id FROM Account LIMIT 1];
        Product2 product = [SELECT Id FROM Product2 LIMIT 1];
        
        List<Price_Scheme_Product_Entry__c> priceSchemeProdutEntryEntryLst = new PriceSchemeProductEntriesSelector().selectByActiveTypeAccountProduct(product.Id, account.Id, StringConstants.PRICE_SCHEME_TYPE_NEGOTIATED, 1);
        
        System.assert(priceSchemeProdutEntryEntryLst.size() > 0);
    }

    @isTest
    private static void testSelectByActiveTypeProduct() {
        Product2 product = [SELECT Id FROM Product2 LIMIT 1];
        
        List<Price_Scheme_Product_Entry__c> priceSchemeProdutEntryEntryLst = new PriceSchemeProductEntriesSelector().selectByActiveTypeProduct(product.Id, StringConstants.PRICE_SCHEME_TYPE_STANDARD, 1);
        
        System.assert(priceSchemeProdutEntryEntryLst.size() > 0);
    }
}