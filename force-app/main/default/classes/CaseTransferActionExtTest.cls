/**  
 * @Purpose      : Test Class for CaseTransferActionExt
 * @Author       : Dreamwares 
 * @Created Date : 06/09/2018
 */
@isTest
public class CaseTransferActionExtTest {
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
                               	Incident_Date__c = date.today(),
                                SLA_Extension_Approval__c = 'Pending');
        insert caseRec;
        
        Service_Group__c serviceGroupRecord = new Service_Group__c(Name='SG',Queue__c='Queue',Active__c=true, Assign_Record_Type__c = 'Complaint');
        insert serviceGroupRecord;
        Service_Level__c sl = new Service_level__c(Name='SL', Default_Service_Level__c = true, External_SLA_Time_Measure__c = 'Day(s)', External_SLA_Units__c = '5');
        insert sl;
        Service_Type__c st = new Service_Type__c(Name='Type Subtype', Type__c='Type', Subtype__c='Subtype');
        insert st;
        Service_Group_Type__c sgt = new Service_Group_Type__c(Service_Group__c=serviceGroupRecord.Id, Service_Level__c=sl.id, Service_Type__c=st.Id);
        insert sgt;
        
    }
    
    //Method to test
    static testMethod void testCaseTransferActionExt(){
    	Case caseRec = [SELECT Id, Transfer_Reason__c FROM Case LIMIT 1];
        caseRec.BusinessHoursId = [Select Id From BusinessHours Where isActive = true Limit 1].Id;
        update caseRec;
        
        Service_Group__c serviceGroupRec = [SELECT Id, Queue__c FROM Service_Group__c LIMIT 1];
        Test.startTest();
        
        //Update Case
        Service_Group__c serviceGroupRecord = [Select Id, Name, Queue__c, Assign_Record_Type__c From Service_Group__c Where Active__c = true limit 1];
        CaseTransferActionExt.transferCase(String.valueOf(caseRec.Id), 'Debt Review Manager', 'Outside my Mandate', 'Successful', serviceGroupRecord);
        Case testCase = [SELECT Id, Transfer_Reason__c FROM Case WHERE Id =: caseRec.Id];
        Service_Group__c testServiceGroup = CaseTransferActionExt.findServiceGroupRecord(serviceGroupRec.id);
        
        CaseTransferActionExt.getCaseCloseStatus(caseRec.Id);
        Test.stopTest();
    }
    
    //Method to test
    static testMethod void negTestCaseTransferActionExt(){
    	Case caseRec = [SELECT Id, Transfer_Reason__c FROM Case LIMIT 1];
        caseRec.BusinessHoursId = [Select Id From BusinessHours Where isActive = true Limit 1].Id;
        update caseRec;
        Service_Group__c serviceGroupRecord = [Select Id, Name, Queue__c, Assign_Record_Type__c From Service_Group__c Where Active__c = true limit 1];
        Test.startTest();
        CaseTransferActionExt.transferCase(String.valueOf(caseRec.Id), 'Debt Review Manager', 'Test', 'Successful', serviceGroupRecord);
        Test.stopTest();
    }
    
    static testMethod void testCaseTransferByEmailAction(){
    	Case caseRec = [SELECT Id, BusinessHoursId, Transfer_Reason__c FROM Case LIMIT 1];
        caseRec.BusinessHoursId = [Select Id From BusinessHours Where isActive = true Limit 1].Id;
        update caseRec;
        
        Service_Group__c serviceGroupRec = [SELECT Id, Queue__c FROM Service_Group__c LIMIT 1];
        Test.startTest();
        //Update Case
        Service_Group__c serviceGroupRecord = [Select Id, Name, Queue__c, Assign_Record_Type__c From Service_Group__c Where Active__c = true limit 1];
        CaseTransferActionExt.transferCase(String.valueOf(caseRec.Id), 'EmailTransfer', 'Outside my Mandate', 'Successful', serviceGroupRecord);
        Case testCase = [SELECT Id, Transfer_Reason__c FROM Case WHERE Id =: caseRec.Id];
        Service_Group__c testServiceGroup = CaseTransferActionExt.findServiceGroupRecord(serviceGroupRec.id);
        
        CaseTransferActionExt.getCaseCloseStatus(caseRec.Id);
        Test.stopTest();
    }
    
  	// JQUEV W-007101 2020/10/29
    static testMethod void testCaseTransferByServiceGroupAndTypeNames(){
        Case caseRec = [SELECT Id, Transfer_Reason__c FROM Case LIMIT 1];
        caseRec.BusinessHoursId = [Select Id From BusinessHours Where isActive = true Limit 1].Id;
        update caseRec;

        Service_Group__c serviceGroupRec = [SELECT Id, Name FROM Service_Group__c LIMIT 1];
        Service_Type__c serviceTypeRec = [SELECT Id, Name FROM Service_Type__c LIMIT 1];

        Test.startTest();
        CaseTransferActionExt.transferCase(serviceGroupRec.Name, serviceTypeRec.Name, caseRec.Id);
        Test.stopTest();

        Case caseAfter = [SELECT Id, sd_Service_Group__c FROM Case LIMIT 1];
        System.assertEquals(caseAfter.sd_Service_Group__c, serviceGroupRec.Name);
    }
    
    // JQUEV W-007101 2020/10/29
    static testMethod void testFindServiceGroupRecordNegative(){
        Test.startTest();
        Service_Group__c testServiceGroup = CaseTransferActionExt.findServiceGroupRecord(null);
        System.assertEquals(null, testServiceGroup);
        Test.stopTest();
    }

    // JQUEV W-007101 2020/10/29
    static testMethod void testGetCaseCloseStatusNegative(){
        Test.startTest();
        Boolean closeStatus = CaseTransferActionExt.getCaseCloseStatus(null);
        System.assertEquals(false, closeStatus);
        Test.stopTest();
    }
}