/**  
* @Purpose      : Test Class for CaseQAChecklistSelector
* @Author       : Jaco de Lange		 
* @Created Date : 2020-01-26
*/
@isTest
public class CaseQAChecklistSelectorTest {
    
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
                                recordTypeId = caseRecordTypeMap.get('CAF_Application').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today());
        insert caseRec;
        
        Case_Checklist__c testccl =  new Case_Checklist__c(related_case__c = caseRec.id);
        insert testccl;
        
    }
    //Method to test
    static testMethod void CaseQAChecklistSelectorTest(){
        test.startTest();
        Case caseRec = [SELECT Id, AccountId FROM Case LIMIT 1];
        CaseQAChecklistSelector ccl = new CaseQAChecklistSelector();
        ccl.getSObjectType();
        ccl.getSObjectFieldList();
        ccl.selectById(new Set<Id>{caseRec.Id});
        test.stopTest();
    }
}