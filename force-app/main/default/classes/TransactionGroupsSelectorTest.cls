@isTest 
private class TransactionGroupsSelectorTest {

    @isTest
    private static void testSelectById() {
    
        Transaction_Group__c transactionGroupTest = new Transaction_Group__c();
        insert transactionGroupTest;
        
        TransactionGroupsSelector transactionGroupSelectorTest = new TransactionGroupsSelector();
        Set<Id> IdSet = new Set<Id>();
        IdSet.add(transactionGroupTest.Id);
        List<Transaction_Group__c> transactionGroupEntryLst = transactionGroupSelectorTest.selectById(IdSet);
        
        System.assertEquals(transactionGroupEntryLst.size(), 1); 
    }
}