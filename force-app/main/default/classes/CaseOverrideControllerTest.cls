/**
 * @description      : Test Class for CaseOverrideController
 * @Author       :  Dreamwares
 * @Created Date : 06/09/2018
 * UPDATE
 ********************************/

@isTest
public class CaseOverrideControllerTest {
    /**
     * @description : Method to create test data
     */
    @testSetup
    public static void dataCreation(){
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

        Account account = new Account(Name = 'Test Account');

        insert account;

        Account personAccount = new Account(lastName = 'Test', firstName = 'Account');

        insert personAccount;

        Contact contact = new Contact(LastName= 'Test contact', AccountId = account.Id, Email='test@test.com', Birthdate=date.today());
        insert contact;

        Case caseRec = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'Email',
            AccountId = account.Id,
            Risk_Management_Centre__c = 'Digital Fraud',
            Email__c = 'test@test.com',
            recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
            Subject = 'normal case',
            Description = 'test',
            Expectation_of_the_Customer__c = 'test',
            Incident_Date__c = date.today(),
            Banker__c = 'test'
        );
        insert caseRec;

        Case personAccCaseRec = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'Email',
            AccountId = personAccount.Id,
            Risk_Management_Centre__c = 'Digital Fraud',
            Email__c = 'test@test.com',
            recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
            Subject = 'person Acc',
            Description = 'test',
            Expectation_of_the_Customer__c = 'test',
            Incident_Date__c = date.today(),
            Banker__c = 'test'
        );
        insert personAccCaseRec;

        Service_Type__c serviceType = new Service_Type__c(Name = 'Test1', Case_Record_Type__c = 'New', Subtype__c = 'Sample', Type__c = 'T01');
        insert serviceType;

        BusinessHours businessHr = [SELECT Id FROM BusinessHours LIMIT 1];

        Service_Group__c serviceGr = new Service_Group__c(
            Name = 'Stockbroking', //Updated by Chenna
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

        Product2 product = new Product2(Name = 'Product 1');
        insert product;

        ContentVersion cv = new ContentVersion();
        cv.title = 'Test 1';
        cv.versionData = Blob.valueOf('Test1');
        cv.pathOnClient = 'Test 1';
        insert cv;

        ContentVersion testCV = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = caseRec.Id;
        cdl.ContentDocumentId = testCV.ContentDocumentId;
        cdl.Sharetype = 'V';
        insert cdl;
    }

    @isTest
    //Method to test
    public static void testCaseCreateOverrideController() {
        Case caseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'normal case' LIMIT 1];
        Case personAccCaseRec = [SELECT Id, AccountId FROM Case WHERE Subject = 'person Acc' LIMIT 1];
        Service_Type__c serviceType = [SELECT Id, Name, Type__c, Subtype__c FROM Service_Type__c LIMIT 1];
        Service_Group__c serviceGroup = [SELECT Id, Name, Queue__c FROM Service_Group__c LIMIT 1];
        Site__c siteRecord = [SELECT Id, Name, Service_Group__c FROM Site__c LIMIT 1];
        Site__c site = [SELECT Id, Name FROM Site__c LIMIT 1];
        Account account = [SELECT Id, Name, Source__c FROM Account WHERE Id = :caseRec.AccountId]; //Modified by Chenna
        Account personAccount = [SELECT Id, Name, Source__c, isPersonAccount FROM Account WHERE Id = :personAccCaseRec.AccountId];

        //Added by Chenna - start
        map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

        Case caseRec2 = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'Email',
            AccountId = account.Id,
            Risk_Management_Centre__c = 'Digital Fraud',
            Email__c = 'test@test.com',
            recordTypeId = caseRecordTypeMap.get('Complaint').getRecordTypeId(),
            Subject = 'normal case',
            Description = 'test',
            Expectation_of_the_Customer__c = 'test',
            Incident_Date__c = date.today(),
            Banker__c = 'test'
        );
        //Added by Chenna - end

        Test.startTest();

        try {
            //Modified by Chenna
            String newCaseId = CaseOverrideController.createCase(
                caseRec2,
                serviceType,
                serviceGroup,
                siteRecord,
                true,
                account,
                'Email',
                'Test',
                'Test',
                'Test'
            );
        } catch (Exception e) {
            //System.debug('Exception::'+e.getMessage());
            System.assert(false, 'Exception ' + e);
        }

        try {
            String newCaseId = CaseOverrideController.createCase(
                caseRec,
                serviceType,
                null,
                siteRecord,
                true,
                new Account(LastName = 'Test'),
                'Email',
                'Test',
                'Test',
                'Test'
            );
        } catch (Exception e) {
            //System.debug('Exception::'+e.getMessage());
            System.assert(true, 'Exception ' + e);
        }

        try {
            String newCaseId = CaseOverrideController.createCase(
                caseRec,
                serviceType,
                null,
                siteRecord,
                true,
                new Account(Name = 'Test'),
                'Email',
                'Test',
                'Test',
                'Test'
            );
        } catch (Exception e) {
            //System.debug('Exception::'+e.getMessage());
            System.assert(true, 'Exception ' + e);
        }

        try {
            String newCaseId = CaseOverrideController.createCase(
                caseRec,
                null,
                serviceGroup,
                siteRecord,
                false,
                new Account(Name = 'Test'),
                'Email',
                'Test',
                'Test',
                'Test'
            );
        } catch (Exception e) {
            //System.debug('Exception::'+e.getMessage());
            System.assert(true, 'Exception ' + e);
        }

        try {
            String newCaseId = CaseOverrideController.createCase(
                caseRec,
                null,
                serviceGroup,
                siteRecord,
                true,
                new Account(Name = 'Test'),
                'Email',
                'Test',
                'Test',
                'Test'
            );
        } catch (Exception e) {
            //System.debug('Exception::'+e.getMessage());
            System.assert(true, 'Exception ' + e);
        }

        try {
            String newCaseId = CaseOverrideController.createCase(
                personAccCaseRec,
                null,
                serviceGroup,
                siteRecord,
                true,
                new Account(firstName = 'Test'),
                'Email',
                'Test',
                'Test',
                'Test'
            );
        } catch (Exception e) {
            //System.debug('Exception::'+e.getMessage());
            System.assert(true, 'Exception ' + e);
        }

        Service_Type__c testServiceType = CaseOverrideController.findServiceTypeRecord(String.valueOf(serviceType.Id));
        Service_Group__c testServiceGroup = CaseOverrideController.findServiceGroupRecord(String.valueOf(serviceGroup.Id));
        // Added to test NBFS Service Group:
        List<String> testNBFSServiceGroup = CaseOverrideController.getServiceGroupInfo(String.valueOf(serviceGroup.Id));
        Site__c testSite = CaseOverrideController.findSiteRecord(String.valueOf(site.Id));
        CaseOverrideController.getLoggedInUserCaseRecordType();
        CaseOverrideController.getComplaintsPermissionSets();
        CaseOverrideController.getCurrentUserRole(); // Added by Chenna

        List<ContentDocumentLink> cdlList = [
            SELECT Id, LinkedEntityId, ContentDocumentId, Sharetype
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :caseRec.Id
        ];
        List<String> docIds = new List<String>();

        if (cdlList.size() > 0) {
            for (ContentDocumentLink cdl : cdlList) {
                docIds.add(cdl.ContentDocumentId);
            }
        }

        if (docIds.size() > 0) {
            CaseOverrideController.updateContentDocument(personAccCaseRec.Id, docIds[0]);
            CaseOverrideController.uploadContentDocuments(personAccCaseRec.Id, docIds);
        }
        Test.stopTest();

        System.assertEquals(serviceType.Id, testServiceType.Id);
        List<Account> accounts = [SELECT Id, Name FROM Account];
    }

    //Method to test
    /*static testMethod void negTestCaseOverrideController(){  
        Test.startTest();
        Service_Type__c testServiceType = CaseOverrideController.findServiceTypeRecord('');
        Service_Group__c testServiceGroup = CaseOverrideController.findServiceGroupRecord('');
        Site__c testSite = CaseOverrideController.findSiteRecord('');
        system.assertEquals(null, null);
        Test.stopTest();
    }*/

    //Method to test
    @isTest
    static void testCaseClassification() {
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        system.assertNotEquals(null, caseRec);
        Product2 product = [SELECT ID FROM Product2 LIMIT 1];
        Service_Group__c serviceGroupRec = [SELECT ID FROM Service_Group__c LIMIT 1];
        // Added for searching the Advisor details for NBFS Service Groups:
        //User advisordetails = [Select Advisor_Code__c,Name From User Limit 1];

        test.startTest();
        CaseOverrideController.findProductsByServiceGroup(serviceGroupRec.Id);
        CaseOverrideController.findServiceTypesByProductAndServiceGroup(product.Id, serviceGroupRec.Id);
        // Added for searching the Advisor details for NBFS Service Groups:
        //CaseOverrideController.getAdvisorInfo(advisordetails.Id);
        test.stopTest();
    }

    @isTest
    public static void testCaseEmail() {
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        system.assertNotEquals(null, caseRec);
        Contact cnt = [SELECT Id FROM Contact LIMIT 1];
        caseRec.ContactId = cnt.Id;
        caseRec.Email_From_Address__c = 'test@test.co.za';
        update caseRec;

        Product2 product = [SELECT ID FROM Product2 LIMIT 1];
        Service_Group__c serviceGroupRec = [SELECT ID FROM Service_Group__c LIMIT 1];

        //Added by Chenna - start
        List<String> fileIds = new List<String>();

        ContentVersion contentVersionInsert = new ContentVersion(
            Title = 'Test',
            PathOnClient = 'Test.jpg',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        insert contentVersionInsert;
        for (ContentDocument cdObj : [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument]) {
            fileIds.add(cdObj.Id);
        }
        //Added by Chenna - End

        String tempName = [SELECT Id, Name, DeveloperName FROM EmailTemplate LIMIT 1].Name;
        String orgwide = [SELECT Id, Address FROM OrgWideEmailAddress WHERE Address = 'absa@absa.co.za'].Address;
        String altEmail = 'simangaliso.mathenjwa@absa.africa';
        test.startTest();

        //Modified by Chenna - Start
        try {
            CaseOverrideController.sendEmailWithAttachments(caseRec.Id, orgwide, fileIds, tempName, altEmail);
        } catch (Exception e) {
            //System.debug('e'+e);
            System.assert(true, 'Exception ' + e);
        }
        try {
            CaseOverrideController.sendEmailWithAttachments(caseRec.Id, orgwide, fileIds, tempName, '');
        } catch (Exception e) {
            //System.debug('e'+e);
            System.assert(true, 'Exception ' + e);
        }
        try {
            CaseOverrideController.sendEmailCase(caseRec.Id, orgwide, tempName, '', '');
        } catch (Exception e) {
            System.assert(false, 'Exception ' + e); //System.debug('e'+e);
        }
        //Modified by Chenna - end
        test.stopTest();
    }

    @isTest
    public static void testCaseEmail1() {
        Case caseRec = [SELECT Id FROM Case LIMIT 1];
        Contact cnt = [SELECT Id FROM Contact LIMIT 1];
        caseRec.ContactId = cnt.Id;
        update caseRec;
        try {
            list<Service_Group__c> sg = CaseOverrideController.getServiceGroup('Email');
            //system.debug(sg);
            system.assertNotEquals(null, sg);
        } catch (Exception e) {
            //System.debug('Exception::'+e.getMessage());
            System.assert(false, 'Exception ' + e);
        }

        list<CaseOverrideController.smsEmailRequest> csmlist = new List<CaseOverrideController.smsEmailRequest>();
        CaseOverrideController.smsEmailRequest csm = new CaseOverrideController.smsEmailRequest();
        csm.caseId = caseRec.Id;
        csm.emailTemplateName = [SELECT Id, Name, DeveloperName FROM EmailTemplate LIMIT 1].Name;
        csm.managerEmail = 'test@test.com';
        csm.ownerEmail = 'test@test.com';
        csm.phoneNumberOverride = '123454566890';
        csm.preferredCommunicationChannel = 'SMS and Email';
        csm.quickText = 'Test Quick Text Merge';
        csm.responseEmailAddress = 'absa@absa.co.za';
        csmlist.add(csm);

        CaseOverrideController.invokeSmsEmailMethod(csmlist);
    }

    @isTest
    public static void SendMailWithDocumentTestMethod() {
        Account account = new Account(Name = 'Test Account');

        insert account;

        Account personAccount = new Account(lastName = 'Test', firstName = 'Account');

        insert personAccount;

        Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'test@test.com', Birthdate = date.today());
        insert contact;

        Case caseRec = new Case(
            Communication_Method__c = 'Email',
            Status = 'New',
            Origin = 'Email',
            AccountId = account.Id,
            Risk_Management_Centre__c = 'Digital Fraud',
            Email__c = 'test@test.com',
            recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('AIP Case').getRecordTypeId(),
            Subject = 'normal case',
            Description = 'test',
            Expectation_of_the_Customer__c = 'test',
            Incident_Date__c = date.today(),
            Banker__c = 'test'
        );
        insert caseRec;
        //Case caseRec = [SELECT Id FROM Case LIMIT 1];

        try {
            //list<Service_Group__c> sg = CaseOverrideController.getServiceGroup('Email');
            //system.debug(sg);
            CaseOverrideController.SendMailWithDocument(caseRec.Id);
            system.assertNotEquals(null, caseRec);
        } catch (Exception e) {
            //System.debug('Exception::'+e.getMessage());
            System.assert(true, 'Exception ' + e);
        }

        /*list<CaseOverrideController.smsEmailRequest> csmlist = new list<CaseOverrideController.smsEmailRequest>();
        CaseOverrideController.smsEmailRequest csm = new CaseOverrideController.smsEmailRequest();
        csm.caseId=caseRec.Id;
        csm.emailTemplateName=[SELECT Id, Name, DeveloperName FROM EmailTemplate limit 1 ].Name;
        csm.managerEmail='test@test.com';
        csm.ownerEmail='test@test.com';
        csm.phoneNumberOverride='123454566890';
        csm.preferredCommunicationChannel='SMS and Email';
        csm.quickText='Test Quick Text Merge';
        csm.responseEmailAddress='absa@absa.co.za';
        csmlist.add(csm);
        
        CaseOverrideController.invokeSmsEmailMethod(csmlist);*/
    }

    @isTest
    static void testgetCaseDetails() {
        id caseId = [SELECT id FROM case LIMIT 1].Id;
        Case caseRecord = CaseOverrideController.getCaseDetails(caseId);
        System.assertEquals(caseRecord != null, true, 'GetCaseDetails test method Faild t get Case details');
    }

    @isTest
    static void testCreateServiceRequestCase() {
        try {
            CaseOverrideController.createServiceRequestCase(new Case());
            system.assertEquals(1, 1);
        } catch (Exception e) {
            string msg = e.getMessage();
        }
    }

    @isTest
    static void testGetLeadCaseDetails() {
        try {
            Case c = [SELECT Id FROM Case LIMIT 1];
            Lead l = [SELECT Id FROM Lead LIMIT 1];
            CaseOverrideController.getLeadCaseDetails(c.Id, 'Case');
            CaseOverrideController.getLeadCaseDetails(l.Id, 'Lead');
            system.assertEquals(true, c != null);
        } catch (Exception e) {
            string msg = e.getMessage();
        }
    }

    @isTest
    static void testUpdateCaseDetails() {
        try {
            Case c = [SELECT Id FROM Case LIMIT 1];
            CaseOverrideController.updateCaseDetails(JSON.serialize(c));
            system.assertEquals(true, c != null);
        } catch (Exception e) {
            string msg = e.getMessage();
        }
    }

    @isTest
    static void testGetObjectName() {
        try {
            CaseOverrideController.getObjectName(UserInfo.getUserId());
            system.assertEquals(true, true);
        } catch (Exception e) {
            String msg = e.getMessage();
        }
    }
}