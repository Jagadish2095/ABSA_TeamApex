@isTest 
private class PricingFormulasSelectorTest {

    @isTest
    private static void testSelectById() {
    
        Pricing_Formula__c pricingFormulaTest = new Pricing_Formula__c();
        pricingFormulaTest.Pricing_Template__c = 'Fixed Fee per Item';
        insert pricingFormulaTest;
        
        PricingFormulasSelector pricingFormulaSelectorTest = new PricingFormulasSelector();
        Set<Id> IdSet = new Set<Id>();
        IdSet.add(pricingFormulaTest.Id);
        List<Pricing_Formula__c> pricingFormulaEntryLst = pricingFormulaSelectorTest.selectById(IdSet);
        
        System.assertEquals(pricingFormulaEntryLst.size(), 1); 
    }
}