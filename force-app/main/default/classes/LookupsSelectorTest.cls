@isTest 
private class LookupsSelectorTest {

    @isTest
    private static void testSelectById() {
    
        Lookup__c lookupTest = new Lookup__c();
        insert lookupTest;
        
        LookupsSelector lookupsSelectorTest = new LookupsSelector();
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(lookupTest.Id);
        List<Lookup__c> lookupLst = lookupsSelectorTest.selectById(tstSet);
                
        System.assertEquals(lookupLst.size(), 1); 
        
        List<Lookup__c> lookupBankLst = lookupsSelectorTest.selectByBankId(tstSet);
    }
    
    @isTest
    private static void testSelectByBranchCode() {
    
        Lookup__c lookupTest = new Lookup__c();
        lookupTest.Branch_Code__c = '20019';
        insert lookupTest;
        
        LookupsSelector lookupsSelectorTest = new LookupsSelector();
        Set<String> tstSet = new Set<String>();
        tstSet.add(lookupTest.Branch_Code__c);
        List<Lookup__c> lookupLst = lookupsSelectorTest.selectByBranchCode(tstSet);
        
        System.assertEquals(lookupLst.size(), 1); 
    }
    
    @isTest
    private static void testSelectByName() {
    
        Lookup__c lookupTest = new Lookup__c();
        lookupTest.Name = 'Test';
        insert lookupTest;
        
        LookupsSelector lookupsSelectorTest = new LookupsSelector();

        List<Lookup__c> lookupLst = lookupsSelectorTest.selectByName('Test');
        
        System.assertEquals(lookupLst.size(), 0); 
    }
}