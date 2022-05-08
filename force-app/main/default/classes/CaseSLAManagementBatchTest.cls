/**
* Test class for LeadAllocationStagingPurgeBatch
* @author  Koketso Mpshane
* @date    21/08/2020
*/
@isTest
public class CaseSLAManagementBatchTest {
    
    /*
* Purpose : Method to create test data
*/
    @testSetup
    static void dataCreation(){
        
        Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Case cs = new Case();
        cs.RecordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId();
        cs.Status = 'New';
        cs.Origin = 'Email';
        cs.Account = account;
        cs.Subject = 'test';
        cs.Description = 'test';
        cs.External_SLA_End_Date__c = system.now().addDays(-2);
        cs.SLA_Extended__c = false;     
        cs.BusinessHoursId = businessHr.Id;
        cs.Bypass_Validation_Rules__c = true;
        insert cs;
        
    }
    
    //Method to test
    static testMethod void testLeadAllocationStagingPurgeBatch(){
        
        Test.startTest();
        
        CaseSLAManagementSchedule instance = new CaseSLAManagementSchedule();
        
        String cronExp = '0 0 23 * * ?'; 
        system.schedule('Test CaseSLAManagementSchedule', cronExp, instance); 
        
        Test.stopTest();
    }
    
}