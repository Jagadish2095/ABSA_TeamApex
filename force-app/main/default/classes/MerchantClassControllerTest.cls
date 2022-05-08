@isTest
public class MerchantClassControllerTest {

    @isTest static void testGetOpportunityLineItemId() {

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
		Id opportunityLineItemId = MerchantClassController.getOpportunityLineItemId(opp.Id);
        Test.stopTest();
        System.assertNotEquals(opportunityLineItemId, null);
    }

    @isTest static void testGetOpportunityLineItemIdNegative() {

        OpportunityLineItem oppLineItem = [SELECT Id, Parent_Opportunity_Line_Item_Id__c FROM OpportunityLineItem LIMIT 1];
        oppLineItem.Parent_Opportunity_Line_Item_Id__c = 'TestID';
        update oppLineItem;

        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Test.startTest();
		Id opportunityLineItemId = MerchantClassController.getOpportunityLineItemId(opp.Id);
        Test.stopTest();
        System.assertEquals(opportunityLineItemId, null);
    }

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

    }
}