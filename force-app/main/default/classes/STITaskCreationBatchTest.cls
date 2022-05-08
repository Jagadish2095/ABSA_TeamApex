@IsTest
private class STITaskCreationBatchTest {
    static testMethod void testSelectByOpportunityId() {
        Id RecordTypeId=Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('STI').getRecordTypeId();
        Opportunity testOpportunity = WillsTestDataFactory.createOpportunity();
        testOpportunity.RecordTypeId = RecordTypeId;
        Date dt = System.today().addDays(-7);
        testOpportunity.Task_Creation_Date_For_5_Days__c = dt;
        testOpportunity.StageName ='Closed Won (Success)';
        update testOpportunity;
        
        Opportunity opps = [SELECT Id,StageName, OwnerId,Task_Creation_Date_For_5_Days__c,Five_Business_Days__c,RecordType.name 
                            FROM Opportunity WHERE id=: testOpportunity.id];
        System.assert(opps.StageName=='Closed Won (Success)');
        
        Test.startTest();
        STITaskCreationBatch tcb= new STITaskCreationBatch();
        DataBase.executeBatch(tcb); 
        System.schedule('Test Job', '20 30 8 10 2 ?', new STITaskCreationBatch());
        Test.stopTest();
    }
}