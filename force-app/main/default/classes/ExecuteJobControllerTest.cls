@isTest
public class ExecuteJobControllerTest {
    @testSetup
    static void dataCreation() {
        Account account = new Account(Name = 'Test Account');
        insert account;

        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
        insert contact;
    }

    @IsTest
    public static void testCaseDetails() {
        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
        insert serviceType;

        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        EmailTemplate eTemplate = [SELECT Id, Name FROM EmailTemplate LIMIT 1];

        Service_Group__c serviceGr = new Service_Group__c(
            Name = 'Test1',
            Assign_Record_Type__c = 'Email',
            Response_Email_Address__c = 'evg@t.com',
            Queue__c = 'Email',
            Business_Hours__c = businessHr.Id,
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '8'
        );
        insert serviceGr;

        Service_Level__c serviceLevel = new Service_Level__c(
            Name = 'Test1',
            External_SLA_Time_Measure__c = 'Hour(s)',
            External_SLA_Units__c = '8',
            Default_Service_Level__c = true
        );
        insert serviceLevel;

        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(
            Service_Type__c = serviceType.Id,
            Service_Group__c = serviceGr.Id,
            Service_Level__c = serviceLevel.Id
        );
        insert serviceGrType;

        Site__c site = new Site__c(Name = 'Test', Service_Group__c = serviceGr.Id);

        insert site;

        Account account = [SELECT Id FROM Account LIMIT 1];

        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();

        Case caseRec = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'Email',
            AccountId = account.Id,
            Risk_Management_Centre__c = 'Digital Fraud',
            Email_From_Address__c = 'test@ret.com',
            Email__c = 'test@ret.com',
            Incident_Date__c = System.Today(),
            RecordTypeId = caseRecordTypeId,
            Approval_Status__c = 'Approved',
            SLA_Extension_Approval__c = 'Approved',
            Expectation_of_the_Customer__c = 'Testing',
            Awaiting_Status__c = 'Awaiting Customer Documents',
            SLA_Extension_Reason__c = 'This is for testing',
            SLA_Extension_Approval_Required__c = true,
            Deadlock_Reason_Motivation__c = 'Sample test',
            Subject = 'Test',
            Description = 'Test',
            Deadlock_Approval_Required__c = true,
            sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback',
            Type__c = 'Test',
            sd_Email_Template_Case_Classification__c = eTemplate.Name
        );
        insert caseRec;

        /*Case_Transfer_Tracking__c caseTransferTrack = new Case_Transfer_Tracking__c(Case__c = caseRec.Id,
In__c = Date.today().addDays(-5) );
insert caseTransferTrack; */
        caseRec.Type__c = 'Customer';
        caseRec.Status = 'In Progress';
        caseRec.Approval_Status__c = 'Rejected';
        caseRec.Awaiting_Status__c = 'Awaiting Customer Feedback';
        caseRec.sd_Service_Group_Type_Id__c = serviceGrType.Id;
        caseRec.sd_Service_Group_Id__c = serviceGr.Id;
        update caseRec;
        Test.startTest();

        ExecuteJobController.CaseDetails(caseRec.id);

        Test.stopTest();
    }

    @isTest
    public static void testCaseClassification() {
        Service_Type__c serviceType = new Service_Type__c(
            Name = 'TestType',
            Case_Record_Type__c = 'Service Request',
            Subtype__c = 'SubtypeTest',
            Type__c = 'TestType'
        );
        insert serviceType;

        Service_Group__c serviceGr = new Service_Group__c(
            Name = 'TestGroup',
            Assign_Record_Type__c = 'Service Request',
            Response_Email_Address__c = 'testclass@test.com',
            Queue__c = 'Email',
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '8'
        );
        insert serviceGr;
        List<String> serviceGroupList = new List<String>();
        serviceGroupList.add(serviceGr.Name);

        Service_Level__c serviceLevel = new Service_Level__c(
            Name = 'TestServiceLevel',
            External_SLA_Time_Measure__c = 'Hour(s)',
            External_SLA_Units__c = '8',
            Default_Service_Level__c = true
        );
        insert serviceLevel;

        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(
            Service_Type__c = serviceType.Id,
            Service_Group__c = serviceGr.Id,
            Service_Level__c = serviceLevel.Id,
            Auto_Case_Creation__c = true
        );
        insert serviceGrType;

        Site__c site = new Site__c(Name = 'SiteTest', Service_Group__c = serviceGr.Id);

        insert site;

        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Complaint').getRecordTypeId();

        Case caseRec = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'Email',
            Risk_Management_Centre__c = 'Digital Fraud',
            Email_From_Address__c = 'test@ret.com',
            Email__c = 'test@ret.com',
            Incident_Date__c = System.Today(),
            RecordTypeId = caseRecordTypeId,
            Approval_Status__c = 'Approved',
            SLA_Extension_Approval__c = 'Approved',
            Expectation_of_the_Customer__c = 'Testing',
            Awaiting_Status__c = 'Awaiting Customer Documents',
            SLA_Extension_Reason__c = 'This is for testing',
            SLA_Extension_Approval_Required__c = true,
            Deadlock_Reason_Motivation__c = 'Sample test',
            Subject = 'Test',
            Description = 'Test',
            Deadlock_Approval_Required__c = true,
            sd_Pause_Statuses__c = 'Awaiting Customer Documents, Awaiting Customer Feedback',
            Type__c = serviceGrType.Service_Type__r.Name
        );
        insert caseRec;

        Test.startTest();

        List<Service_Group_Type__c> serviceGrTypeInfo = new ServiceGroupTypesSelector()
            .getServiceTypeWithServiceGroupAndServiceLimitInfo(serviceGrType.Auto_Case_Creation__c, serviceType.Name, serviceGroupList);
        if (serviceGrTypeInfo.size() > 0) {
            ExecuteJobController.classifyCase(caseRec.id, serviceGrTypeInfo[0]);
        }

        Case updatedCase = [SELECT Type__c FROM Case WHERE Id = :caseRec.Id];

        System.assertEquals('TestType', updatedCase.Type__c);

        Test.stopTest();
    }
}