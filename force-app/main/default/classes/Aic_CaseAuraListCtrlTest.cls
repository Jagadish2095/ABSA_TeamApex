@IsTest
public with sharing class Aic_CaseAuraListCtrlTest {
    
    @testSetup
    static void insertData() {
        Group testGroup = new Group(Name='Unassigned AIC', Type='Queue');
        insert testGroup;

        System.runAs(new User(Id=UserInfo.getUserId()))
        {
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'Case');
            insert testQueue;
        }
        Case caseInTest = new Case(OwnerId = testGroup.Id,  Status = 'New', FIC_Case_returned_to_queue__c = true);
        insert caseInTest;

        Group testGroup2 = new Group(Name='Archive AIC', Type='Queue');
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
        Aic_CaseAuraListCtrl.QueuedCases queuedCases = new  Aic_CaseAuraListCtrl.QueuedCases();
        Test.startTest();
        queuedCases = Aic_CaseAuraListCtrl.getCasesFromQueues();
        Test.stopTest();

        System.assertEquals(true, queuedCases != null, false);
    }

    @isTest
    static void getCasFromunassignedQueueWhenStatusIsNew() {
       List<Case> caseForTest = new List<Case>();
        Test.startTest();
        caseForTest= Aic_CaseAuraListCtrl.getCasFromParticularQueue('Unassigned AIC', 'New');
        Test.stopTest();

        System.assertEquals(false, caseForTest.isEmpty(), true);
    }

    @isTest
    static void getCasFromGlobalSearchWhenStatusIsNew() {
        List<Case> caseForTest = new List<Case>();
        Test.startTest();
        caseForTest= Aic_CaseAuraListCtrl.findCases( 'New');
        Test.stopTest();

        System.assertEquals(false, caseForTest.isEmpty(), true);
    }

    @isTest
    static void getCasFromArchiveSearchWhenStatusIsNew() {
        List<Case> caseForTest = new List<Case>();
        Test.startTest();
        caseForTest= Aic_CaseAuraListCtrl.findArchiveCases( 'New');
        Test.stopTest();

        System.assertEquals(false, caseForTest.isEmpty(), true);
    }

    @isTest
    static void checkSuperUser() {
       Boolean isSuperUSerFlag = true;
            isSuperUSerFlag= Aic_CaseAuraListCtrl.isSuperUser();
        System.assertEquals(false, isSuperUSerFlag, true);
    }
}