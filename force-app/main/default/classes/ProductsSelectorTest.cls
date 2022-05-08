@isTest
private class ProductsSelectorTest {
    @isTest private static void testGetSObjectType() {

        Schema.SObjectType result = new ProductsSelector().getSObjectType();
        System.assert(result != null);
    }

    @isTest private static void testGetSObjectFieldList() {

        List<Schema.SObjectField> result = new ProductsSelector().getSObjectFieldList();
        System.assert(result != null);
    }

    @isTest private static void testSelectById() {

        Product2 testProduct = WillsTestDataFactory.createProduct('Test', 'Test');
        new ProductsSelector().selectById(testProduct.Id);
        new ProductsSelector().selectActiveProducts(true);
        List<Product2> result = new ProductsSelector().selectById(new Set<Id>{testProduct.Id});
        System.assert(result != null);
    }

    @isTest private static void testSelectByName() {

        Product2 testProduct = WillsTestDataFactory.createProduct('Test', 'Test');
        Product2 result = new ProductsSelector().selectByName(testProduct.Name, 1);

        System.assert(result != null);

        result = new ProductsSelector().selectByName(testProduct.Name);

        System.assert(result != null);
    }

    @isTest private static void testSelectByFinancialProductId() {

        Product2 testProduct = WillsTestDataFactory.createProduct('Test', 'Test');
        Financial_Product__c testFinancialProduct = WillsTestDataFactory.createFinancialProduct('Test', 'Investment');
        testProduct.Financial_Product__c = testFinancialProduct.Id;

        List<Product2> result = new ProductsSelector().selectByFinancialProductId(testFinancialProduct.Id, true);
        System.assert(result != null);
    }

    @isTest private static void testSelectByFamily() {

        Product2 testProduct = WillsTestDataFactory.createProduct('Test', 'Test');
        List<Product2> result = new ProductsSelector().selectByFamily(testProduct.Family);

        System.assert(result != null);
    }
}