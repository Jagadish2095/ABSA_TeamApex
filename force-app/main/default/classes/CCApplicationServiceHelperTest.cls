/*
* Test Coverage for CCApplicationServiceHelper
* @author Aaron Castelyn: Absa 
* @created 2021-01-11
*/

@isTest
public class CCApplicationServiceHelperTest {

    public static final String POSITIVE_RESPONSE_BODY = '{"applyResponse":{"return":{"application":{"annualCreditLimitIncreases":false,"applicationNumber":102010080131011579,"applicationType":"P","campaignId":0,"cardProdSubProdGroupId":0,"channelCode":"B","consents":{"deaConsent":false},"corpCode":"ABSA","creditLifeRequired":false,"creditLimitApproved":0,"creditLimitSelected":0,"creditStatus":{"description":"Pre-Scoring Approved","id":"08"},"dateCreated":"2020-10-08T01:31:01.999+02:00","debitOrderDetails":null,"externalConsumerData":{"customerId":9407229216088,"customerSourceCode":"ABSA","customerSourceReferenceNumber":"THIS IS A TEST3"},"hasAcceptedCourierCollectionFee":false,"hasAcceptedSpecifiedCreditLimit":false,"knockOutQuestions":{"absaRewards":false,"casaClauseRead":true,"creditBureauConsent":false,"creditLifeTermsAndConditionsRead":false,"curatorship":false,"currentlyUnderDebtCounselling":false,"debitOrderByPass":false,"declaredInsolvent":false,"monthlyGrossIncomeAboveMin":false,"olderThan18Years":false,"pendingDebtCounselling":false,"permanentSAResident":false,"registeredForeingTax":false,"rehabilitation":{"everBeenDeclaredInsolvent":false,"everUndergoneDebtCounselling":false},"spouseConsent":false,"termsAndConditionsRead":true},"linkedAccountSelected":null,"lockVersionId":43678,"lowValuePaymentRequired":false,"marketingSiteId":4592,"numberOfSecondaryApplicantsRequested":0,"packageId":null,"personWhoCreatedApplication":"ABAJ013","pinOptionSelected":null,"primaryApplicant":{"cardCollection":null,"cardProdSubProdGroupId":0,"casaInformation":{"referenceNumber":0,"versionNumber":0},"cellPhoneNumber":{"countryCode":null,"extension":null,"number":"0725845698"},"emailAddress":null,"employer":{"address":null,"name":null},"expense":null,"familyStatus":{"maritalStatus":0,"numberOfDependents":0},"financialInformationSuppliedCorrect":false,"firstNames":"FABIAN GERONE","hasSocialGrant":false,"homeFaxNumber":null,"homeTelephoneNumber":null,"idOrRegistrationNo":"9407229216088       ","identificationType":"01","income":{"disposableMonthlyIncome":0,"grossMonthlyIncome":0,"grossMonthlySalary":0,"nettMonthlyIncome":0,"otherIncome":{"amount":0}},"incomeTaxNumber":0,"initials":"FG        ","isInBusinessRescueAffectedParty":false,"marketingConsentGiven":false,"mayCheckCreditWorthiness":false,"mayReceiveMarketingViaEmail":false,"mayReceiveMarketingViaPost":false,"mayReceiveMarketingViaSMS":false,"mayReceiveMarketingViaTelephone":false,"nextOfKin":null,"postalAddress":null,"preAssessed":null,"qualification":{"hasPostMatricQualification":false},"residentialAddress":null,"shareInfoWithCreditProviders":false,"sourceOfIncome":0,"surname":"PALADI","tempPermitNumber":0,"titleType":"01","workFaxNumber":null,"workTelephoneNumber":null},"productGroupId":1,"quote":null,"statementDeliveryMethodSelected":null,"statusGroup":1},"responseCommons":{"messageTimeStamp":"2020-10-08T01:31:09.325+02:00","success":"TRUE"}}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCApplicationService_apply_IH_v1.INTEGRATION_SERVICE_NAME});

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
    }

    @isTest static void testApplyPreScreen() {
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
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

            Test.startTest();
            
            Id acc = createTestAccount();

            CCApplicationService_apply_Resp_IB_v1 response = CCApplicationServiceHelper.ApplyPreScreen(acc);

            System.assert(response != null, 'ApplyPreScreen has a response');

            Test.stopTest();
        }
    }

    @isTest static void testApplyClientUpdate() {
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
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

            Test.startTest();
            
            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
            
            createTestResidentialAddress(acc);
            createTestPostalAddress(acc);

            createTestProduct(acc, app);

            CCApplicationService_apply_Resp_IB_v1 response = CCApplicationServiceHelper.ApplyClientUpdate(acc, app, '');

            System.assert(response != null, 'ApplyClientUpdate has a response');

            Test.stopTest();
        }
    }

    @isTest static void testApplyFinalScoring() {
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
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
                    
            createTestEmployerAddress(acc);

            createTestIncomeExpense(app, 'Monthly Income', 'Other Income');
            createTestIncomeExpense(app, 'Monthly Income', 'Gross Income');
            createTestIncomeExpense(app, 'Monthly Income', 'Net Income');
            createTestIncomeExpense(app, 'Monthly Income', 'Rental Income');
            createTestIncomeExpense(app, 'Monthly Income', 'Other');
            createTestIncomeExpense(app, 'Monthly Income', 'Bank Statements Consent');

            createTestIncomeExpense(app, 'Fixed Debt', 'Asset Payment');
            createTestIncomeExpense(app, 'Fixed Debt', 'Credit Payment');
            createTestIncomeExpense(app, 'Fixed Debt', 'Loan Payment');
            createTestIncomeExpense(app, 'Fixed Debt', 'Homeloan Payment');
            createTestIncomeExpense(app, 'Fixed Debt', 'Retail Payment');
            createTestIncomeExpense(app, 'Fixed Debt', 'Joint Responsible');

            createTestIncomeExpense(app, 'Living Expenses', 'Household Expense');
            createTestIncomeExpense(app, 'Living Expenses', 'Fuel Expense');
            createTestIncomeExpense(app, 'Living Expenses', 'Education Fee');
            createTestIncomeExpense(app, 'Living Expenses', 'Insurance Polices');
            createTestIncomeExpense(app, 'Living Expenses', 'Maintenance Expense');
            createTestIncomeExpense(app, 'Living Expenses', 'Rent');
            createTestIncomeExpense(app, 'Living Expenses', 'Other Amount');

            Test.startTest();
            CCApplicationService_FnlScorng_Req_IB_v1 requestBean = CCApplicationService_FnlScorng_Req_IB_v1.createDummyRequest();

            CCApplicationService_apply_Resp_IB_v1 response = CCApplicationServiceHelper.ApplyFinalScoring(app, '', '', '', '');
            
            System.assert(response != null, 'ApplyFinalScoring has a response');

            Test.stopTest();
        }
    }

    @isTest static void testApplyComplete1() {
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
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

            Test.startTest();

            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
            
            CCApplicationService_apply_Resp_IB_v1 response = CCApplicationServiceHelper.ApplyComplete1(app, '', '', '', '', '0', '0', '', '');
            
            System.assert(response != null, 'ApplyComplete1 has a response');
            Test.stopTest();
        }
    }

    @isTest static void testApplyComplete2() {
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
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

            Test.startTest();
            
            Id acc = createTestAccount();
            Id app = createTestApplication(acc);

            createTestPostalAddress(acc);        
            createTestFinancialAccount(app);
            createTestBankInfo(app);

            CCApplicationService_apply_Resp_IB_v1 response = CCApplicationServiceHelper.ApplyComplete2(app, '', '', '');
            
            System.assert(response != null, 'ApplyComplete2 has a response');

            Test.stopTest();
        }
    }

    @isTest static void testApplyQuoteAccept() {
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
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

            Test.startTest();

            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
            
            CCApplicationService_apply_Resp_IB_v1 response = CCApplicationServiceHelper.ApplyQuoteAccept(app, '', '', '', '');
            
            System.assert(response != null, 'ApplyQuoteAccept has a response');

            Test.stopTest();
        }
    }

    @isTest static void testApplyInstantAccountOpening() {
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
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

            Test.startTest();

            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
            
            CCApplicationService_apply_Resp_IB_v1 response = CCApplicationServiceHelper.ApplyInstantAccountOpening(app, '', '');
            
            System.assert(response != null, 'ApplyInstantAccountOpening has a response');

            Test.stopTest();
        }
    }

    @isTest static void testApplyInitiateDebiCheck() {
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
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

            Test.startTest();

            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
            
            CCApplicationService_apply_Resp_IB_v1 response = CCApplicationServiceHelper.ApplyInitiateDebiCheck(app, '', '');
            
            System.assert(response != null, 'ApplyInitiateDebiCheck has a response');

            Test.stopTest();
        }
    }

    @isTest static void testCancelApplication() {
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
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

            Test.startTest();

            Id acc = createTestAccount();
            Id app = createTestApplication(acc);
            
            CCApplicationService_cancel_Resp_IB_v1 response = CCApplicationServiceHelper.CancelApplication(app, '', '');
            
            System.assert(response != null, 'CancelApplication has a response');

            Test.stopTest();
        }
    }

    @isTest static void testGetApplicationInformation() {
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
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

            Test.startTest();
    
            CCApplicationService_get_Resp_IB_v1 response = CCApplicationServiceHelper.GetApplicationInformation('102103311801332803');
            
            System.assert(response != null, 'GetApplicationInformation has a response');

            Test.stopTest();
        }
    }

    private static Id createTestAccount() {
        Account acc = new Account();

        acc.FirstName = 'Test';
        acc.LastName = 'Account';        
        acc.PersonEmail = 'test@account.com';
        acc.PersonHomePhone = '0123456789';
        acc.PersonMobilePhone = '0123456789';
        acc.Phone = '0123456789';
        acc.ID_Number__pc = '8412117626084';
        acc.PersonBirthdate = Date.valueOf('1984-12-11');
        acc.Titles__pc = 'Mr';
        acc.CIF__c = 'TESTCUST01';
        acc.Next_of_Kin_Cellphone_Number__pc = '0123456789';
        acc.Next_of_Kin_Telephone_Number__pc = '0123456789';

        insert acc;

        return acc.Id;
    }
    
    private static void createTestResidentialAddress(Id accountId) {
        Address__c addr = new Address__c();

        addr.Account__c = accountId;
        addr.Address_Type__c = 'Residential';
        addr.Shipping_City__c = 'Test City';
        addr.Shipping_Country__c = 'South Africa';
        addr.Shipping_Street__c = '1 Test Drv';
        addr.Shipping_Suburb__c = 'Tested';        

        insert addr;
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

    private static void createTestEmployerAddress(Id accountId) {
        Address__c addr = new Address__c();

        addr.Account__c = accountId;
        addr.Address_Type__c = 'Employers';
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

    private static void createTestProduct(Id accountId, Id applicationId) {
        //Create Product and Price Book
        Product2 p = new Product2();

        p.Name = 'Test';
        p.ProductCode = '11032';
        p.Price_Scheme_Code__c = 'CQT01S48';
        p.IsActive = true;
        p.Family = 'Test';
        
        insert p;

        // PriceBook2 book = new PriceBook2();

        // book.Name = 'Test Book';
        // book.IsActive = true;
        
        // insert book;

        PriceBookEntry pbe = new PriceBookEntry();

        pbe.UnitPrice = 1;
        pbe.Pricebook2Id = Test.getStandardPricebookId(); //book.Id;
        pbe.Product2Id = p.Id;
        pbe.IsActive = true;

        insert pbe;

        //Create Opportunity
        Opportunity opp = new Opportunity();

        opp.accountId = accountId;
        opp.Name = 'Test';
        opp.StageName = 'Registration';
        opp.CloseDate = System.today() + 1;
        opp.PriceBook2Id = Test.getStandardPricebookId(); //book.Id;
        opp.CBPIndicator__c = '1234567890';

        insert opp;

        //Update Application with Opportunity
        Application__c app = [SELECT Opportunity__c FROM Application__c WHERE Id = :applicationId];

        app.Opportunity__c = opp.Id;

        update app;

        //Create Opportunity Line Item
        OpportunityLineItem item = new OpportunityLineItem();

        item.Application__c = applicationId;
        item.OpportunityId = opp.Id;
        item.Product2Id = p.Id;
        item.Quantity = 1;
        item.TotalPrice = 1;

        insert item;
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

    private static void createTestIncomeExpense(Id applicationId, string category, string expenseValue)
    {
        
        Application_Income_and_Expense__c result = new Application_Income_and_Expense__c();

        result.Application__c = applicationId;
        result.Category__c = category;
        result.Expense_Value__c = expenseValue;
        result.Applicant_Value__c = 0;

        insert result;
    }
}