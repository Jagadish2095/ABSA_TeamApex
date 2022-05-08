/**
 * @description       :
 * @author            : Sandeep Golla
 * @last modified on  : 2021-07-09
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-07-07   Sandeep Golla   Initial Version
**/
@istest
public class DPChildCaseCreationTest {

    @testSetup
    private static void setup() {
        Account acc = new Account();
        acc.Name = 'Testing Data Privacy';
        acc.SBU_Segment__c = 'B';
        acc.CIF__c = 'JINPIX 001';
        insert acc;

        Case newCase = new Case();
        newCase.Status = 'New';
        newCase.Type__c = 'Data Privacy Issue';
        newCase.AccountId = acc.Id;
        insert newCase;

        Contact contact = new Contact(LastName='Test contact', AccountId = acc.Id, Email = 'agents@support.co.za');
        insert contact;

        Service_Type__c serviceType = new Service_Type__c(
            Name = 'Data Privacy Investigation',
            Case_Record_Type__c = 'Service Request',
            Subtype__c = 'SubtypeTest',
            Type__c = 'TestType'
        );
        insert serviceType;

        Service_Group__c serviceGr = new Service_Group__c(
            Name = 'Business Banking',
            Assign_Record_Type__c = 'Service Request',
            Response_Email_Address__c = 'testclass@test.com',
            Queue__c = 'Email',
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '8'
        );
        insert serviceGr;

        Service_Level__c serviceLevel = new Service_Level__c(
            Name = 'TestServiceLevel',
            External_SLA_Time_Measure__c = 'Hour(s)',
            External_SLA_Units__c = '8',
            Default_Service_Level__c = true
        );
        insert serviceLevel;

        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(
            Service_Type__c = serviceType.Id,
            Service_Group__c = serviceGr.Id,
            Service_Level__c = serviceLevel.Id,
            Auto_Case_Creation__c = true
        );
        insert serviceGrType;
    }

    @istest
    public static void testDataPrivacyChildCaseMethod(){
        List<Account> accountRec = [SELECT Id,Name FROM Account WHERE Name =:'Testing Data Privacy' LIMIT 1];
        List<Case> caseRec = [Select Id,CaseNumber,AccountId,Type__c from Case where AccountId =: accountRec[0].Id];
        Test.startTest();
        DPChildCaseCreation.createChildCaseRB(caseRec[0].Id,accountRec[0].Id);
        System.assertEquals(accountRec.size(), 1);
        System.assertEquals(caseRec.size(), 1);
        Test.stopTest();
    }
}