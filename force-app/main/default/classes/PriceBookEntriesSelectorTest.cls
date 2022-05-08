/**
* This is the PriceBookEntriesSelector Apex controller test class
*
* @author   Nelson Chisoko (Dariel)
* @since    2019/03/26
*/
@IsTest
private class PriceBookEntriesSelectorTest {

    static testMethod void testGetSObjectType() {

        Schema.SObjectType result = new PriceBookEntriesSelector().getSObjectType();

        System.assert(result != null);
    }

    static testMethod void testGetSObjectFieldList() {

        List<Schema.SObjectField> result = new PriceBookEntriesSelector().getSObjectFieldList();

        System.assert(result != null);
    }

    static testMethod void testSelectById() {
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('AS PAID IN - AN AMOUNT (NOT LISTED)', 'WILL');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);

        PricebookEntry result = new PriceBookEntriesSelector().selectById(pricebookEntry.Id);

        System.assert(result != null);

        List<PricebookEntry> resultList = new PriceBookEntriesSelector().selectById(new Set<Id>{pricebookEntry.Id});

        System.assert(resultList != null);
    }

    static testMethod void testSelectByName() {
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('AS PAID IN - AN AMOUNT (NOT LISTED)', 'WILL');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);

        PricebookEntry result = new PriceBookEntriesSelector().selectByName(product.Name, 1);

        System.assert(result != null);
    }
}