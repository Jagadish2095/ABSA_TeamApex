/*
Controller Test Class For BranchCreateAccountController class
*
* @author  Ulwazi Mapukata : ABSA
* @version v1.0
* @since   2021-07-25
* 1.1   2021-05-27   André Pietersen (IQ Business)		Added CORP code
* 1.2   2021-05-27   André Pietersen (IQ Business)		Added Multiple SOF and error display
* 1.3	06-09-2021   Brian Maswanganyi 				add test to pull request
* 1.4   2021-07-05   André Pietersen (IQ Business)   Marital Status conversion
 */
@isTest 
private class BranchCreateAccountControllerTest {
    public static final String POSITIVE_RESPONSE_CREATE_CHEQUE = '{    "CQS411O": {        "outputErrorMessage": {            "creditBackdateLimit": "S",            "crditBackdateLimitA": "M",            "studiesCompleted": "",            "surechequeIndA": "M",            "studyCourseA": "P",            "riskTypeA": "M",            "shadowLimitInd": "N",            "corpCode": "ABS",            "corpSubProductA": "P",            "postGradStudent": "",            "trustS781Acct": 0,            "clientType": 101,            "corpSubProduct": "0",            "surechequeInd": "N",            "mandateNbrA": "M",            "trustS781AcctA": "P",            "repayingInd": "",            "acctOpenDate": 20210218,            "clientNameA": "P",            "studyInstitution": "000",            "unilateralLimitIndA": "M",            "studentLoanInd": "N",            "extraFinanceReqrd": "",            "nbrYearsRepeated": 0,            "studiesCompletedA": "P",            "businessAcct": 0,            "chqBookColectSiteA": "P",            "acctOpenReason": 0,            "debitBackdateLimit": "S",            "siteNameA": "P",            "shadowLimitIndA": "M",            "repaymentStartDateA": "P",            "debitBackdateLimitA": "M",            "lawSocietyRegionA": "P",            "fullTimeStudent": "",            "managerNbrA": "M",            "lowRiskHoldAmountA": "M",            "fullTimeStudentA": "P",            "clientName": "MS M ABSA TEST",            "accountName": "",            "siteName": "TEST CENTRE",            "repayingIndA": "P",            "repaymentStartDate": 0,            "acbUserA": "M",            "studentNbrA": "P",            "normalDurationA": "P",            "AccountNbrOut": "4048451239",            "acbUser": "N",            "riskType": "H",            "currentAcademicYear": 0,            "acctStoppedInd": "N",            "unilateralLimitInd": "N",            "postGradStudentA": "P",            "relatedAcctNbr": 0,            "curentAcademicYearA": "P",            "trustSweepingInd": "N",            "trustSweepingIndA": "P",            "surechequeRetention": 0,            "studyInstitutionA": "P",            "lawSocietyRegion": "",            "chqBookCollectSite": 0,            "managerNbr": 1,            "extraFinanceReqrdA": "P",            "acctOpenReasonA": "M",            "mandateNbr": 0,            "lowRiskHoldAmount": 0,            "businessAcctA": "P",            "nbrYearsRepeatedA": "P",            "normalDuration": 0,            "studentNbr": "",            "sicCode": 0,            "acctStoppedIndA": "M",            "accountNameA": "M",            "finalYear": "",            "studyCourse": "",            "finalYearA": "P",            "surechequeRetentionA": "M",            "acctOpenDateA": "M"        }    },    "NBSAPDPO": {        "outputErrorHeaders": {            "returnCode": 0,            "outputServiceVersion": "BUSO002",            "reasonCode": 0        }    },    "MSGO": {        "NBSMSGO3": {            "NBNMSGO3_NBR_USER_ERRS": 0,            "NBSMSGO3_VERSION": "",            "NBNMSGO3_SYS_ERR_TXT": "",            "NBNMSGO3_NBR_USER_MSGS": 0,            "NBNMSGO3_MSG_ENTRY": [                {                    "NBNMSGO3_MSG_ERR_IND": "",                    "NBNMSGO3_MSG_TXT": "",                    "NBNMSGO3_MSG_CLASS": "",                    "NBNMSGO3_MSG_CODE": ""                },                {                    "NBNMSGO3_MSG_ERR_IND": "",                    "NBNMSGO3_MSG_TXT": "",                    "NBNMSGO3_MSG_CLASS": "",                    "NBNMSGO3_MSG_CODE": ""                },                {                    "NBNMSGO3_MSG_ERR_IND": "",                    "NBNMSGO3_MSG_TXT": "",                    "NBNMSGO3_MSG_CLASS": "",                    "NBNMSGO3_MSG_CODE": ""                },                {                    "NBNMSGO3_MSG_ERR_IND": "",                    "NBNMSGO3_MSG_TXT": "",                    "NBNMSGO3_MSG_CLASS": "",                    "NBNMSGO3_MSG_CODE": ""                },                {                    "NBNMSGO3_MSG_ERR_IND": "",                    "NBNMSGO3_MSG_TXT": "",                    "NBNMSGO3_MSG_CLASS": "",                    "NBNMSGO3_MSG_CODE": ""                }            ]        }    }}';
    public static final String POSITIVE_RESPONSE_BODY_FRAUD_APP = '{    "status": "SUCCESSFUL",    "content": {        "fraudStatus": "CLEAN",        "applicationNumber": "202101271406447219",        "channelReference": ""    },    "links": []}';
    public static final String POSITIVE_RESPONSE_METADATE = '{    "status": "SUCCESSFUL",    "errors": null,    "data": "Meta data successfully updated",    "links": []}';
    public static final String POSITIVE_RESPONSE_CREATE_SAVE = '{"data":{"AccountNumber": "9051159133"},"status": "","errors": []}';
    
