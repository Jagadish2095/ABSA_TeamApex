/**
* @description Apex Enterprise Design Patters
* Test Class for the Selector layer for OpportunityLineItem object
* @author  Nelson Chisoko (Dariel)
* @since   27/02/2019
*/


@IsTest
private class OpportunityLineItemsSelectorTest {
    @isTest
    static void testSelectByOpportunityId() {
        test.startTest();
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
        System.assert(new OpportunityLineItemsSelector().selectByOpportunityId(testOpportunity.Id) != null);
        test.stopTest();
    }
    @isTest
    static void testSelectByOppId() {
        test.startTest();
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
        System.assert(new OpportunityLineItemsSelector().selectByOppId(testOpportunity.Id, 1) != null);
        test.stopTest();
    }
    /**
    * @description PJAIN: 20200414
    */
    @isTest
    static void testSelectParentLineItemsByOpportunityId() {
        test.startTest();
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
        System.assert(new OpportunityLineItemsSelector().selectParentLineItemsByOpportunityId(testOpportunity.Id, 1) != null);
        test.stopTest();
    }
    /**
    * @description PJAIN: 20200420
    */
    @isTest
    static void testSelectById() {
        test.startTest();
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
        List<Id> oppListId = new List<Id>();
        oppListId.add(testOpportunityLineItem.Id);
        List<OpportunityLineItem> selectByListOfIdstest = new OpportunityLineItemsSelector().selectByListOfIds(oppListId);
        List<OpportunityLineItem> selectByIdAndTypeTest = new OpportunityLineItemsSelector().selectByIdAndType(testOpportunityLineItem.Id, '');
        List<OpportunityLineItem> selectByParentOppIdAndTypeTest = new OpportunityLineItemsSelector().selectByParentOppIdAndType(testOpportunityLineItem.Id, '');
        List<OpportunityLineItem> selectByOppIdAndTypeTest = new OpportunityLineItemsSelector().selectByOppIdAndType(testOpportunity.Id, '');
        System.assert(new OpportunityLineItemsSelector().selectById(testOpportunityLineItem.Id) != null);
        test.stopTest();
    }
    /**
    * @description PJAIN: 20200420
    */
    @isTest
    static void testSelectRelatedLineItemsByParentId() {
        test.startTest();
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);

        System.assert(new OpportunityLineItemsSelector().selectRelatedLineItemsByParentId(testOpportunityLineItem.Id) != null);
        test.stopTest();
    }
    //Himani Joshi:03-09-2020
    @isTest
    static void testselectParentLinesByOppRecordTypeAndProduct() {
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Product2 product = WillsTestDataFactory.createProduct('E-Commerce', 'E-Commerce');
        test.startTest();
        System.assert(new OpportunityLineItemsSelector().selectParentLinesByOppRecordTypeAndProduct(testOpportunity.RecordType.Name, product.Name) != null);
        test.stopTest();
    }

    @isTest
    static void testSelectbyApplicationProductCAF() {
        test.startTest();
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        Pricebook2 standardPriceBook = WillsTestDataFactory.getStandardPriceBook();
        Product2 product = WillsTestDataFactory.createProduct('Test', 'Test');
        PricebookEntry pricebookEntry = WillsTestDataFactory.createPriceBookEntry(standardPriceBook.Id, product.Id);
        OpportunityLineItem testOpportunityLineItem = WillsTestDataFactory.createOpportunityLineItem(testOpportunity.Id, pricebookEntry.Id);
        Application_Product_CAF__c apc = new Application_Product_CAF__c();
        insert apc;
        testOpportunityLineItem.Application_Product_CAF__c = apc.Id;
        update testOpportunityLineItem;
        System.assert(new OpportunityLineItemsSelector().byApplicationProductCAF(apc.Id) != null);
        test.stopTest();
    }
}