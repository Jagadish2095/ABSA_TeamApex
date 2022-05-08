/**
 * Test class for BankserveAfricaExcelReportController
 *
 * W-005324
 * @author  Himani Joshi
 * @since   03-09-2020
 */

@isTest
public class BankserveAfricaExcelReportControllerTest {
    @testSetup
    static void createData() {
        Account account = new Account();
        account.Name = 'Test Account';
        account.Client_Type__c = 'Private Individual';
        account.CIF__c = 'Test+001';
        insert account;

        Opportunity opp = new Opportunity();
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Merchant Onboarding').getRecordTypeId();
        opp.SelectedProduct__c = 'E-Commerce';
        opp.AccountId = account.Id;
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        opp.Website_URL__c = 'http://www.google.com';
        insert opp;

        Merchant_Id__c md = new Merchant_Id__c();
        md.Merchant_Id__c = 'MANUALLY_CREATED';
        md.Merchant_Class__c = 'RETAIL';
        insert md;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;
        app.Merchant_Id_Ref__c = md.Id;

        insert app;

        //Products
        Id pricebookId = Test.getStandardPricebookId();

        //For Policy without Spouse
        Product2 product1 = new Product2();
        product1.name = 'E-Commerce';
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
        oppLineItem.Parent_Opportunity_Line_Item_Id__c = null;
        insert oppLineItem;
        system.debug('oppLineItem' + oppLineItem);
        Application_Product_Merchant__c testAppProdMerch = new Application_Product_Merchant__c();
        testAppProdMerch.Opportunity_Product_Id__c = oppLineItem.Id;
        testAppProdMerch.CSP__c = 'Absa e-commerce Payment';
        insert testAppProdMerch;
    }

    @isTest
    static void testGetObjectData() {
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        OpportunityLineItem oppLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new BankserveAfricaExcelReportController());
        Test.stopTest();
    }
}