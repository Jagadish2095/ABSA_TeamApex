/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-09-28
 * @last modified by  : muvhuso.nekhubvi@absa.africa
**/
@IsTest
public with sharing class Fic_CaseAuraListCtlrTest {
    @testSetup
    static void insertData() {
        Group testGroup = new Group(Name='FIC Maintenance', Type='Queue');
        insert testGroup;

        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }
        Case caseInTest = new Case(OwnerId = testGroup.Id,  Status = 'New', FIC_Case_returned_to_queue__c = true);
        insert caseInTest;

        Group testGroup2 = new Group(Name='Archive', Type='Queue');
        insert testGroup2;

        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup2.id, SObjectType = 'Case');
            insert testQueue;
        }
        Case caseInTest2 = new Case(OwnerId = testGroup2.Id,  Status = 'New', FIC_Case_returned_to_queue__c = true);
        insert caseInTest2;
    }

    @isTest
    static void getGlobalCases() {
        Fic_CaseAuraListCtlr.QueuedCases queuedCases = new  Fic_CaseAuraListCtlr.QueuedCases();
        Test.startTest();
        queuedCases = Fic_CaseAuraListCtlr.getCasesFromQueues();
        Test.stopTest();

        System.assertEquals(true, queuedCases != null, false);
    }

    @isTest
    static void getCasFromMaintenanceQueueWhenStatusIsNew() {
       List<Case> caseForTest = new List<Case>();
        Test.startTest();
        caseForTest= Fic_CaseAuraListCtlr.getCasFromParticularQueue('FIC Maintenance', 'New');
        Test.stopTest();

        System.assertEquals(false, caseForTest.isEmpty(), true);
    }

    @isTest
    static void getCasFromGlobalSearchWhenStatusIsNew() {
        List<Case> caseForTest = new List<Case>();
        Test.startTest();
        caseForTest= Fic_CaseAuraListCtlr.findCases( 'New');
        Test.stopTest();

        System.assertEquals(false, caseForTest.isEmpty(), true);
    }

    @isTest
    static void getCasFromArchiveSearchWhenStatusIsNew() {
        List<Case> caseForTest = new List<Case>();
        Test.startTest();
        caseForTest= Fic_CaseAuraListCtlr.findArchiveCases( 'New');
        Test.stopTest();

        System.assertEquals(false, caseForTest.isEmpty(), true);
    }

    @isTest
    static void assigntCaseToCurrentUser() {
        Case caseToTest = [SELECT Id, OwnerId, FIC_Case_returned_to_queue__c FROM Case LIMIT 1];
        Test.startTest();
        Fic_CaseAuraListCtlr.assignToUser(caseToTest);
        Test.stopTest();
        Case caseAfterTest = [SELECT Id, OwnerId, FIC_Case_returned_to_queue__c FROM Case LIMIT 1];
        System.assertEquals(false, caseAfterTest.FIC_Case_returned_to_queue__c, true);
    }

    @isTest
    static void checkSuperUser() {
       Boolean isSuperUSerFlag = true;
            isSuperUSerFlag= Fic_CaseAuraListCtlr.isSuperUser();
        System.assertEquals(false, isSuperUSerFlag, true);
    }
}