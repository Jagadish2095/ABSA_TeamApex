/**
 * @description       : Test Class For ClosureofAccount class
 * @author            : Mohammed Junaid U
 * @group             :
 * @last modified on  : 2021-09-27
 * @last modified by  : mohammedjunaid.usman@absa.africa
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   2021-09-27   Mohammed Junaid U   Initial Version
 **/
@isTest
public class ClosureOfAccountTest {
    
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
    }
    @isTest
    public static void testgetExtendedData() {
        List<Account> accountRec = [SELECT Id,Name FROM Account WHERE Name =:'Testing Data Privacy' LIMIT 1];
        List<Case> caseRec = [Select Id,CaseNumber,AccountId,Type__c from Case where AccountId =: accountRec[0].Id];
        Test.startTest();
        String str = ClosureOfAccount.getExtendedData(caseRec[0].Id);
        system.assertEquals(str, Null);
        Test.stopTest();
    }
    
    @isTest
    public static void testgetExtendedData2() {
        List<Account> accountRec = [SELECT Id,Name FROM Account WHERE Name =:'Testing Data Privacy' LIMIT 1];
         List<Case> caseRec = [Select Id,CaseNumber,AccountId,Type__c from Case where AccountId =: accountRec[0].Id];
        
        List<ClosureOfAccount.journalDetails> debitdetails = new List<ClosureOfAccount.journalDetails>();
        List<ClosureOfAccount.journalDetails> creditdetails = new List<ClosureOfAccount.journalDetails>();
        ClosureOfAccount.journalDetails dbdetail = new ClosureOfAccount.journalDetails();
        dbdetail.name = 'Test';
        dbdetail.accountNumber = '1234';
        dbdetail.amount = 100;
        dbdetail.count = 1;
        ClosureOfAccount.journalDetails crdetail = new ClosureOfAccount.journalDetails();
        crdetail.name = 'Test1';
        crdetail.accountNumber = '123456';
        crdetail.amount = 100;
        crdetail.count = 1;
        debitdetails.add(dbdetail);
        creditdetails.add(crdetail);
        ClosureOfAccount.accountClosure accClosure = new ClosureOfAccount.accountClosure();
        accClosure.closedProduct = 'closedProduct';
        accClosure.accountHold = 'Yes';
        accClosure.reasonForHold = 'accountHoldReason';
        accClosure.referenceNumber = 'referenceNumber';
        accClosure.debitDetails = debitdetails;
        accClosure.creditDetails = creditdetails;
        String jSONString = JSON.serialize(accClosure);

        caseRec[0].Extended_Request_Data__c = jSONString;
        update caseRec;
        
        Test.startTest();
        String str = ClosureOfAccount.getExtendedData(caseRec[0].Id);
        system.assertNotEquals(str, Null);
        Test.stopTest();
    }
    
    @isTest
    public static void testupsertAccountClosure() {
        List<Account> accountRec = [SELECT Id,Name FROM Account WHERE Name =:'Testing Data Privacy' LIMIT 1];
        List<Case> caseRec = [Select Id,CaseNumber,AccountId,Type__c from Case where AccountId =: accountRec[0].Id];
        List<ClosureOfAccount.journalDetails> debitdetails = new List<ClosureOfAccount.journalDetails>();
        List<ClosureOfAccount.journalDetails> creditdetails = new List<ClosureOfAccount.journalDetails>();
        ClosureOfAccount.journalDetails dbdetail = new ClosureOfAccount.journalDetails();
        dbdetail.name = 'Test';
        dbdetail.accountNumber = '1234';
        dbdetail.amount = 100;
        dbdetail.count = 1;
        ClosureOfAccount.journalDetails crdetail = new ClosureOfAccount.journalDetails();
        crdetail.name = 'Test1';
        crdetail.accountNumber = '123456';
        crdetail.amount = 100;
        crdetail.count = 1;
        debitdetails.add(dbdetail);
        creditdetails.add(crdetail);
        string jSONdbDetail = JSON.serialize(debitdetails);
        string jSONcrDetail = JSON.serialize(creditdetails);
        
        Test.startTest();
        ClosureOfAccount.upsertAccountClosure(caseRec[0].Id, 'closedProduct', 'yes', 'accountHoldReason', jSONdbDetail, jSONcrDetail, 'referenceNumber', 'Test', 'Test', 'Test', true);
        ClosureOfAccount.upsertAccountClosure(caseRec[0].Id, 'closedProduct', 'No', 'accountHoldReason', jSONdbDetail, jSONcrDetail, 'referenceNumber', 'Test', 'Test', 'Test', true);
		system.assertNotEquals(caseRec[0].Id, null);
        Test.stopTest();
    }
}