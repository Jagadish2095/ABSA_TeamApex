/**
* @description Test class for OrgWideEmailAddressesSelector
* @since 2019-04-29
**/
@isTest 
private class OrgWideEmailAddressesSelectorTest {

    @isTest
    private static void testSelectById() {
        
        OrgWideEmailAddressesSelector oweaSelector = new OrgWideEmailAddressesSelector();
        Set<Id> testSet = new Set<Id>();
        List<OrgWideEmailAddress> owemList = oweaSelector.selectById(testSet); 
        owemList = oweaSelector.selectAAActivity(); 
 
    }
    
    
    @isTest
    private static void testSelectAll() {
    
        OrgWideEmailAddressesSelector oweaSelector = new OrgWideEmailAddressesSelector();
        List<OrgWideEmailAddress> oweamList = oweaSelector.SelectAll();   
        
    }
    
     @isTest
    private static void testSelectByDisplayNamey() {
    
        OrgWideEmailAddressesSelector oweaSelector = new OrgWideEmailAddressesSelector();
        Set<String> displayNames = new Set<String>();
        displayNames.add('test@testing.com');
        
        List<OrgWideEmailAddress> oweamList = oweaSelector.selectByAddress(displayNames);   
        
    }
}