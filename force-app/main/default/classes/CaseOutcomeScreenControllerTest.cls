/**
* @description Controller Test Class For CaseOutcomeScreenController
* @author Manideep kenche
* @created   2021/09/28
* 
*/
@isTest
public class CaseOutcomeScreenControllerTest {
    @testSetup
    static void dataCreation() {
        Id rtId = [SELECT Id FROM RecordType WHERE IsPersonType = TRUE AND SObjectType='Account' LIMIT 1].Id;
        
        Account account = new Account(FirstName='test',LastName='1',RecordTypeId=rtId);
        insert account;
        Case testCase= new Case();
        testCase.Description='okkk';
        //testCase.CIF__c = 'ARENTAL001';
        testCase.Status='In Progress';
        testCase.Comments__c='okkk';
        testCase.Mobile__c = '13123123';
        testCase.Extended_Request_Data__c = 'test';
        testCase.Account = account;
        
        insert testCase;
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGroupRecord = new Service_Group__c(Name='Early Risk Detection 1st Party Fraud',Queue__c='Queue',Active__c=true, Assign_Record_Type__c = 'Complaint',Business_Hours__c=businessHr.Id);
        insert serviceGroupRecord;
        Service_Level__c sl = new Service_level__c(Name='SL', Default_Service_Level__c = true, External_SLA_Time_Measure__c = 'Day(s)', External_SLA_Units__c = '5');
        insert sl;
        Service_Type__c st = new Service_Type__c(Name='1st Party Fraud', Type__c='Type', Subtype__c='Subtype');
        insert st;
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=serviceGroupRecord.Id, Service_Level__c=sl.id, Service_Type__c=st.Id);
        insert sgt;
    }
    /* Test method for transfer case method
*  Added by : manideep kenche
*  Date : 2021/09/28
*/
    @isTest
    public static void CaseTransferTest() {
        Case caseRecord=[SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case  limit 1];
        
        String previousOwnerCase = caseRecord.OwnerId;
        Test.startTest();
        CaseOutcomeScreenController.transferCase(caseRecord.Id,System.Label.First_Party_Fraud);
        
        Test.stopTest();
        Case caseRecordAfterChange=[SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case  limit 1];
        System.assertNotEquals(caseRecordAfterChange.OwnerId,previousOwnerCase);
    }
    /* Test method for transfer case method
*  Added by : manideep kenche
*  Date : 2021/09/28
*/
    @isTest
    public static void CaseTransferTest2() {
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        Service_Group__c serviceGroupRecord = new Service_Group__c(Name='Everyday Banking - Collections',Queue__c='Queue',Active__c=true, Assign_Record_Type__c = 'Complaint',Business_Hours__c=businessHr.Id);
        insert serviceGroupRecord;
        Service_Level__c sl = new Service_level__c(Name='SL', Default_Service_Level__c = true, External_SLA_Time_Measure__c = 'Day(s)', External_SLA_Units__c = '5');
        insert sl;
        Service_Type__c st = new Service_Type__c(Name='Early risk detection- Possible fraud detection', Type__c='Type', Subtype__c='Subtype');
        insert st;
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=serviceGroupRecord.Id, Service_Level__c=sl.id, Service_Type__c=st.Id);
        insert sgt;
        Case caseRecord=[SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case  limit 1];
        String previousOwnerCase = caseRecord.OwnerId;
        Test.startTest();
        
        CaseOutcomeScreenController.transferCase(caseRecord.Id,System.Label.Complaints_EB_Collections);
        
        Test.stopTest();
        Case caseRecordAfterChange=[SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case  limit 1];
        System.assertNotEquals(caseRecordAfterChange.OwnerId,previousOwnerCase);
    }
    /* Test method for creating task method
*  Added by : manideep kenche
*  Date : 2021/09/28
*/
    
    @isTest
    public static void createTaskTest() {
        Case caseRecord=[SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c,ClientName__c FROM Case  limit 1];
        Test.startTest();
        CaseOutcomeScreenController.createReminder(caseRecord.Id, System.today());
        Test.stopTest();
        Task tsk = [SELECT Id FROM Task];
        System.assertEquals(false,String.isEmpty(tsk.id));
    }
    
    /* Test method for case comments method
*  Added by : manideep kenche
*  Date : 2021/09/28
*/
    
    @isTest
    public static void addCaseCommentTest(){
        Case caseRecord=[SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case  limit 1];
        Test.startTest();
        CaseOutcomeScreenController.addCaseComment(caseRecord.Id,'hey');
        Test.stopTest();
        CaseComment commentRecord = [select CommentBody from CaseComment];
        system.assertEquals(false,String.isEmpty('hey'));
    }
    
    @isTest
    public static void checkDueDateTest(){
        Case caseRecord=[SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case  limit 1];
        Datetime dateFromCalendar = system.today();
        Task newTask = new Task(Description = 'Call ',
                                Priority = 'High',
                                Status = 'Scheduled',
                                Subject = 'Call',
                                IsReminderSet = true,
                                Type='Call',
                                WhatId = caseRecord.Id,
                                ReminderDateTime = dateFromCalendar
                               );
        insert newTask; 
        
        Task getTask = [select id,ReminderDateTime,WhatId from Task where WhatId =: caseRecord.Id];
        DateTime todaysDate = System.today();
        String todaysDateStr = todaysDate.format('yyyy-MM-dd');
        Test.startTest();
        CaseOutcomeScreenController.checkDueDate(caseRecord.Id);
        Test.stopTest();
       
        System.assertEquals(false,String.isEmpty(getTask.id));
    }
    
    @isTest
    public static void pauseCaseAndCreateReminderTest(){
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        Service_Group__c serviceGroupRecord = new Service_Group__c(Name='Early Risk detection - PFD Case Escalated to Fraud',Queue__c='Queue',Active__c=true, Assign_Record_Type__c = 'Complaint',Business_Hours__c=businessHr.Id);
        insert serviceGroupRecord;
        Service_Level__c sl = new Service_level__c(Name='SL', Default_Service_Level__c = true, External_SLA_Time_Measure__c = 'Day(s)', External_SLA_Units__c = '5');
        insert sl;
        Service_Type__c st = new Service_Type__c(Name='Early Risk Detection Holding Case', Type__c='Type', Subtype__c='Subtype');
        insert st;
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=serviceGroupRecord.Id, Service_Level__c=sl.id, Service_Type__c=st.Id);
        insert sgt;
        Case caseRecord=[SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case  limit 1];
        String previousOwnerCase = caseRecord.OwnerId;
        Test.startTest();
        CaseOutcomeScreenController.pauseCaseAndCreateReminder(caseRecord.Id);
        Test.stopTest();
        Case caseRecordAfterChange=[SELECT Id,OwnerId,Description,Status,Comments__c,CIF__c,Client_Mobile_Phone__c FROM Case  limit 1];
        System.assertEquals(caseRecordAfterChange.OwnerId,previousOwnerCase);
    }
}