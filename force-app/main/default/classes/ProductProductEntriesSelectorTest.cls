/**
* @description       :Test Class for  ProductProductEntriesSelector
* @update Sipho Mbulawa
* @dateUpdated 2021-01-14
* Added the testSelectByRelatedProductId method
*/
@isTest
private class ProductProductEntriesSelectorTest {

    @TestSetup
    static void makeData(){
        // Instantiating the Pricing Test Data Factory creates pricing related records
        PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();
    }

    @isTest
    private static void testSelectById() {
        Product_Product_Entry__c productProductEntryEntry = [SELECT Id FROM Product_Product_Entry__c LIMIT 1];
        Set<Id> IdSet = new Set<Id>();
        IdSet.add(productProductEntryEntry.Id);
        List<Product_Product_Entry__c> productProductEntryEntryLst = new ProductProductEntriesSelector().selectById(IdSet);
        System.assertEquals(productProductEntryEntryLst.size(), 1);
    }

    @isTest
    private static void testSelectByParentProductId() {
        Product_Product_Entry__c productProductEntryEntry = [SELECT Id, Parent_Product__c FROM Product_Product_Entry__c LIMIT 1];
        List<Product_Product_Entry__c> productProductEntryEntryLst = new ProductProductEntriesSelector().selectByParentProductId(productProductEntryEntry.Parent_Product__c);
		List<Product_Product_Entry__c> productProductAll = new ProductProductEntriesSelector().selectAll();
        //ProductProductEntriesSelector.jimmyclass();
        System.assert(productProductEntryEntryLst.size() > 0);
    }
    @isTest
    private static void testSelectByRelatedProductId(){
        Product_Product_Entry__c relatedProduct = [SELECT Id, Related_Product__c, Related_Product__r.Name,Related_Product__r.productCode FROM Product_Product_Entry__c LIMIT 1];
        Product_Product_Entry__c productProductRelatedEntry = new ProductProductEntriesSelector().selectByRelatedProductId(relatedProduct.Related_Product__c);
        Product2 product1 = new Product2();
        product1.Name = 'Business Evolve';
        product1.Family =  'Cheque';
        product1.ProductCode = '11021';
        product1.IsActive = true;
        insert product1;

        Product2 product2 = new Product2();
        product2.Name = 'Business Evolve Package';
        product2.Product_Classification__c = 'Package';
        insert product2;

        Product_Product_Entry__c firstPack = new Product_Product_Entry__c();
        firstPack.Parent_Product__c =product2.Id;
        firstPack.Related_Product__c = product1.Id;
        insert firstPack;
        List<Product_Product_Entry__c> test1 = new ProductProductEntriesSelector().selectByParentNameProductCode('Business Evolve Package', '11021'); 
        List<Product_Product_Entry__c> test2 = new ProductProductEntriesSelector().selectByParentProductCode('');
        System.assert(test2.size() > 0);
    }
}