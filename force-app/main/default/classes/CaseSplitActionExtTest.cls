/**
* Test class for the Aura bundle CaseSplitAction
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-10-04
*
**/
@isTest
public class CaseSplitActionExtTest {
    
    @testSetup
    static void dataCreation(){
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Account account = new Account(Name = 'Test Account');
        
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1',
                                                          Case_Record_Type__c = 'New',
                                                          Subtype__c = 'Sample',
                                                          Type__c = 'T01');
        insert serviceType;
        
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Email',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Queue__c = 'Absa Client Services',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8',
                                                          Active__c = true, Skip_Split_Auto_Response__c = true);
        insert serviceGr;
        
        Service_Level__c serviceLevel = new Service_Level__c(Name = 'Test1', 
                                                             External_SLA_Time_Measure__c = 'Hour(s)',
                                                             External_SLA_Units__c = '8',
                                                             Default_Service_Level__c = true);
        insert serviceLevel;
        
        
        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = serviceType.Id,
                                                                        Service_Group__c = serviceGr.Id,
                                                                        Service_Level__c = serviceLevel.Id);
        insert serviceGrType;
        
        
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email', 
                                AccountId = account.Id,
                                Risk_Management_Centre__c = 'Digital Fraud',
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Subject = 'test',
                                Description = 'test',
                                Service_Group_Search__c = serviceGr.id,
                                sd_Service_Group_Id__c = serviceGr.Id,
                                Expectation_of_the_Customer__c = 'test',
                               	Incident_Date__c = date.today());
        insert caseRec;      
        
        Case caseRec2 = new Case(Communication_Method__c = 'Email',
                                 Status = 'New',
                                 Origin = 'Email', 
                                 AccountId = account.Id,
                                 Risk_Management_Centre__c = 'Digital Fraud',
                                 Email__c = 'test@test.com',
                                 recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                 Subject = 'test',
                                 Description = 'test',
                                 Service_Group_Search__c = serviceGr.id,
                                 sd_Service_Group_Id__c = serviceGr.Id,
                                 Expectation_of_the_Customer__c = 'test',
                               	Incident_Date__c = date.today());  
        
    }
    
    static testMethod void testSplitAction(){
        
        Case caseRec = [SELECT Id, AccountId, Service_Group_Search__c FROM Case LIMIT 1];
         Service_Group__c serviceGroupRec = [SELECT Id FROM Service_Group__c LIMIT 1];
        Case caseRec2 = new Case(Communication_Method__c = 'Email',
                                 Status = 'New',
                                 Origin = 'Email', 
                                 Risk_Management_Centre__c = 'Digital Fraud',
                                 Email__c = 'test@test.com',
                                 Subject = 'test',
                                 Description = 'test',
                                 Expectation_of_the_Customer__c = 'test',
                                 Incident_Date__c = date.today());
        
        list<Case> Cases =  new list<Case>();
        Cases.add(caseRec2);
        
        CaseSplitActionExt.splitCase( JSON.serialize(Cases), caseRec.id);
        
    }
    
}