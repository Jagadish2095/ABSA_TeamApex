@isTest 
private class OrgWideLookupValuesSelectorTest {

    @isTest
    private static void testSelectById() {
    
        
        OrgWideLookupValuesSelector owlvSelector = new OrgWideLookupValuesSelector();
        Set<Id> testSet = new Set<Id>();
        List<Org_Wide_Lookup_Value__mdt> owlvmList = owlvSelector.selectById(testSet);   
        
    }
    
    
    @isTest
    private static void testSelectByLabel() {
    
        OrgWideLookupValuesSelector owlvSelector = new OrgWideLookupValuesSelector();
        List<Org_Wide_Lookup_Value__mdt> owlvmList = owlvSelector.selectByLabel('Test Label');   
        
    }
    
     @isTest
    private static void testSelectByLabels() {
    
        OrgWideLookupValuesSelector owlvSelector = new OrgWideLookupValuesSelector();
        Set<String> testLabels = new Set<String>();
        testLabels.add('Test Label');
        testLabels.add('Test Label 1');
        List<Org_Wide_Lookup_Value__mdt> owlvmList = owlvSelector.selectByLabels(testLabels);   
        
    }
}