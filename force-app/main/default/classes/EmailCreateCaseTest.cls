/**
* @description      	   : Test Class for EmailCreateCase
* @Author       	   : Dreamwares
* @Created Date 	   : 19/08/2018
* @Last modified Date : 11/12/2021
*/
@isTest
private class EmailCreateCaseTest {

    /*
* Purpose : Method to create test data
*/
    @testSetup
    static void dataCreation() {
        Account account = new Account(Name = 'Test Account');
        insert account;

        Case caseRec = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'Email',
            AccountId = account.Id,
            Email__c = 'wow@absa.com',
            Bypass_Validation_Rules__c = true,
            Risk_Management_Centre__c = 'Digital Fraud'
        );
        insert caseRec;
        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'someaddress@email.com');
        insert contact;
    }

    @isTest
    private static void testCreateRuleMatchingCase() {
        Case caseRec = [SELECT Id FROM Case LIMIT 1];

        //Create a new email
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Email rule';
        email.fromAddress = 'someaddress@email.com';
        email.htmlBody = '<b>hello world Test</b>';
        email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
            email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };

                Messaging.InboundEmail.BinaryAttachment attachment = new Messaging.InboundEmail.BinaryAttachment();
        attachment.body = blob.valueOf('my attachment text');
        attachment.fileName = 'Testfile.txt';
        attachment.mimeTypeSubType = 'text/plain';
        email.binaryAttachments = new List<Messaging.inboundEmail.BinaryAttachment>{ attachment };
            EmailCreateCase.createUnwantedEmailRecord(email, 75);
        Unwanted_Email__c unwantedEmail = [SELECT Id FROM Unwanted_Email__c LIMIT 1];

        System.assertNotEquals(null, unwantedEmail);

        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        EmailCreateCase.createEmailMessage(email, env, caseRec.Id, 'Case');
    }

    @isTest
    private static void testCreateRuleMatchingCase2() {
        Case caseRec = [SELECT Id FROM Case LIMIT 1];

        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');

        insert serviceType;

        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        system.assertNotEquals(null, businessHr);
        Service_Group__c serviceGr = new Service_Group__c(
            Name = 'Test',
            Assign_Record_Type__c = 'Complaint',
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '5',
            Queue__c = 'Email',
            Pause_Statuses__c = 'Awaiting Customer Feedback',
            Business_Hours__c = businessHr.Id,
            Email_Template_Case_Creation__c = 'Email template'
        );
        insert serviceGr;

        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = serviceGr.Id, Service_Type__c = serviceType.Id);
        insert serviceGrType;

        List<Service_Group__c> serviceGrList = [
            SELECT
            Id,
            Name,
            Queue__c,
            Pause_Statuses__c,
            Assign_Record_Type__c,
            Business_Hours__c,
            Email_Template_Case_Creation__c,
            Response_Email_Address__c,
            Internal_SLA_Time_Measure__c,
            Internal_SLA_Units__c,
            Internal_SLA_Notification_User__c
            FROM Service_Group__c
        ];

        Service_Level__c testServT = new Service_Level__c(
            Name = 'Test1',
            External_SLA_Time_Measure__c = 'Hour(s)',
            External_SLA_Units__c = '8',
            Default_Service_Level__c = true
        );
        insert testServT;

        //Create a new email
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Email rule';
        email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'hello world Test';
        email.messageId = '<JHHIUHIUHIUIUG657757657>';
        email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
            email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };

                String emailCaseId = EmailCreateCase.createRuleMatchingCase(
                    email,
                    serviceGrList,
                    new List<Service_Group_Type__c>{},
                    testServT.Id,
                    'Classify_Rule',
                    'abs@xyz.com',
                    false,
                    'Ombudsman',
                    '7812BE',
                    null,
                    ''
                );

        emailCaseId = EmailCreateCase.createRuleMatchingCase(
            email,
            serviceGrList,
            new List<Service_Group_Type__c>{ serviceGrType },
            testServT.Id,
            'Classify_Rule',
            'abs@xyz.com',
            false,
            'Ombudsman',
            '7812BE',
            null,
            ''
        );

        EmailCreateCase.prioritiseCaseToCopiedGroup(caseRec.Id, serviceGr.Id, new Set<String>());
        Messaging.InboundEmail email1 = new Messaging.InboundEmail();
        email1.subject = 'Test Email rule';
        email1.fromAddress = 'someaddress1@email.com';
        email1.htmlBody = '<b>hello world Test</b>';
        email1.messageId = '<JHHIUHIUHIUIUG657757657>';
        email1.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
        email1.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };
            emailCaseId = EmailCreateCase.createRuleMatchingCase(
            email1,
            serviceGrList,
            new List<Service_Group_Type__c>{ serviceGrType },
            testServT.Id,
            'Classify_Rule',
            'abs@xyz.com',
            false,
            'Ombudsman',
            '7812BE',
            null,
            ''
        );
    }

    @isTest
    private static void testEmailCreateCase1() {
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        system.assertNotEquals(null, caseRec);
        //Create a new email
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Email rule';
        email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'Test hello world';
        email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
            email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };

                Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        EmailCreateCase.createEmailMessage(email, env, caseRec.Id, 'Case');
    }

    @isTest
    private static void testEmailCreateCaseLargeEmail() {
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        system.assertNotEquals(null, caseRec);
        //Create a new email
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Email rule';
        email.fromAddress = 'someaddress@email.com';

        String plainText = 'Test hello world Test hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello world';
        for (Integer a = 0; a < 1000; a++) {
            plainText += 'Test hello world Test hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello worldTest hello world';
        }
        email.plainTextBody = plainText;
        //system.debug('BODY_LENGTH:' + email.plainTextBody.length());
        email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
            email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };

                Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();

        EmailCreateCase.createEmailMessage(email, env, caseRec.Id, 'Case');
        EmailCreateCase.createUnwantedEmailRecord(email, 1);
    }
    @isTest
    private static void testEmailCreateLeadEmail() {
        List<Lead> leadsList = TestDataFactory.getLeads('Business_Bank_Lead', 1);
        leadsList[0].Email = 'test@test.com';
        insert leadsList;
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        email.subject = 'Test Email rule';
        email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'Test hello world';
        email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
            email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };
        EmailCreateCase.createEmailMessage(email, env,leadsList[0].Id, 'Lead');
        System.assertEquals(leadsList != null, true);
    }

    @isTest
    private static void testCreateRuleMatchingCase3() {
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
        insert serviceType;

        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        system.assertNotEquals(null, businessHr);
        Service_Group__c serviceGr = new Service_Group__c(
            Name = 'DD STI Case',
            Assign_Record_Type__c = 'Complaint',
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '5',
            Queue__c = 'Email',
            Pause_Statuses__c = 'Awaiting Customer Feedback',
            Business_Hours__c = businessHr.Id,
            Email_Template_Case_Creation__c = 'Email template'
        );
        insert serviceGr;

        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = serviceGr.Id, Service_Type__c = serviceType.Id);
        insert serviceGrType;

        List<Service_Group__c> serviceGrList = [
            SELECT
            Id,
            Name,
            Queue__c,
            Pause_Statuses__c,
            Assign_Record_Type__c,
            Business_Hours__c,
            Email_Template_Case_Creation__c,
            Response_Email_Address__c,
            Internal_SLA_Time_Measure__c,
            Internal_SLA_Units__c,
            Internal_SLA_Notification_User__c
            FROM Service_Group__c
        ];

        Service_Level__c testServT = new Service_Level__c(
            Name = 'Test1',
            External_SLA_Time_Measure__c = 'Hour(s)',
            External_SLA_Units__c = '8',
            Default_Service_Level__c = true
        );
        insert testServT;

        //Create a new email
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Email rule';
        email.fromAddress = 'someaddresstt@email.com';
        email.plainTextBody = 'hello world Test';
        email.messageId = '<JHHIUHIUHIUIUG657757657>';
        email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
        email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };

                String emailCaseId = EmailCreateCase.createRuleMatchingCase(
                    email,
                    serviceGrList,
                    new List<Service_Group_Type__c>{},
                    testServT.Id,
                    'Classify_Rule',
                    'abs@xyz.com',
                    false,
                    'Ombudsman',
                    '7812BE',
                    null,
                    ''
                );


    }
    @isTest
    private static void testCreateRuleMatchingCase4() {
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
        insert serviceType;

        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];
        system.assertNotEquals(null, businessHr);
        Service_Group__c serviceGr = new Service_Group__c(
            Name = 'Absa Short Term Insurance',
            Assign_Record_Type__c = 'Complaint',
            Internal_SLA_Time_Measure__c = 'Hour(s)',
            Internal_SLA_Units__c = '5',
            Queue__c = 'Email',
            Pause_Statuses__c = 'Awaiting Customer Feedback',
            Business_Hours__c = businessHr.Id,
            Email_Template_Case_Creation__c = 'Email template'
        );
        insert serviceGr;

        Service_Group_Type__c serviceGrType = new Service_Group_Type__c(Service_Group__c = serviceGr.Id, Service_Type__c = serviceType.Id);
        insert serviceGrType;

        List<Service_Group__c> serviceGrList = [
            SELECT
            Id,
            Name,
            Queue__c,
            Pause_Statuses__c,
            Assign_Record_Type__c,
            Business_Hours__c,
            Email_Template_Case_Creation__c,
            Response_Email_Address__c,
            Internal_SLA_Time_Measure__c,
            Internal_SLA_Units__c,
            Internal_SLA_Notification_User__c
            FROM Service_Group__c
        ];

        Service_Level__c testServT = new Service_Level__c(
            Name = 'Test1',
            External_SLA_Time_Measure__c = 'Hour(s)',
            External_SLA_Units__c = '8',
            Default_Service_Level__c = true
        );
        insert testServT;

        //Create a new email
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = 'Test Email rule';
        email.fromAddress = 'someaddress@email.com';
        email.plainTextBody = 'hello world Test';
        email.htmlBody = '<b>hello world Test</b>';
        email.messageId = '<JHHIUHIUHIUIUG657757657>';
        email.toAddresses = new List<String>{ 'test@sample.com', 'Test@SalesForceTest.com' };
        email.ccAddresses = new List<String>{ 'test1@sample.com', 'Test1@SalesForceTest.com' };

                String emailCaseId = EmailCreateCase.createRuleMatchingCase(
                    email,
                    serviceGrList,
                    new List<Service_Group_Type__c>{},
                    testServT.Id,
                    'Classify_Rule',
                    'abs@xyz.com',
                    false,
                    'Ombudsman',
                    '7812BE',
                    null,
                    ''
                );
    }

}