@isTest 
private class MerchantRiskChecksSelectorTest {
    
    @TestSetup
    static void makeData(){
        
        // Instantiating the Pricing Test Data Factory creates pricing related records
        PricingTestDataFactory pricingTestDataFactory = new PricingTestDataFactory();
        
        //Create Merchant Risk Check
        Merchant_Risk_Check__c riskCheckRecord = new Merchant_Risk_Check__c();
        riskCheckRecord.Opportunity__c = PricingTestDataFactory.opportunity.id;
        insert riskCheckRecord;
        
    }
    
    @isTest
    private static void testSelectById() {
        
        Merchant_Risk_Check__c merchantRisk = [SELECT Id FROM Merchant_Risk_Check__c LIMIT 1];
        
        Set<Id> IdSet = new Set<Id>();
        IdSet.add(merchantRisk.Id);
        
        List<Merchant_Risk_Check__c> testMerchantRisk = new MerchantRiskChecksSelector().selectById(IdSet);
        
        System.assertEquals(testMerchantRisk.size(), 1);
    }
    
    @isTest
    private static void testSelectByParentProductId() {
        
        Opportunity opportunityRec = [SELECT Id FROM Opportunity LIMIT 1];
        
        List<Merchant_Risk_Check__c> testMerchantRisk = new MerchantRiskChecksSelector().selectByOpportunityId(opportunityRec.id);
        
        System.assertEquals(testMerchantRisk.size(), 1);
    }
}