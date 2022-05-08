@IsTest
public class ApplicationProductCreditSelectorTest {
    
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
        
        Application__c app = new Application__c();
        app.Opportunity__c = opp.Id;
        
        insert app;
            
            
        Application_Product_Credit__c testAppProdCred = new Application_Product_Credit__c();
        testAppProdCred.Opportunity_Product_Id__c = oppLineItem.Id;
        
        Insert testAppProdCred;
    }

    @isTest static void testSelectByOpportunityId() {
        Application__c app = [SELECT Id FROM Application__c Limit 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        ApplicationProductCreditSelector selector = new ApplicationProductCreditSelector();
        
        Test.startTest();
        List<Application_Product_Credit__c> appProdCredList = selector.selectByOpportunityId(opp.Id);
        Test.stopTest();
    }
    
    @isTest static void testSelectIdsByOpportunityId() {
        OpportunityLineItem opportunityLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        Application_Product_Credit__c apc = [SELECT Id,Opportunity_Product_Id__c FROM Application_Product_Credit__c LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        ApplicationProductCreditSelector selector = new ApplicationProductCreditSelector();
        
        Test.startTest();
        List<Application_Product_Credit__c> appProdCredList = selector.selectIdsByOpportunityId(opp.Id);
        Test.stopTest();
    }
    @isTest static void testselectByOpportunityIdPositive() {
       
        Application__c app = [SELECT Id FROM Application__c Limit 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Application_Product_Credit__c apc = [SELECT Id,Opportunity_Product_Id__c FROM Application_Product_Credit__c LIMIT 1];
        ApplicationProductCreditSelector selector = new ApplicationProductCreditSelector();
        
        Test.startTest();
        List<Application_Product_Credit__c> appProdCredList = selector.selectByOpportunityId(apc.Opportunity_Product_Id__c);
        Test.stopTest();
    }
    @isTest static void testSelectIdsByOpportunityLineItemId() {
        
        OpportunityLineItem opportunityLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        ApplicationProductCreditSelector selector = new ApplicationProductCreditSelector();
        
        Test.startTest();
        List<Application_Product_Credit__c> appProdCredList = selector.selectIdsByOpportunityLineItemId(opportunityLineItem.Id);
        Test.stopTest();
    }
       @isTest static void testSelectApplicationProuductById() {
        
        Application_Product_Credit__c apc = [SELECT Id FROM Application_Product_Credit__c LIMIT 1];
        ApplicationProductCreditSelector selector = new ApplicationProductCreditSelector();
        
        Test.startTest();
        Application_Product_Credit__c appProdCred = selector.SelectApplicationProuductById(apc.Id);
        Test.stopTest();
       }
    @isTest static void testSelectIdsByOpportunityId2() {
         OpportunityLineItem opportunityLineItem = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        Application__c app = [SELECT Id,Opportunity__c FROM Application__c Limit 1];
        Application_Product_Credit__c apc = [SELECT Id,Opportunity_Product_Id__c FROM Application_Product_Credit__c LIMIT 1];
        ApplicationProductCreditSelector selector = new ApplicationProductCreditSelector();
        
        Test.startTest();
        List<Application_Product_Credit__c> appProdCredList = selector.selectIdsByOpportunityId(app.Opportunity__c);
        Test.stopTest();
    }
}