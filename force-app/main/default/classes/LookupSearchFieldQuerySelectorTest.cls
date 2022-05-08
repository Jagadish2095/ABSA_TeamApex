@isTest 
private class LookupSearchFieldQuerySelectorTest {

    @isTest
    private static void testSelectById() {
    
        LookupSearchFieldQuerySelector qSelector = new LookupSearchFieldQuerySelector();
        Set<Id> testSet = new Set<Id>();
        List<Lookup_Search_Field_Query__mdt> mdtList = qSelector.selectById(testSet);   
        
    }
    
    
    @isTest
    private static void testSelectByLabel() {
    
        LookupSearchFieldQuerySelector qSelector = new LookupSearchFieldQuerySelector();
        List<Lookup_Search_Field_Query__mdt> mdtList = qSelector.selectByLabel('Test Label');   
        
    }
    
}