/**  
 * @Purpose      : Test Class for CaseDeadlockActionExt
 * @Author       : Dreamwares 
 * @Created Date : 05/09/2018
 */
@isTest
public class CaseDeadlockActionExtTest {
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
                                Account = account,
                                Accountid = Account.id,
                               	Email__c = 'test@test.com',
                               	recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                               	Incident_Date__c = date.today(),
                                Deadlock_Reason_Motivation__c = 'test',
                                Deadlock_Approval_Required__c = true,
                                External_SLA_Notification_User__c = userinfo.getUserId());
        insert caseRec;
    }
    
    //Method to test
    static testMethod void testCaseDeadlockAction(){
    	Case caseRec = [SELECT Id FROM Case LIMIT 1];
        
        Test.startTest();
        Boolean result = CaseDeadlockActionExt.approvalProccessChecks(String.valueOf(caseRec.Id));
        CaseDeadlockActionExt.deadlockApproval(String.valueOf(caseRec.Id), 'Testing purpose');
        Test.stopTest();
        Case caseRecord = [Select Id, Status, Deadlock_Reason_Motivation__c From Case Where Id = : caseRec.Id];
        System.assertEquals('Testing purpose', caseRecord.Deadlock_Reason_Motivation__c);
    }
}