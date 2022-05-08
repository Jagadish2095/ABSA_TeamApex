@isTest  
private class ApplicationProductCAFSelectorTest {
    @isTest
    private static void testSelectById() {
        Application_Product_CAF__c apCAF = new Application_Product_CAF__c();
        apCAF.Bank_name__c = 'test';
        insert apCAF;
        ApplicationProductCAFSelector aps = new ApplicationProductCAFSelector();
        Set<Id> apSet = new Set<Id>();
        apSet.add(apCAF.Id);
        List<Application_Product_CAF__c> apsList = aps.selectById(apSet);
        
        System.assertEquals(apsList.size(), 1, 'CPF'); 
    }
    @isTest
    private static void testselectByAppProdCAFId() {
        Application_Product_CAF__c apCAF = new Application_Product_CAF__c();
        apCAF.Bank_name__c = 'test';
        insert apCAF;
        ApplicationProductCAFSelector aps = new ApplicationProductCAFSelector();
        Application_Product_CAF__c apsList = aps.selectByAppProdCAFId(apCAF.Id);
        
        System.assertEquals(apsList.Bank_name__c, 'test', 'CPF'); 
    }
    
    
        @isTest
    private static void testSelectByOpportunityLineItemId() {
         Application_Product_CAF__c apCAF = new Application_Product_CAF__c();
        apCAF.Bank_name__c = 'test';
        insert apCAF;
        
         Opportunity testOpportunity = new Opportunity(
            StageName = 'new',
            CloseDate = System.today(),
            Name = 'Test Opportunity'
        );
        insert testOpportunity;

         Id pricebookId = Test.getStandardPricebookId();
        //Create your product
        Product2 prod = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        insert prod;
        
        //Create your pricebook entry
        PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;
        
        
        OpportunityLineItem oli = new OpportunityLineItem(
            OpportunityId  = testOpportunity.Id,
            Quantity = 5,
            PricebookEntryId = pbEntry.Id,
            TotalPrice = 100,
            Application_Product_CAF__c = apCAF.Id
        );
        insert oli;
             
        Set<Id> oliSet = new Set<Id>();
        oliSet.add(oli.Id);

        
        ApplicationProductCAFSelector aps = new ApplicationProductCAFSelector();
        List<Application_Product_CAF__c> apsList = aps.selectByOpportunityLineItemId(oliSet);
        System.assertEquals(apsList.size(), 0, 'false');
        
    }
}