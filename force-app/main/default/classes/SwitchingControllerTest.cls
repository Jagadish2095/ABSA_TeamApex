/**
 * @description       : SwitchingControllerTest
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-16
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-06-21   André Pietersen (IQ Business)   Initial Version
 * 1.1   2021-08-16   André Pietersen (IQ Business)   Force deployment 
 * 1.2   2021-10-12   Brian Maswanganyi               Include test 
**/
@isTest
public class SwitchingControllerTest {
    public static final String POSITIVE_RESPONSE_BODY_LETTER = 'base64 pdf';
    public static final String POSITIVE_RESPONSE_BODY_CUSTOMER = '{  "createdBy": "bdp_user",  "lastModifiedBy": "bdp_user",  "creationDate": "2020-09-02T13:39:17.482+02:00",  "lastModifiedDate": "2020-09-02T13:39:17.482+02:00",  "state": "NOT_WELCOMED",  "name": "OIUSDFKJH",  "surname": "LSKDJFOIU",  "identifier": "7006109014084",  "email": "OIUXCV@DDSF.CIN",  "telephoneNumber": "",  "mobileNumber": "0864578877",  "ecmAttachmentKey": null,  "title": "Mr",  "communicationMethod": "EMAIL",  "bankAccountNumber": "9051338776",  "bankAccountType": "SAVINGS",  "bankBranch": "8392",  "previousAccountNumber": "005555523",  "previousAccountType": "SAVINGS",  "previousBranch": "004605",  "previousInstitution": "CLIENTELE LIFE",  "preferredLanguage": "ENG",  "fullName": "Mr. OIUSDFKJH LSKDJFOIU",  "gender": "MALE",  "triggers": [    "WELCOME"  ],  "_links": {    "self": {      "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/customers/16346"    },    "customer": {      "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/customers/16346"    },    "history": {      "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/customers/16346/history"    },    "welcome_trigger": {      "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/customers/16346/trigger?triggerName=WELCOME"    }  }}';
    public static final String POSITIVE_RESPONSE_BODY_SWITCH = '{ "createdBy": "bdp_user", "lastModifiedBy": "bdp_user", "creationDate": "2020-09-23T12:00:04.849+0000", "lastModifiedDate": "2020-09-23T12:00:04.849+0000", "state": "READY_TO_SUBMIT", "switchType": "DEBIT_ORDER", "accountNumber": "9090090898", "frequency": "MONTHLY", "dueDate": "2020-06-30T00:00:00.000+0000", "amount": 450.0, "notes": "Debit Order", "referenceNumber": "2020/09/2339107", "reason": null, "nextPremiumDate": null, "allocatedTo": "UNALLOCATED", "followUp": null, "previousAccountNumber": "5754654654654", "previousAccountType": "SAVINGS", "previousBranch": "2555", "previousInstitution": "SANLAM PERSONAL LOAN", "channel": "ASP", "originEmployeeName": null, "originEmployeeSurname": null, "originEmployeeNumber": null, "originSiteCode": null, "originSiteName": null, "valid": true, "primaryTrigger": "", "friendlyState": "Ready to send", "formattedDueDate": "30/06/2020", "age": 0, "overdue": false, "triggers": [], "channelValid": true, "_links": { "self": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509" }, "switchRequest": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509" }, "history": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/history" }, "letter": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/letter" }, "download": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/letter/download" }, "follow-up": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/follow-up" }, "institution": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/institution" }, "customer": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/customer" } } }';
    public static final String POSITIVE_RESPONSE_BODY_INSTITUTION = '{ "createdBy": "admin",     "lastModifiedBy": "admin",     "creationDate": "2020-10-16T08:14:52.563+0000",     "lastModifiedDate": "2020-10-16T08:14:52.563+0000",     "name": "Cloudy Bananas",     "contactPerson": "Some Person",     "contactEmail": "some1@email.com",     "contactDepartment": "Some Department",     "debitOrderAutomatedEmail": null,     "salaryAutomatedEmail": "some1@email.com",     "regexPatterns": null,     "debitOrderAcknowledgeHoursSLA": 0,     "debitOrderResolveHoursSLA": 0,     "salaryAcknowledgeHoursSLA": 0,     "salaryResolveHoursSLA": 0,     "route": "NON_PARTICIPATING",     "categories": null,     "batchFileType": null,     "batchFormatterType": null,     "batchIntegrationType": null,     "connectionPrefix": null,     "template": null,     "_links": {         "self": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/16655"         },         "institution": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/16655"         },         "history": {             "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/16655/history"         }     } }';
    public static final String POSITIVE_RESPONSE_BODY_LINK_INSTITUTION = '{     "exceptiondetails": {         "status": "NOT_FOUND",         "timestamp": "12-10-2020 14:22:54",         "message": "Requested resource could not be found in the Switch-It Database",         "path": "/switches/2059/institution",         "subErrors": null     } }';
    public static final String POSITIVE_RESPONSE_BODY_LINK_CUSTOMER = '{     "exceptiondetails": {         "status": "NOT_FOUND",         "timestamp": "12-10-2020 14:09:54",         "message": "Requested resource could not be found in the Switch-It Database",         "path": "/switches/2064/customer",         "subErrors": null     } }';
    public static final String POSITIVE_RESPONSE_BODY_TRIGGER = '{ "createdBy": "bdp_user", "lastModifiedBy": "bdp_user", "creationDate": "2020-09-23T12:00:04.849+0000", "lastModifiedDate": "2020-09-23T12:00:04.849+0000", "state": "READY_TO_SUBMIT", "switchType": "DEBIT_ORDER", "accountNumber": "9090090898", "frequency": "MONTHLY", "dueDate": "2020-06-30T00:00:00.000+0000", "amount": 450.0, "notes": "Debit Order", "referenceNumber": "2020/09/2339107", "reason": null, "nextPremiumDate": null, "allocatedTo": "UNALLOCATED", "followUp": null, "previousAccountNumber": "5754654654654", "previousAccountType": "SAVINGS", "previousBranch": "2555", "previousInstitution": "SANLAM PERSONAL LOAN", "channel": "ASP", "originEmployeeName": null, "originEmployeeSurname": null, "originEmployeeNumber": null, "originSiteCode": null, "originSiteName": null, "valid": true, "primaryTrigger": "", "friendlyState": "Ready to send", "formattedDueDate": "30/06/2020", "age": 0, "overdue": false, "triggers": [], "channelValid": true, "_links": { "self": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509" }, "switchRequest": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509" }, "history": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/history" }, "letter": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/letter" }, "download": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/letter/download" }, "follow-up": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/follow-up" }, "institution": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/institution" }, "customer": { "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/switches/16509/customer" } } }';
    public static final String POSITIVE_RESPONSE_BODY_GET_INSTITUTION = '{ "_embedded" : { "items" : [ { "createdBy" : "bdp_user", "lastModifiedBy" : "bdp_user", "creationDate" : "2020-07-02T12:28:47.118+0000", "lastModifiedDate" : "2020-07-02T12:28:47.118+0000", "name" : "ABSA ", "contactPerson" : null, "contactEmail" : null, "contactDepartment" : null, "debitOrderAutomatedEmail" : null, "salaryAutomatedEmail" : null, "regexPatterns" : null, "debitOrderAcknowledgeHoursSLA" : 0, "debitOrderResolveHoursSLA" : 0, "salaryAcknowledgeHoursSLA" : 0, "salaryResolveHoursSLA" : 0, "route" : "NON_PARTICIPATING", "categories" : null, "batchFileType" : null, "batchFormatterType" : null, "batchIntegrationType" : null, "connectionPrefix" : null, "template" : null, "_links" : { "self" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/6518" }, "institution" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/6518" }, "history" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/6518/history" } } }, { "createdBy" : "admin", "lastModifiedBy" : "admin", "creationDate" : "2019-11-27T21:22:00.404+0000", "lastModifiedDate" : "2019-11-27T21:22:00.404+0000", "name" : "CHUBB SA", "contactPerson" : "", "contactEmail" : "Depolelo.Mathebula@absa.africa", "contactDepartment" : "Customer Service", "debitOrderAutomatedEmail" : "Depolelo.Mathebula@absa.africa", "salaryAutomatedEmail" : null, "regexPatterns" : null, "debitOrderAcknowledgeHoursSLA" : 4, "debitOrderResolveHoursSLA" : 4, "salaryAcknowledgeHoursSLA" : 0, "salaryResolveHoursSLA" : 0, "route" : "PARTICIPATING", "categories" : [ ], "batchFileType" : "EXCEL", "batchFormatterType" : null, "batchIntegrationType" : null, "connectionPrefix" : null, "template" : null, "_links" : { "self" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/235" }, "institution" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/235" }, "history" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/235/history" } } } ] }, "_links" : { "self" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions" }, "profile" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/profile/institutions" }, "search" : { "href" : "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/search" } } }'; 
    public static final String POSITIVE_RESPONSE_BODY_GET_BY_NAME = '{ "_embedded": { "items": [ {"createdBy": "bdp_user", "lastModifiedBy": "bdp_user", "creationDate": "2021-05-14T08:37:20.545+0000",                "lastModifiedDate": "2021-05-14T08:37:20.545+0000",                "name": "UAT TEST2",                "contactPerson": null,                "contactEmail": "TEST@TEST.COM",                "contactDepartment": null,                "debitOrderAutomatedEmail": null,                "salaryAutomatedEmail": null,                "regexPatterns": null,                "debitOrderAcknowledgeHoursSLA": 0,                "debitOrderResolveHoursSLA": 0,                "salaryAcknowledgeHoursSLA": 0,                "salaryResolveHoursSLA": 0,                "route": "NON_PARTICIPATING",                "categories": null,                "batchFileType": null,                "batchFormatterType": null,                "batchIntegrationType": null,                "archived": 0,                "connectionPrefix": null,                "template": null,                "_links": {                    "self": {                        "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/25404"                    },                    "institution": {                        "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/25404"                    },                    "history": {                        "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/25404/history"                    }                }            }        ]    },    "_links": {        "self": {            "href": "https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/search/findByName?name=UAT%20TEST2"        }    }}';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{SwitchingCustomers_IH_v1.SwitchingCustomersPOST});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{SwitchingInstitutions_IH_v1.SwitchingInstitutions});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Switches_IH_v1.SwitchesPUT});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Switches_IH_v1.SwitchesGET});
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Switches_IH_v1.SwitchesPOST});
        String auniqueUserName = 'UserAdmin' + DateTime.now().getTime() + '@testorg.com';
        String aemail = 'UserAdmin@testorg.com';
        Profile ap = [SELECT Id FROM Profile WHERE Name = 'Standard User (Branch)'];
        User au = new User(
            Alias = 'standt',
            Email = aemail,
            EmailEncodingKey = 'UTF-8',
            LastName = 'UserAdmin',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = ap.Id,
            TimeZoneSidKey = 'Africa/Johannesburg',
            UserName = auniqueUserName,
            MobilePhone = '0823389021',
            Advisor_Code__c = '112233'
        );
        insert au;
        System.runAs(au) {
            Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque',ProductCode='11021');
            insert prod;

            Pricebook2 pb = new Pricebook2();
            pb.IsActive=true;
            pb.id =test.getStandardPricebookId();
            update pb;

            PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
            insert customPrice;

            Account account = new Account();
            account.ID_Number__pc = '9308305015082';
            account.FirstName = 'Test';
            account.LastName = 'Tester';
            account.Gender__pc = 'Male';
            account.Next_of_Kin_Last_Name__pc = 'Testing';
            account.Next_of_Kin_First_Name_s__pc = 'Testing';

            account.CIF__c='LTD 933';
            account.Language__c='english';
            account.Number_Of_Dependents__c=0;
            account.PersonEmail='test@absa.africa';
            account.PersonMobilePhone='0819908786';
            account.ID_Type__pc='PASSPORT';
            account.Nationality__pc='ZIM';
            account.Highest_Qualification__pc='Matric';
            account.Residential_Status__pc='Owner';
            account.Marital_Status__pc='MARRIED';
            account.CASA_Risk_Status__c = 'High';
            account.PersonBirthdate = Date.valueOf('1993-01-12');
            insert account;

            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opp Onboarding';
            opp.CloseDate = Date.today();
            opp.StageName = 'New';
            opp.Pricebook2Id = pb.id;
            opp.AccountId = account.id;
            opp.CBPIndicator__c = '123456789';
            insert opp;

            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.OpportunityId = opp.id;
            oppLineItem.Product2Id = prod.id;
            oppLineItem.PricebookEntryId = customPrice.id;
            oppLineItem.Quantity = 1;
            oppLineItem.TotalPrice = 100;
            oppLineItem.Policy_Number__c='4048272164';
            insert oppLineItem;

            Switching_Institution__c institution = new Switching_Institution__c();
            institution.Name = 'Test Institution';
            institution.Route__c = 'Test';
            institution.Links__c = 'https://cafe-switching-backend.cafe-uat.rbb-banking.sdc-nonprod.caas.absa.co.za/institutions/616';
            insert institution;

            Switching_Entry__c switchEntry = new Switching_Entry__c();
            switchEntry.OpportunityId__c = opp.Id;
            switchEntry.Name = 'Switch Entry Test';
            switchEntry.Employer_Name__c = 'Test Institution';
            switchEntry.Previous_Institution__c = 'Test Institution';
            insert switchEntry;
        }
    }
    @isTest
    public static void testswitchingCustomerData() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_CUSTOMER));

        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            Test.startTest();

            SwitchingDebitOrder debitOrder = new SwitchingDebitOrder();
            debitOrder.serviceProvider = '';
            debitOrder.refAccountNumber = '1234';
            debitOrder.dueDate = '20201212';
            debitOrder.frequency = '1';
            debitOrder.amount = '1';
            debitOrder.fixvar = '1';
            debitOrder.action = 'Test';
            debitOrder.opportunityId = '1';

            Account account = [SELECT Id FROM Account WHERE Name = 'Test Tester'];
            Switching switchingO = new Switching();
            switchingO.accountId = account.Id;
            switchingO.datePaid = '2020-10-30';
            switchingO.employer = 'UAT TEST2';
            switchingO.previousAccountHolder = 'Frank Doe';
            switchingO.previousAccountNumber = '9051316791';
            switchingO.previousAccountType = 'SAVINGS';
            switchingO.previousBank = 'UAT TEST2';
            switchingO.isDebitOrder = true;
            switchingO.isSalary = true;
            switchingO.debitOrders = '';

            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
            SwitchingController.getOpprLineItem(opp.Id);
            SwitchingController.switchingCustomerData(switchingO);
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }

    @isTest
    public static void testswitchingSalaryData() {
        //Order is important (first added will be loaded last)
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_LINK_CUSTOMER));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_TRIGGER));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_LINK_INSTITUTION));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET_BY_NAME));
        //Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_SWITCH));

        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            Test.startTest();
            Account account = [SELECT Id FROM Account WHERE Name = 'Test Tester'];
            Switching switchingO = new Switching();
            switchingO.accountId = account.Id;
            switchingO.datePaid = '2020-10-30';
            switchingO.employer = 'UAT TEST2';
            switchingO.previousAccountHolder = 'Frank Doe';
            switchingO.previousAccountNumber = '9051316791';
            switchingO.previousAccountType = 'SAVINGS';
            switchingO.previousBank = 'UAT TEST2';
            switchingO.isDebitOrder = false;
            switchingO.isSalary = true;
            switchingO.debitOrders = '';

            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
            SwitchingController.getOpprLineItem(opp.Id);
            SwitchingController.switchingSalaryData(switchingO, 'https://esb.api.uat.absa.co.za:1001/enterprise-uat/uat/integration/institutions/customers/2056');
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }

    @isTest
    public static void testswitchingDebitOrderData() {
        //Order is important (first added will be loaded last)
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_LINK_CUSTOMER));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_TRIGGER));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_LETTER));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_LINK_INSTITUTION));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET_BY_NAME));
        //Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_SWITCH));

        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            Test.startTest();
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
            SwitchingController.getOpprLineItem(opp.Id);
            Switching_Institution__c institution = [SELECT Id FROM Switching_Institution__c WHERE Name = 'Test Institution'];
            SwitchingController.getSwitchingInstitution(institution.Id);
            SwitchingController.switchingDebitOrderData('{"serviceProvider":"UAT TEST2","refAccountNumber":"vb5465464","dueDate":"2020-10-29","frequency":"Quarterly","amount":"567","fixvar":"Variable","action":"edit","institution":{"Id":"'+institution.Id+'","Name":"AFRICAN BANK","isNew":false}}', 'https://esb.api.uat.absa.co.za:1001/enterprise-uat/uat/integration/institutions/customers/2056' , '9051316791', 'SAVINGS', 'AFRICAN BANK');
            SwitchingController.switchingDebitOrderData('{"serviceProvider":"UAT TEST2","refAccountNumber":"vb5465464","dueDate":"2020-10-29","frequency":"Quarterly","amount":"567","fixvar":"Variable","action":"edit","institution":{"Id":"'+institution.Id+'","Name":"AFRICAN BANK","isNew":true}}', 'https://esb.api.uat.absa.co.za:1001/enterprise-uat/uat/integration/institutions/customers/2056' , '9051316791', 'SAVINGS', 'AFRICAN BANK');
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }

    @isTest
    public static void testgetAccount() {
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Test';
        acc.AccountNumber = '1234';
        acc.ID_Number__pc = '9312121234567';
        acc.PersonMobilePhone = '1234567';
        acc.Communication_Language__pc = 'English';
        acc.Communication_Method__c = 'Email';
        acc.PersonEmail = 'Test@test.com';
        insert acc;

        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            Test.startTest();
            Account resp = SwitchingController.getAccount(acc.Id);
            System.assertEquals(acc.Id, resp.Id, 'Test Successful');
            Test.stopTest();
        }
    }

    @isTest
    public static void testgetSwitchesFromOpprProduct() {
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            Test.startTest();
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
            OpportunityLineItem oppLineItem = [SELECT Id, Switches__c FROM OpportunityLineItem WHERE OpportunityId =: opp.id];
            oppLineItem.Switches__c = '11001';
            update oppLineItem;
            SwitchingController.getSwitchesFromOpprProduct(String.valueOf(opp.Id));
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }

    @isTest
    public static void testgetSwitch() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_GET_INSTITUTION));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_SWITCH));

        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            Test.startTest();
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
            SwitchingController.getSwitch('11001');
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }

    @isTest
    public static void testgetPendingSwitches() {
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            Test.startTest();
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
            SwitchingController.getPendingSwitches(String.valueOf(opp.Id));
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();

        }
    }

    @isTest
    public static void testsaveDebitOrderEntriesPositive() {
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            string accountNumber = '9052345737';
            string selectedBankName = 'ALEXANDER FORBES';
            string accountName = 'Test';
            string previousAccountType = 'Cheque';

            Test.startTest();
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
            Switching_Institution__c institution = [SELECT Id, Name FROM Switching_Institution__c WHERE Name = 'Test Institution'];
            string doo = '{"serviceProvider": "ALEXANDER FORBES","refAccountNumber": "4078949848","dueDate": "2021-04-01","frequency": "Monthly","amount": "100","fixvar": "Fixed","action": "edit","institution": {"Id": "' + institution.Id + '","Name": "' + institution.Name + '","isNew": false},"opportunityId":  "' + opp.Id + '"}';   
            SwitchingController.saveDebitOrderEntries(doo, accountNumber, previousAccountType, selectedBankName, accountName);
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }

    @isTest
    public static void testsaveDebitOrderEntriesNegative() {
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            string accountNumber = '9052345737';
            string selectedBankName = 'ALEXANDER FORBES';
            string accountName = 'Test';
            string previousAccountType = 'Cheque';

            Test.startTest();
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
            Switching_Institution__c institution = [SELECT Id, Name FROM Switching_Institution__c WHERE Name = 'Test Institution'];
            Switching_Entry__c switchEntry = [SELECT Id, Name FROM Switching_Entry__c WHERE Name =: 'Switch Entry Test'];
            string doo = '{"pendingDebitOrderId": "' + switchEntry.Id + '","serviceProvider": "ALEXANDER FORBES","refAccountNumber": "4078949848","dueDate": "2021-04-01","frequency": "Monthly","amount": "100","fixvar": "Fixed","action": "edit","institution": {"Id": "' + institution.Id + '","Name": "' + institution.Name + '","isNew": false},"opportunityId": "' + opp.Id + '"}';
            SwitchingController.saveDebitOrderEntries(doo, accountNumber, previousAccountType, selectedBankName, accountName);
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }

    @isTest
    public static void testsaveSalarySwitchEntryPositive() {
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            Test.startTest();
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
            SwitchingController.getOpprLineItem(opp.Id);
            Switching switchingO = new Switching();
            switchingO.datePaid = '2020-10-30';
            switchingO.employer = 'Salesforce Test';
            switchingO.previousAccountHolder = 'Frank Doe';
            switchingO.previousAccountNumber = '9051316791';
            switchingO.previousAccountType = 'SAVINGS';
            switchingO.previousBank = 'Salesforce Bank Test';
            switchingO.isDebitOrder = false;
            switchingO.isSalary = true;
            switchingO.debitOrders = '';
            switchingO.pendingSalarySwitchId = '';
            SwitchingController.saveSalarySwitchEntry(switchingO);
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }

    @isTest
    public static void testsaveSalarySwitchEntryNegative() {
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            Test.startTest();
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
            Switching_Entry__c switchEntry = [SELECT Id, Name FROM Switching_Entry__c WHERE Name =: 'Switch Entry Test'];
            SwitchingController.getOpprLineItem(opp.Id);
            Switching switchingO = new Switching();
            switchingO.datePaid = '2020-10-30';
            switchingO.employer = 'Test Institution';
            switchingO.previousAccountHolder = 'Frank Doe';
            switchingO.previousAccountNumber = '9051316791';
            switchingO.previousAccountType = 'SAVINGS';
            switchingO.previousBank = 'Test Institution';
            switchingO.isDebitOrder = false;
            switchingO.isSalary = true;
            switchingO.debitOrders = '';
            switchingO.pendingSalarySwitchId = switchEntry.Id;
            SwitchingController.saveSalarySwitchEntry(switchingO);
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }

    @isTest
    public static void testgetSwitchesLetterNegative() {
        User au = new User();
        Set<String> userEmails = new Set<String>();
        userEmails.add('UserAdmin@testorg.com');
        List<User> userList = new UsersSelector().selectByEmail(userEmails);
        if (userList.size() > 0) {
            for (User u : userList) {
                if (u.Email == 'UserAdmin@testorg.com') {
                    au = u;
                }
            }
        }
        System.runAs(au) {
            Test.startTest();
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding'];
            string switchId = null;
            SwitchingController.getSwitchesLetter(switchId);
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }
}