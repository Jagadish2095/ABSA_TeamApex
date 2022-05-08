/*
Controller Test Class For BranchApplicationController class
*
* @author  Clifford Willers : ABSA (IQ Business)
* @version v1.0
* @since   2020-11-17
*
*/

@isTest
public class BranchApplicationControllerTest {

    public static final String POSITIVE_RESPONSE_BODY = '{"applyResponse":{"return":{"application":{"annualCreditLimitIncreases":false,"applicationNumber":102010080131011579,"applicationType":"P","campaignId":0,"cardProdSubProdGroupId":0,"channelCode":"B","consents":{"deaConsent":false},"corpCode":"ABSA","creditLifeRequired":false,"creditLimitApproved":0,"creditLimitSelected":0,"creditStatus":{"description":"Pre-Scoring Approved","id":"08"},"dateCreated":"2020-10-08T01:31:01.999+02:00","debitOrderDetails":null,"externalConsumerData":{"customerId":9407229216088,"customerSourceCode":"ABSA","customerSourceReferenceNumber":"THIS IS A TEST3"},"hasAcceptedCourierCollectionFee":false,"hasAcceptedSpecifiedCreditLimit":false,"knockOutQuestions":{"absaRewards":false,"casaClauseRead":true,"creditBureauConsent":false,"creditLifeTermsAndConditionsRead":false,"curatorship":false,"currentlyUnderDebtCounselling":false,"debitOrderByPass":false,"declaredInsolvent":false,"monthlyGrossIncomeAboveMin":false,"olderThan18Years":false,"pendingDebtCounselling":false,"permanentSAResident":false,"registeredForeingTax":false,"rehabilitation":{"everBeenDeclaredInsolvent":false,"everUndergoneDebtCounselling":false},"spouseConsent":false,"termsAndConditionsRead":true},"linkedAccountSelected":null,"lockVersionId":43678,"lowValuePaymentRequired":false,"marketingSiteId":4592,"numberOfSecondaryApplicantsRequested":0,"packageId":null,"personWhoCreatedApplication":"ABAJ013","pinOptionSelected":null,"primaryApplicant":{"cardCollection":null,"cardProdSubProdGroupId":0,"casaInformation":{"referenceNumber":0,"versionNumber":0},"cellPhoneNumber":{"countryCode":null,"extension":null,"number":"0725845698"},"emailAddress":null,"employer":{"address":null,"name":null},"expense":null,"familyStatus":{"maritalStatus":0,"numberOfDependents":0},"financialInformationSuppliedCorrect":false,"firstNames":"FABIAN GERONE","hasSocialGrant":false,"homeFaxNumber":null,"homeTelephoneNumber":null,"idOrRegistrationNo":"9407229216088       ","identificationType":"01","income":{"disposableMonthlyIncome":0,"grossMonthlyIncome":0,"grossMonthlySalary":0,"nettMonthlyIncome":0,"otherIncome":{"amount":0}},"incomeTaxNumber":0,"initials":"FG        ","isInBusinessRescueAffectedParty":false,"marketingConsentGiven":false,"mayCheckCreditWorthiness":false,"mayReceiveMarketingViaEmail":false,"mayReceiveMarketingViaPost":false,"mayReceiveMarketingViaSMS":false,"mayReceiveMarketingViaTelephone":false,"nextOfKin":null,"postalAddress":null,"preAssessed":null,"qualification":{"hasPostMatricQualification":false},"residentialAddress":null,"shareInfoWithCreditProviders":false,"sourceOfIncome":0,"surname":"PALADI","tempPermitNumber":0,"titleType":"01","workFaxNumber":null,"workTelephoneNumber":null},"productGroupId":1,"quote":null,"statementDeliveryMethodSelected":null,"statusGroup":1},"responseCommons":{"messageTimeStamp":"2020-10-08T01:31:09.325+02:00","success":"TRUE"}}}}';

