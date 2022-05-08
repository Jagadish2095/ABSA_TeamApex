@isTest 
private class UnwantedEmailsSelectorTest {

    @isTest
    private static void testSelectById() {
    
        Unwanted_Email__c tstEmail = new Unwanted_Email__c();
        insert tstEmail;
        UnwantedEmailsSelector ueSel = new UnwantedEmailsSelector();   
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(tstEmail.Id);
        List<Unwanted_Email__c> uweList = ueSel.selectById(tstSet);
        
        System.assertEquals(uweList.size(), 1); 
    }
    
    @isTest
    private static void testSelectByPurgeDate() {
    
        Unwanted_Email__c tstEmail = new Unwanted_Email__c();
        insert tstEmail;
        UnwantedEmailsSelector ueSel = new UnwantedEmailsSelector();   
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(tstEmail.Id);
        DateTime dateNow = System.now();
        dateNow = dateNow.addDays(1);
        List<Unwanted_Email__c> uweList = ueSel.selectByPurgeDate(dateNow);
        
        System.assertEquals(uweList.size(), 1); 
    }
}