/**  
* @Purpose      : Test Class for CaseTransferActionExt
* @Author       : Cloudsmiths		 
* @Created Date : 01/04/2019
*/
@isTest
public class CaseTransferTrackingsSelectorTest {
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
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today());
        insert caseRec;
        
        
        Case_Transfer_Tracking__c testCTT =  new Case_Transfer_Tracking__c(case__c = caseRec.id);
        insert testCTT;
    }
    
    
    //Method to test
    static testMethod void CaseTransferTrackingsSelectorTest(){
        test.startTest();
        Case caseRec = [SELECT Id, AccountId FROM Case LIMIT 1];
        CaseTransferTrackingsSelector con = new CaseTransferTrackingsSelector();
        con.getSObjectType();
        con.getSObjectFieldList();
        con.selectById(new Set<Id>{caseRec.Id});
        test.stopTest();
    }
}