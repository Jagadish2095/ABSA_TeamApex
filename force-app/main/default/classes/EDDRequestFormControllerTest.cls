/**
 * @description       :
 * @author            : Sandeep Golla
 * @group             :
 * @last modified on  : 05-07-2021
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   05-07-2021   Sandeep Golla   Initial Version
**/
@istest
public class EDDRequestFormControllerTest{
    @istest
    public static void testupdateEddDetailswithoutfile(){
        Account newtobank = new Account();
        newtobank.ID_Number__pc = '9308305015082';
        newtobank.FirstName = 'testUpdateCreateAccountWithCIF';
        newtobank.LastName = 'Tester';
        insert newtobank;
        
        Case caseRec = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'What do you want to do today?',
            AccountId = newtobank.Id,
            Type__c = 'EDD Request',
            Subject = 'Test Special Deferral',
            Email__c = 'wow@absa.com'
        );
        insert caseRec;
        EDDRequestFormController.updateEddDetails(caseRec.Id,'','','','','',false);
        System.assertNotEquals(caseRec.Id, null);
    }
    @istest
    public static void testupdateEddDetailswithfile(){
        Account newtobank = new Account();
        newtobank.ID_Number__pc = '9308305015082';
        newtobank.FirstName = 'testUpdateCreateAccountWithCIF';
        newtobank.LastName = 'Tester';
        insert newtobank;
        
        Case caseRec = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'What do you want to do today?',
            AccountId = newtobank.Id,
            Type__c = 'EDD request',
            Subject = 'Test Special Deferral',
            Email__c = 'wow@absa.com'
        );
        insert caseRec;
        EDDRequestFormController.updateEddDetails(caseRec.Id,'','','Test attachment','test','test',true);
        System.assertNotEquals(caseRec.Id, null);
    }
}