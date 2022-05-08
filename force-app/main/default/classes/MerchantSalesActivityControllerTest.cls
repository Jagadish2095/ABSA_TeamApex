@isTest
public class MerchantSalesActivityControllerTest {

    @isTest static void testGetselectOptions() {

        Opportunity opp = new Opportunity();
        Test.startTest();
		List<String> selectOptions = MerchantSalesActivityController.getselectOptions(opp, 'StageName');

        System.assertNotEquals(null, selectOptions);
        Test.stopTest();
    }

    @isTest static void testGetApplicationProductMerchant() {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Application_Product_Merchant__c appProdMerch = MerchantSalesActivityController.getApplicationProductMerchant(opp.Id);

        System.assertNotEquals(null, appProdMerch);
        Test.stopTest();
    }

    @isTest static void testGetApplicationProductMerchantId() {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Id appProdMerchId = MerchantSalesActivityController.getApplicationProductMerchantId(opp.Id);

        System.assertNotEquals(null, appProdMerchId);
        Test.stopTest();
    }

    @isTest static void testGetProductClassification() {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Product2 classifications = MerchantSalesActivityController.getProductClassification(opp.Id);

        System.assertNotEquals(null,classifications);
        Test.stopTest();
    }

    @isTest static void testGetApplication() {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Application__c application = MerchantSalesActivityController.getApplication(opp.Id);

         System.assertNotEquals(null,application);
        Test.stopTest();
    }

    //Danie Booysen: 2020-08-12 (W-005252)
    @isTest static void testDetermineFieldVisibility(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
        List<Field_Visibility_Per_Product__mdt> fieldVisibilityMdt = MerchantSalesActivityController.determineFieldVisibility('MerchantSalesActivity', opp.Id);
        System.assertNotEquals(null, fieldVisibilityMdt);
        Test.stopTest();
    }


    /*@isTest static void testGetApplicationX() {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        Application__c application = MerchantSalesActivityController.getApplication(opp.Id);


        System.assertEquals(null,application);
        Test.stopTest();
    }*/

    @testSetup static void createData(){

        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;

        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;
        Insert app;

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
}