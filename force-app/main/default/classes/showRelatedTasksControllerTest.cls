@isTest
public class showRelatedTasksControllerTest {
    private static testmethod void testAll() {
        Test.startTest();
        WillsTestDataFactory testDataFactory = new WillsTestDataFactory();
        Opportunity testOpportunity = testDataFactory.testOpportunity;
        Task t = new Task(OwnerId=testDataFactory.testUser.id,Status='Open',WhatId=testOpportunity.id,Subject='Test');
        insert t;
        string relatedTask = showRelatedTasksController.getRelatedTasks(testOpportunity.id);
        System.assertNotEquals(null, relatedTask);
        Test.stopTest();
    }
}