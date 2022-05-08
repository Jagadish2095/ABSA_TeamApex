@isTest 
private class ServiceGroupsSelectorTest {

    @isTest
    private static void testSelectById() {
        
        Service_Group__c tstServQG = new Service_Group__c(Name = 'Test', Response_Email_Address__c = 'test@abc.com', Assign_Record_Type__c = 'Service Request');
        insert tstServQG;
        
        ServiceGroupsSelector sqs = new ServiceGroupsSelector();
        
        Set<Id> tstSet = new Set<Id>();
        tstSet.add(tstServQG.Id);
        List<Service_Group__c> grps = sqs.selectById(tstSet);
        
        System.assertEquals(grps.size(), 1); 
        
        Set<String> recordTypeSet = new Set<String>();
        recordTypeSet.add('Service Request');
        sqs.selectByAssignedRecordType(recordTypeSet);
        
        Set<String> nameSet = new Set<String>();
        nameSet.add('Test');
        sqs.selectByName(nameSet);
        
        sqs.selectByNameAndAssignedRecordType(nameSet, recordTypeSet);

    }
}