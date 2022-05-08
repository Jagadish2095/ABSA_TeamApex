@isTest 
private class ServiceTypesSelectorTest {

    @isTest
    private static void testSelectById() {
    
        Service_Type__c tstServT = new Service_Type__c();
        insert tstServT;
        
        ServiceTypesSelector sqs = new ServiceTypesSelector();
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(tstServT.Id);
        List<Service_Type__c> grps = sqs.selectById(tstSet);
        
        System.assertEquals(grps.size(), 1); 
    }
}