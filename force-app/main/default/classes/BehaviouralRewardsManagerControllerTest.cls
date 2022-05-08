/**
 * @Purpose      : Test Class for BehaviouralRewardsManagerController
 * @Author       : Jason Quevauvilliers
 * @Created Date : 02/11/2020
 */
@isTest
public class BehaviouralRewardsManagerControllerTest {

    /*
     * Purpose : Method to create test data
     */
    @testSetup
    static void dataCreation(){
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
    	Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;

        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email',
                                Account = account ,
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                               	Incident_Date__c = date.today());
        insert caseRec;

        Service_Group__c serviceGroupRecord = new Service_Group__c(Name='Benefits Team Call Centre',Queue__c='Queue',Active__c=true, Assign_Record_Type__c = 'Complaint');
        insert serviceGroupRecord;
        Service_Level__c sl = new Service_level__c(Name='SL', Default_Service_Level__c = true);
        insert sl;
        Service_Type__c st = new Service_Type__c(Name='Behavioural Rewards', Type__c='Type', Subtype__c='Subtype');
        insert st;
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=serviceGroupRecord.Id, Service_Level__c=sl.id, Service_Type__c=st.Id);
        insert sgt;

    }

    static testMethod void testTransferCase(){
        Case caseRec = [SELECT Id, Transfer_Reason__c FROM Case LIMIT 1];
        caseRec.BusinessHoursId = [Select Id From BusinessHours Where isActive = true Limit 1].Id;
        update caseRec;

        Test.startTest();
        BehaviouralRewardsManagerController.transferCase('Benefits Team Call Centre', 'Behavioural Rewards', caseRec.Id);
        Test.stopTest();

        Case caseAfter = [SELECT Id, sd_Service_Group__c FROM Case LIMIT 1];
        System.assertEquals(caseAfter.sd_Service_Group__c, 'Benefits Team Call Centre');
    }
}