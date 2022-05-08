@isTest
public class CaseMilestoneCtrlTest {
    @isTest static void createTestCase()
    {
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email',
                                Account = account,
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
                                Subject = 'test',
                                Type__c = 'Dispute Debit Order',
                                Description = 'test',
                                Internal_SLA_End_Date__c = date.today()+2,
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today());
        insert caseRec;
        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1',
                                                          Case_Record_Type__c = 'New',
                                                          Subtype__c = 'Sample',
                                                          Type__c = 'T01',
                                                          Product__c = 'aProduct');
        insert serviceType;
        
        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        
        Service_Group__c serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Email',
                                                          Response_Email_Address__c = 'evg@t.com',
                                                          Business_Hours__c = businessHr.Id,
                                                          Internal_SLA_Time_Measure__c = 'Hour(s)',
                                                          Internal_SLA_Units__c = '8');
        insert serviceGr;
        
        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Type__c = serviceType.Id,
                                                                        Service_Group__c = serviceGr.Id);
        insert serviceGrType;
        
        serviceType = new Service_Type__c(Name = 'Test2',
                                          Case_Record_Type__c = 'New',
                                          Subtype__c = 'Query',
                                          Type__c = 'Test',
                                          Product__c = 'aProduct');
        insert serviceType;
        
        serviceGr = new Service_Group__c(Name = 'Test1', Assign_Record_Type__c = 'Enquiry',
                                         Response_Email_Address__c = 'test@t.com',
                                         Business_Hours__c = businessHr.Id,
                                         Internal_SLA_Time_Measure__c = 'Day(s)',
                                         Internal_SLA_Units__c = '6');
        insert serviceGr;
        
        serviceGrType = new Service_Group_Type__c(
            Service_Type__c = serviceType.Id,
            Service_Group__c = serviceGr.Id);
        insert serviceGrType;
        
        serviceType = new Service_Type__c(Name = 'Test3',
                                          Case_Record_Type__c = 'New',
                                          Subtype__c = 'Request',
                                          Type__c = 'Test',
                                          Product__c = 'aProduct');
        insert serviceType;
        
        serviceGr = new Service_Group__c(Name = 'Test2', Assign_Record_Type__c = 'Service Request',
                                         Response_Email_Address__c = 'check@tp.com',
                                         Business_Hours__c = businessHr.Id,
                                         Internal_SLA_Time_Measure__c = 'Week(s)',
                                         Internal_SLA_Units__c = '5');
        insert serviceGr;
        
        serviceGrType = new Service_Group_Type__c(
            Service_Type__c = serviceType.Id,
            Service_Group__c = serviceGr.Id);
        insert serviceGrType;
        
        test.startTest();
        CaseMilestoneCtrl.fetchCaseSLADate(caseRec.Id);
        System.assertEquals(System.today() + 2,caseRec.Internal_SLA_End_Date__c);
        test.stopTest();
    }
    @isTest static void createNegativeTestCase()
    {
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
        
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        Contact contact = new Contact(LastName='Test contact', AccountId = account.Id);
        insert contact;
        Case caseRec = new Case(Communication_Method__c = 'Email',
                                Status = 'New',
                                Origin = 'Email',
                                Account = account,
                                Email__c = 'test@test.com',
                                recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
                                Type__c = 'Password Reset',
                                Subject = 'test',
                                Description = 'test',
                                Internal_SLA_End_Date__c = date.today()+2,
                                Expectation_of_the_Customer__c = 'test',
                                Incident_Date__c = date.today());
        insert caseRec;
        test.startTest();
        CaseMilestoneCtrl.fetchCaseSLADate(caseRec.Id);
        System.assertEquals(System.today() + 2,caseRec.Internal_SLA_End_Date__c);
        test.stopTest();
    }

}