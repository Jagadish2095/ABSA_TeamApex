/**  
 * @Purpose      : Test Class for CaseFlagActionExt
 * @Author       : Dreamwares 
 * @Created Date : 05/09/2018
 */
@isTest
public class CaseFlagActionExtTest {
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
                                SLA_Extension_Approval_Required__c = true, 
                                External_SLA_End_Date__c = Date.today(),
                                Accountid = Account.id,
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                               	Incident_Date__c = date.today());
        insert caseRec;
    }
    
    //Method to test
    static testMethod void testCaseFlagAction(){
    	Case caseRec = [SELECT Id FROM Case LIMIT 1];
        
        Test.startTest();
        CaseFlagActionExt.flagCase(String.valueOf(caseRec.Id), 'Out-of-Office');
        Test.stopTest();
    }
    
    //Method to test
    static testMethod void negTestCaseFlagAction(){
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        
        Test.startTest();
        CaseFlagActionExt.flagCase(String.valueOf(caseRec.Id), 'New');
        Test.stopTest();
    }
}