    @testSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ AccountsMetadata_IH_v1.INTEGRATION_SERVICE_NAME });
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CQcreateAndLinkAccountV9_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ FraudSyncApplication_IH_V1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ FraudSyncApplication_IH_V1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ FraudSyncApplication_IH_V1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2, 
            new List<String>{SVcreateLinkSavingsAccount_IH_v1.INTEGRATION_SERVICE_NAME }
        );


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
            Advisor_Code__c = '112233',
            EmployeeNumber = '5035555'
        );
        insert au;
        System.runAs(au) {
            Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11021');
            insert prod;
            
            Product2 savingsprod = new Product2(Name = 'Savings Product', Family = 'Savings', ProductCode = '09050');
        	insert savingsprod; 
            
            Pricebook2 pb = new Pricebook2();
            pb.IsActive = true;
            pb.id = test.getStandardPricebookId();
            update pb;
            
            PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
            insert customPrice;
            
            PricebookEntry customPrice2 = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = savingsprod.Id, UnitPrice = 12000, IsActive = true);
            insert customPrice2;
            
            Account account = new Account();
            account.ID_Number__pc = '9308305015082';
            account.FirstName = 'Testee';
            account.LastName = 'McTestface';
            account.Gender__pc = 'Male';
            account.Next_of_Kin_Last_Name__pc = 'Testing';
            account.Next_of_Kin_First_Name_s__pc = 'Testing';
            account.Income_Source__pc = '';
            account.CIF__c = 'LTD 933';
            account.Language__c = 'english';
            account.Number_Of_Dependents__c = 0;
            account.PersonEmail = 'test@absa.africa';
            account.PersonMobilePhone = '0819908786';
            account.ID_Type__pc = 'PASSPORT';
            account.Nationality__pc = 'ZIM';
            account.Highest_Qualification__pc = 'Matric';
            account.Residential_Status__pc = 'Owner';
            account.Marital_Status__pc = 'MARRIED';
            account.CASA_Risk_Status__c = 'High';
            account.ID_Number__pc = '9301295015018';
            account.PersonBirthdate = Date.valueOf('1993-01-12');
            account.Employer_Name__pc = '';
            account.Employer_Sector__pc = '';
            account.Occupation_Level__pc = '';
            account.Occupation_Status__pc = '';
            account.Employer_Phone__c = '';
            account.ID_Type__pc = '';
            account.Nationality__pc = '';
            
            insert account;
            
            site__c siteRec = new site__c();
            siteRec.Site_Code__c = '1334';
            siteRec.Name = 'Test';
            insert siteRec;
            
            Opportunity opp = new Opportunity();
            opp.Name = 'Test Opp Onboarding Cheque';
            opp.CloseDate = Date.today();
            opp.StageName = 'New';
            opp.Pricebook2Id = pb.id;
            opp.AccountId = account.id;
            opp.Site__c = siteRec.id;
            opp.CBPIndicator__c = '123456789';
            insert opp;
            
            Opportunity opp_save = new Opportunity();
            opp_save.Name = 'Test Opp Onboarding Savings';
            opp_save.CloseDate = Date.today();
            opp_save.StageName = 'New';
            opp_save.Pricebook2Id = pb.id;
            opp_save.AccountId = account.id;
            opp_save.Site__c = siteRec.id;
            opp_save.CBPIndicator__c = '123456789';
            insert opp_save;
            
            Application__c app = new Application__c();
            app.Opportunity__c = opp.id;
            app.Source_of_Funds__c = 'ALLOWANCE';
			app.Source_of_Funds_Savings__c = 'ALLOWANCE';
            insert app;
            
            Application__c app2 = new Application__c();
            app2.Opportunity__c = opp_save.id;
            app2.Source_of_Funds__c = 'ALLOWANCE';
			app2.Source_of_Funds_Savings__c = 'ALLOWANCE';
            insert app2;
            
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.OpportunityId = opp.id;
            oppLineItem.Product2Id = prod.id;
            oppLineItem.PricebookEntryId = customPrice.id;
            oppLineItem.Quantity = 1;
            oppLineItem.TotalPrice = 100;
            oppLineItem.Policy_Number__c = '';
            oppLineItem.FraudSyncStatus__c = 'CLEAN';
            insert oppLineItem;
            
            OpportunityLineItem oppLineItem_save = new OpportunityLineItem();
            oppLineItem_save.OpportunityId = opp_save.id;
            oppLineItem_save.Product2Id = savingsprod.id;
            oppLineItem_save.PricebookEntryId = customPrice2.id;
            oppLineItem_save.Quantity = 1;
            oppLineItem_save.TotalPrice = 100;
            oppLineItem_save.Policy_Number__c = '';
            oppLineItem_save.FraudSyncStatus__c = 'CLEAN';
            insert oppLineItem_save;
            
            Address__c addr = new Address__c();
            addr.Shipping_Zip_Postal_Code__c = '0081';
            addr.Shipping_Street__c = 'Test';
            addr.Shipping_City__c = 'City';
            addr.Address_TYpe__c = 'Residential';
            addr.Account__c = account.Id;
            insert addr;
            
            Application_Product__c appProd = new Application_Product__c();
            appProd.Opportunity__c = opp.Id;
            appProd.Opportunity_Product_Id__c = oppLineItem.Id;
            insert appProd;
        }
    }
    
    @isTest  
    public static void testAccountsMetadataCheque() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_METADATE));
        
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
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding Cheque'];
            BranchCreateAccountController.submitAccountMetadata(opp.Id, 'Cheque');
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }

	@isTest  
    public static void testAccountsMetadataSavings() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_METADATE));
        
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
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding Savings'];
            SVcreateLinkSavingsAccount_Req_IB_v1.createDummyRequest();
            //SVcreateLinkSavingsAccount_Req_IB_v1.dummyResponse();
            BranchCreateAccountController.submitAccountMetadata(opp.Id, 'Savings');
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }

    @isTest
    public static void createAcctNumberSavings() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_METADATE));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_FRAUD_APP));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_CREATE_CHEQUE));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_CREATE_SAVE));
        
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
            Opportunity opp2 = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding Savings']; 
            String jsonRequest = '{"usePackageAccount":false,"mandateNumber":"01","openingReason":"ACC OPENED - HAS AN ACC IN ABSA","sourceOfFunds":"DONATION/GIFT","productFamily":"Savings"}';
            
            BranchCreateAccountController.getProductDetails(null, opp2.Id);
            BranchCreateAccountController.createAndLinkProductByFamily(opp2.Id, jsonRequest);
            BranchCreateAccountController.updateCIFWithAccountOpening(opp2.Id, 'BONUS', 'Savings');
			BranchCreateAccountController.productUpdateAccountOpenDetails(opp2.Id, jsonRequest);
            System.assert(opp2 != null, 'Test Successful');
            Test.stopTest();
        }
    }
    
    @isTest
    public static void createAcctNumberCheque() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_METADATE));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_FRAUD_APP));
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_CREATE_CHEQUE));
        
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
            Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Opp Onboarding Cheque'];  
            
            Application__c app = [SELECT Id FROM Application__c WHERE Opportunity__c = :opp.id];

            String jsonRequest = '{"managerNumber":"113","usePackageAccount":false,"mandateNumber":"01","openingReason":"ACC OPENED - HAS AN ACC IN ABSA","sourceOfFunds":"DONATION/GIFT","productFamily":"Cheque"}';
         
            BranchCreateAccountController.getProductDetails(app.Id, opp.Id);
            BranchCreateAccountController.createAndLinkProductByFamily(opp.Id, jsonRequest);
            BranchCreateAccountController.updateCIFWithAccountOpening(opp.Id, 'BONUS', 'Cheque'); 
            BranchCreateAccountController.productUpdateAccountOpenDetails(opp.Id, jsonRequest);
            System.assert(opp != null, 'Test Successful');
            Test.stopTest();
        }
    }
    
    @isTest
    public static void testdetermineEddLevelVL() {
        Test.startTest();
        String resp = BranchCreateAccountController.determineEddLevel('Very Low');
        System.assertEquals('VL', resp, 'Test Successful');
        Test.stopTest();
    }
    
    @isTest
    public static void testdetermineEddLevelL() {
        Test.startTest();
        String resp = BranchCreateAccountController.determineEddLevel('Low');
        System.assertEquals('L', resp, 'Test Successful');
        Test.stopTest();
    }

    @isTest
    public static void testdetermineEddLevelM() {
        Test.startTest();
        String resp = BranchCreateAccountController.determineEddLevel('Medium');
        System.assertEquals('M', resp, 'Test Successful');
        Test.stopTest();
    }
    
    @isTest
    public static void testdetermineEddLevelH() {
        Test.startTest();
        String resp = BranchCreateAccountController.determineEddLevel('High');
        System.assertEquals('H', resp, 'Test Successful');
        Test.stopTest();
    }
    
    @isTest
    public static void testdetermineEddLevelVH() {
        Test.startTest();
        String resp = BranchCreateAccountController.determineEddLevel('Very High');
        System.assertEquals('VH', resp, 'Test Successful');
        Test.stopTest();
    }
}