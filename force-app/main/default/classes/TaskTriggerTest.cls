@isTest
public class TaskTriggerTest {
    
    public static testMethod void testTaskTrigger(){
        WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
        
        Test.startTest();
        
        Task task = new Task();
        task.WhatId = testDataFactory.testOpportunity.id;
        task.Subject = 'Call';
        task.GlobalRefId__c = '0x000138905F33C989';
        insert task;
        TaskTriggerFunctions.checkIfTaskHasComments(task);
        Task taskObj = new Task(Id = task.Id);
        taskObj.Subject = 'Call 200';
        update taskObj;
        
        Task taskDelete = new Task(Id = task.Id);
        delete taskDelete;
        Test.stopTest();
    }
    
}