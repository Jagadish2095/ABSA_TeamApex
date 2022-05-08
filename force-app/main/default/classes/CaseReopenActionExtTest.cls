/**  
* @description      : Test Class for CaseOverrideController
* @Author       : Cloudsmiths 
* @Created Date : 29/03/2019
* UPDATE
*/
@isTest
public class CaseReopenActionExtTest {
    
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
                                AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud',
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                               	Incident_Date__c = date.today(),
                               Reopen_Case_Approval_Required__c =true,
                               Reopen_Case_Reason__c ='Close in Error',
                               External_SLA_Notification_User__c = userInfo.getUserId());
                               
        insert caseRec;       
    }
    
    //Method to test
    static testMethod void testCaseCreateOverrideController() {
        
        Case caseRec = [SELECT Id, AccountId FROM Case LIMIT 1];
        System.assertNotEquals(caseRec, null);
        CaseReopenActionExt.loadData(caseRec.id);
        CaseReopenActionExt.approvalProccessChecks(caseRec.id);
        CaseReopenActionExt.caseOpenCheck(caseRec.id);
        CaseReopenActionExt.reopenCase(caseRec.id, 'test');
    }
}