    @testSetup
    static void dataCreation(){
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
            IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCApplicationService_apply_IH_v1.INTEGRATION_SERVICE_NAME});
            Application__c application = new Application__c(First_Name__c = 'TestApplication');
            insert application;
        }
    }

    @isTest
    public static void getPaymentPlanRecordIdTest(){
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
            Application__c application = [SELECT Id FROM Application__c where First_Name__c = 'TestApplication' LIMIT 1];
            Test.startTest();
            String errorText = BranchApplicationController.getPaymentPlanRecordId(application.Id);
            System.assert(errorText != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void getApplicationFinancialAccountRecordId(){
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
            Application__c application = [SELECT Id FROM Application__c where First_Name__c = 'TestApplication' LIMIT 1];
            String accountPurpose = 'Salary';
            Test.startTest();
            String errorText = BranchApplicationController.getApplicationFinancialAccountRecordId(application.Id, accountPurpose);
            System.assert(errorText != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void getApplicationProductRecordId(){
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
            Application__c application = [SELECT Id FROM Application__c where First_Name__c = 'TestApplication' LIMIT 1];
            Test.startTest();
            String errorText = BranchApplicationController.getApplicationProductRecordId(application.Id);
            System.assert(errorText != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void getSalaryAccoutDetails(){
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
            Application__c application = [SELECT Id FROM Application__c where First_Name__c = 'TestApplication' LIMIT 1];
            Test.startTest();
            Map<String, String> errorText = BranchApplicationController.getSalaryAccoutDetails(application.Id);
            System.assert(errorText != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void getPickListValues(){
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
            SObject objObject = Address__c.SObjectType.newSObject();
            String objField = 'Shipping_Country__c';
            Test.startTest();
            List<String> addresses = BranchApplicationController.getPickListValues(objObject, objField);
            System.assert(addresses != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void getBankInfo(){
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
            List<String> addresses = BranchApplicationController.getBankInfo();
            System.assert(addresses != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void callCompleteTwo() {
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
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
            Test.startTest();
            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
            createTestPostalAddress(acc);
            createTestFinancialAccount(app);
            createTestBankInfo(app);
            String response = BranchApplicationController.callCompleteTwo(app, '', '', '');
            System.assert(response != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void applyInstantAccountOpening() {
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
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
            Test.startTest();
            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
            String response = BranchApplicationController.applyInstantAccountOpening(app, '', '');
            System.assert(response != null, 'Test Working');
            Test.stopTest();
        }
    }

    @isTest
    public static void applyInitiateDebiCheck() {
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
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
            Test.startTest();
            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
            String response = BranchApplicationController.applyInitiateDebiCheck(app, '', '');
            System.assert(response != null, 'Test Working');
            Test.stopTest();
        }
    }

    private static void createTestPostalAddress(Id accountId) {
        Address__c addr = new Address__c();
        addr.Account__c = accountId;
        addr.Address_Type__c = 'Postal';
        addr.Shipping_City__c = 'Test City';
        addr.Shipping_Country__c = 'South Africa';
        addr.Shipping_Street__c = '1 Test Drv';
        addr.Shipping_Suburb__c = 'Tested';
        insert addr;
    }

    private static Id createTestApplication(Id accountId) {
        Application__c app = new Application__c();
        app.Account__c = accountId;
        insert app;
        return app.Id;
    }

    private static Id createTestAccount() {
        Account acc = new Account();
        acc.FirstName = 'Test';
        acc.LastName = 'Account';
        acc.PersonEmail = 'test@account.com';
        acc.PersonMobilePhone = '0123456789';
        acc.ID_Number__pc = '0123456789012';
        acc.Titles__pc = 'Mr';
        acc.CIF__c = 'TESTCUST01';
        insert acc;
        return acc.Id;
    }

    private static void createTestFinancialAccount(Id applicationId)
    {
        Application_Financial_Account__c fa = new Application_Financial_Account__c();
        fa.Application__c = applicationId;
        fa.Account_Number__c = 1234;
        fa.Account_Type__c = 'Cheque';
        fa.Institution_Name__c = 'ABSA';
        fa.Account_Purpose__c = 'Salary';
        fa.Institution_Name__c = 'ABSA';
        insert fa;
    }

    private static void createTestBankInfo(Id applicationId)
    {
        BankInfo__c bi = new BankInfo__c();
        bi.Name = 'ABSA';
        bi.Bank_short_name__c = '';
        bi.Branch_code__c = '1234';
        bi.Other_bank__c = false;
        insert bi;
    }
}