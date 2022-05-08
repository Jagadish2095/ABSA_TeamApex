/**
* Test class for NewOnceOffPaymentController
*
* @author  Himani Joshi
* @version v1.0
* @since   2020-12-11

*/
@IsTest
public class NewOnceOffPaymentControllerTest {
    @testSetup static void createData(){
        Opportunity opp = new Opportunity();
        opp.Name = 'EPP';
        opp.StageName = 'Not Interested';
        opp.CloseDate = Date.today() + 10;
        Insert opp;
        Contact testContact = new Contact();
        testContact.FirstName = 'Test Contact';
        testContact.LastName = '1';
        insert testContact;
        Case caseRecord=new Case();
        caseRecord.Status='New';
        caseRecord.Opportunity__c=opp.Id;
        caseRecord.ContactId=testContact.Id;
        insert caseRecord;
        Payment_plan__c pp=new Payment_plan__c();
        pp.Name=caseRecord.caseNumber;
        pp.Method__c='Debit Instruction';
        pp.Status__c='Submitted';
        pp.Once_Off_Payment_Required__c='Yes';
        pp.Target_Account__c='11';
        pp.Target_Account_Type__c='Savings Account';
        pp.Target_Clearance_Code__c='242';
        pp.Statement_Reference__c='trx';
        pp.Amount_Fullfillment__c='113';
        insert pp;
    }
    static testMethod void testdeleteAccount(){
        Payment_Plan__c pp=[select Id from Payment_Plan__c];
        test.startTest();
        Boolean response =  NewOnceOffPaymentController.deleteAccount(pp.Id);
        System.assertNotEquals(null,response);
        test.stopTest();
    }

}