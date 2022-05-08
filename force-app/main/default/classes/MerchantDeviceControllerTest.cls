/*@ Author: Danie Booysen
**@ Date: 19/05/2020
**@ Description: Test class for the MerchantDeviceController */
@isTest
public class MerchantDeviceControllerTest {

    //Prepare the testdata
    @testSetup static void createData(){

        Opportunity opp = new Opportunity();
        opp.Name = 'MerchantDeviceControllerTest';
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

        Device_Merchant__c testDeviceMerchant = new Device_Merchant__c();
        testDeviceMerchant.Application_Product_Merchant__c = testAppProdMerch.Id;
        insert testDeviceMerchant;
    }

    @isTest static void testGetMerchDevices() {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];

        Test.startTest();
        List<Device_Merchant__c> deviceListTest = MerchantDeviceController.getMerchDevices(opp.Id);
        System.assertNotEquals(null, deviceListTest);
        Test.stopTest();
    }
    
    @isTest static void testDetermineFieldVisibility() {
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        Opportunity opp = testDataFactory.testOpportunity;
        test.startTest();
        System.assertNotEquals(null, MerchantDeviceController.determineFieldVisibility(opp.Id,'MerchantDevice'));
        test.stopTest();
    }
}