@isTest
public class ApplicationProductMerchantsSelectorTest {

    @testSetup static void createData(){

        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;

        //Products
        Id pricebookId = Test.getStandardPricebookId();

        //For Policy without Spouse
        Product2 product1 = new Product2();
        product1.name = 'EPP Executor Fees Policy';
        product1.IsActive = true;
        insert product1;
        PricebookEntry pricebookEntry1 = new PricebookEntry();
        pricebookEntry1.UnitPrice = 0;
        pricebookEntry1.Product2Id = product1.id;
        pricebookEntry1.Pricebook2Id = pricebookId;
        pricebookEntry1.IsActive = true;
        insert pricebookEntry1;

        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.OpportunityId = opp.Id;
        oppLineItem.Product2Id = product1.Id;
        oppLineItem.PricebookEntryId = pricebookEntry1.Id;
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 100;
        Insert oppLineItem;

        Application_Product_Merchant__c testAppProdMerch = new Application_Product_Merchant__c();
        testAppProdMerch.Opportunity_Product_Id__c = oppLineItem.Id;
        Insert testAppProdMerch;
    }

    @isTest static void testSelectByOpportunityId() {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        ApplicationProductMerchantsSelector selector = new ApplicationProductMerchantsSelector();

        Test.startTest();
        List<Application_Product_Merchant__c> appProdMerchList = selector.selectByOpportunityId(opp.Id);
        System.assertEquals(appProdMerchList.size(), 1);
        Test.stopTest();
    }

    @isTest static void testSelectIdsByOpportunityId() {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        ApplicationProductMerchantsSelector selector = new ApplicationProductMerchantsSelector();

        Test.startTest();
        List<Application_Product_Merchant__c> appProdMerchList = selector.selectIdsByOpportunityId(opp.Id);
        System.assertEquals(appProdMerchList.size(), 1);
        Test.stopTest();
    }

    @isTest static void testSelectIdsByOpportunityLineItemId() {

        OpportunityLineItem opportunityLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        ApplicationProductMerchantsSelector selector = new ApplicationProductMerchantsSelector();

        Test.startTest();
        List<Application_Product_Merchant__c> appProdMerchList = selector.selectIdsByOpportunityLineItemId(opportunityLineItem.Id);
        System.assertEquals(appProdMerchList.size(), 1);
        Test.stopTest();
    }

    //PJAIN: 20200520
    @isTest static void testSelectById() {

        Application_Product_Merchant__c applicationProductMerchant = [SELECT Id FROM Application_Product_Merchant__c LIMIT 1];
        ApplicationProductMerchantsSelector selector = new ApplicationProductMerchantsSelector();

        Test.startTest();
        List<Application_Product_Merchant__c> appProdMerchList = selector.selectById(applicationProductMerchant.Id);
        System.assertEquals(appProdMerchList.size(), 1);
        Test.stopTest();
    }
    //Himani Joshi:03-09-2020
    @isTest
    static void testSelectByOpportunityLineItemIds() {
        OpportunityLineItem opportunityLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        Set<Id> opportunityLineItemIds = new Set<Id>();
        opportunityLineItemIds.add(opportunityLineItem.Id);
        ApplicationProductMerchantsSelector selector = new ApplicationProductMerchantsSelector();
        Test.startTest();
        List<Application_Product_Merchant__c> appProdMerchList = selector.selectByOpportunityLineItemIds(opportunityLineItemIds);
        System.assertEquals(appProdMerchList.size(), 1);
        Test.stopTest();
    }
}