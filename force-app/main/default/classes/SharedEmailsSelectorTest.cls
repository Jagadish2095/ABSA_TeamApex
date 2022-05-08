@isTest 
private class SharedEmailsSelectorTest {

    @isTest
    private static void testSelectById() {
    
        Shared_Email__c tstShEm = new Shared_Email__c();
        insert tstShEm;
        
        SharedEmailsSelector sems = new SharedEmailsSelector();
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(tstShEm.Id);
        List<Shared_Email__c> grps = sems.selectById(tstSet);
        
        System.assertEquals(grps.size(), 1); 
    }
    
    @isTest
    private static void testSelectBySFEmail() {
    
        Shared_Email__c tstShEm = new Shared_Email__c();
        tstShEm.Salesforce_Email_Address__c = 'Test@SalesForceTest.test';
        insert tstShEm;
        
        SharedEmailsSelector sems = new SharedEmailsSelector();
    
        List<Shared_Email__c> grps = sems.selectBySFEmail('Test@SalesForceTest.test');
    }
    
    @isTest
    private static void testSelectByInboxWithEmailRules() {
    
        Shared_Email__c tstShEm = new Shared_Email__c();
        tstShEm.Inbox_Address__c = 'Test@SalesForceTest.test';
        insert tstShEm;
        
        SharedEmailsSelector sems = new SharedEmailsSelector();
    
        List<Shared_Email__c> grps = sems.selectByInboxWithEmailRules('Test@SalesForceTest.test');

    }
    
    @isTest
    private static void testSelectByToAddressesWithEmailRules() {
    
        Shared_Email__c tstShEm = new Shared_Email__c();
        tstShEm.Salesforce_Email_Address__c = 'Test@SalesForceTest.test';
        insert tstShEm;
        
        SharedEmailsSelector sems = new SharedEmailsSelector();
        Set<String> tstSet = new Set<String>();
        tstSet.add('Test@SalesForceTest.test');
    
        List<Shared_Email__c> grps = sems.selectByToAddressesWithEmailRules(tstSet);
    }
    
    @isTest
    private static void testSelectByToAddressesAndPriorityWithEmailRules() {
    
        Shared_Email__c tstShEm = new Shared_Email__c();
        tstShEm.Salesforce_Email_Address__c = 'Test@SalesForceTest.test';
        insert tstShEm;
        
        SharedEmailsSelector sems = new SharedEmailsSelector();
        Set<String> tstSet = new Set<String>();
        tstSet.add('Test@SalesForceTest.test');
    
        List<Shared_Email__c> grps = sems.selectByToAddressesAndPriorityWithEmailRules(tstSet);
    }
    
}