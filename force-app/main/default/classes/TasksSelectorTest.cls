/**
 * @description Test class for TasksSelector
 * @since 2019-05-05
 **/

@isTest
public with sharing class TasksSelectorTest {
	@isTest static void testSelectById() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Task taskRec = new Task();
		taskRec.WhatId = testDataFactory.testOpportunity.id;
		taskRec.WhoId = testDataFactory.testContact.Id;
		taskRec.Subject = 'Call';
		insert taskRec;

		Set<Id> ids = new Set<Id>();
		ids.add(taskRec.Id);
		Test.startTest();
		List<Task> taskList = new TasksSelector().selectById(ids);
		system.assertNotEquals(null, taskList);
		Set<Id> idset = new Set<Id>();
		idset.add(taskRec.WhoId);

		List<Task> taskList2 = new TasksSelector().selectTasksByWhoIdForMergeLeads(idset);

		Test.stopTest();
	}

	@isTest static void testSelectByWhatId() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Task taskRec = new Task();
		taskRec.WhatId = testDataFactory.testOpportunity.id;
		taskRec.Subject = 'Call';
		insert taskRec;

		Set<Id> ids = new Set<Id>();
		ids.add(taskRec.Id);
		Test.startTest();
		List<Task> taskList = new TasksSelector().selectByWhatId(ids);
		system.assertNotEquals(null, taskList);

		Test.stopTest();
	}
	@isTest static void testSelectByStatusAndRecordTypeIdAndActionDate() {
		Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
		Id taskRecordTypeId = taskRecordTypeMap.get('Communication Plan Tasks').RecordTypeId;
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		Task taskRec = new Task();
		taskRec.WhatId = testDataFactory.testOpportunity.id;
		taskRec.Subject = 'Call';
		insert taskRec;

		Set<Id> ids = new Set<Id>();
		ids.add(taskRec.Id);
		Test.startTest();
		List<Task> taskList = new TasksSelector().selectByStatusAndRecordTypeIdAndActionDate('Scheduled', taskRecordTypeId, System.now());
		system.assertNotEquals(null, taskList);

		Test.stopTest();
	}
	@isTest static void testSelectTasksByWhoId() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		Task taskRec = new Task();
		taskRec.WhatId = testDataFactory.testOpportunity.id;
		taskRec.Subject = 'Call';
		insert taskRec;

		Set<Id> ids = new Set<Id>();
		ids.add(taskRec.Id);
		Test.startTest();
		List<Task> taskList = new TasksSelector().selectTasksByWhoId(ids);
		system.assertNotEquals(null, taskList);

		Test.stopTest();
	}

    @isTest
    static void testselectRuleRecordTypeStatus() {
        Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Task.sObjectType.getDescribe().getRecordTypeInfosByName();
		Id taskRecordTypeId = taskRecordTypeMap.get('Direct Delivery Sales Task').RecordTypeId;
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		Task taskRec = new Task();
		taskRec.WhatId = testDataFactory.testOpportunity.id;
        taskRec.WhoId = testDataFactory.testContact.Id;
		taskRec.Subject = 'Call';
        taskRec.status = 'open';
        taskRec.recordTypeId = taskRecordTypeId;
        taskRec.Communication_Rule_Id__c = taskRecordTypeId;
		insert taskRec;

        Set<Id> ids = new Set<Id>();
		ids.add(taskRec.Id);

        Set<Id> whoids = new Set<Id>();
        whoids.add(testDataFactory.testContact.Id);

        Test.startTest();
        List<Task> taskList = new TasksSelector().selectByRuleIdsRecordTypeAndStatus(ids, taskRecordTypeId, 'open');
        system.assertNotEquals(null, taskList);
        new TasksSelector().selectByStatusAndActivityDate('open','completed');
        taskList = new TasksSelector().selectTasksByWhoIdForMergeLeads(whoids);
		system.assertNotEquals(null, taskList);
        Test.stopTest();

    }
}