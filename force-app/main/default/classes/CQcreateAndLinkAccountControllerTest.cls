/**
 * @description       : CQcreateAndLinkAccountControllerTest
 * @author            : André Pietersen (IQ Business)
 * @last modified on  : 2021-08-19
 * @last modified by  : André Pietersen (IQ Business)
 * Modifications Log
 * Ver   Date         Author                          Modification
 * 1.0   2021-05-27   André Pietersen (IQ Business)   Apex PMD Compliance
 * 1.1   2021-07-26   André Pietersen (IQ Business)   Return of Fraud status if not 'CLEAN'
 * 1.2   2021-05-27   André Pietersen (IQ Business)   Added Multiple SOF
 **/
@isTest
public class CQcreateAndLinkAccountControllerTest {
	public static final String POSITIVE_RESPONSE_BODY = '{    "CQS411O": {        "outputErrorMessage": {            "creditBackdateLimit": "S",            "crditBackdateLimitA": "M",            "studiesCompleted": "",            "surechequeIndA": "M",            "studyCourseA": "P",            "riskTypeA": "M",            "shadowLimitInd": "N",            "corpCode": "ABS",            "corpSubProductA": "P",            "postGradStudent": "",            "trustS781Acct": 0,            "clientType": 101,            "corpSubProduct": "0",            "surechequeInd": "N",            "mandateNbrA": "M",            "trustS781AcctA": "P",            "repayingInd": "",            "acctOpenDate": 20210218,            "clientNameA": "P",            "studyInstitution": "000",            "unilateralLimitIndA": "M",            "studentLoanInd": "N",            "extraFinanceReqrd": "",            "nbrYearsRepeated": 0,            "studiesCompletedA": "P",            "businessAcct": 0,            "chqBookColectSiteA": "P",            "acctOpenReason": 0,            "debitBackdateLimit": "S",            "siteNameA": "P",            "shadowLimitIndA": "M",            "repaymentStartDateA": "P",            "debitBackdateLimitA": "M",            "lawSocietyRegionA": "P",            "fullTimeStudent": "",            "managerNbrA": "M",            "lowRiskHoldAmountA": "M",            "fullTimeStudentA": "P",            "clientName": "MS M ABSA TEST",            "accountName": "",            "siteName": "TEST CENTRE",            "repayingIndA": "P",            "repaymentStartDate": 0,            "acbUserA": "M",            "studentNbrA": "P",            "normalDurationA": "P",            "AccountNbrOut": "4048451239",            "acbUser": "N",            "riskType": "H",            "currentAcademicYear": 0,            "acctStoppedInd": "N",            "unilateralLimitInd": "N",            "postGradStudentA": "P",            "relatedAcctNbr": 0,            "curentAcademicYearA": "P",            "trustSweepingInd": "N",            "trustSweepingIndA": "P",            "surechequeRetention": 0,            "studyInstitutionA": "P",            "lawSocietyRegion": "",            "chqBookCollectSite": 0,            "managerNbr": 1,            "extraFinanceReqrdA": "P",            "acctOpenReasonA": "M",            "mandateNbr": 0,            "lowRiskHoldAmount": 0,            "businessAcctA": "P",            "nbrYearsRepeatedA": "P",            "normalDuration": 0,            "studentNbr": "",            "sicCode": 0,            "acctStoppedIndA": "M",            "accountNameA": "M",            "finalYear": "",            "studyCourse": "",            "finalYearA": "P",            "surechequeRetentionA": "M",            "acctOpenDateA": "M"        }    },    "NBSAPDPO": {        "outputErrorHeaders": {            "returnCode": 0,            "outputServiceVersion": "BUSO002",            "reasonCode": 0        }    },    "MSGO": {        "NBSMSGO3": {            "NBNMSGO3_NBR_USER_ERRS": 0,            "NBSMSGO3_VERSION": "",            "NBNMSGO3_SYS_ERR_TXT": "",            "NBNMSGO3_NBR_USER_MSGS": 0,            "NBNMSGO3_MSG_ENTRY": [                {                    "NBNMSGO3_MSG_ERR_IND": "",                    "NBNMSGO3_MSG_TXT": "",                    "NBNMSGO3_MSG_CLASS": "",                    "NBNMSGO3_MSG_CODE": ""                },                {                    "NBNMSGO3_MSG_ERR_IND": "",                    "NBNMSGO3_MSG_TXT": "",                    "NBNMSGO3_MSG_CLASS": "",                    "NBNMSGO3_MSG_CODE": ""                },                {                    "NBNMSGO3_MSG_ERR_IND": "",                    "NBNMSGO3_MSG_TXT": "",                    "NBNMSGO3_MSG_CLASS": "",                    "NBNMSGO3_MSG_CODE": ""                },                {                    "NBNMSGO3_MSG_ERR_IND": "",                    "NBNMSGO3_MSG_TXT": "",                    "NBNMSGO3_MSG_CLASS": "",                    "NBNMSGO3_MSG_CODE": ""                },                {                    "NBNMSGO3_MSG_ERR_IND": "",                    "NBNMSGO3_MSG_TXT": "",                    "NBNMSGO3_MSG_CLASS": "",                    "NBNMSGO3_MSG_CODE": ""                }            ]        }    }}';
	public static final String POSITIVE_RESPONSE_BODY_2 = '{    "status": "SUCCESSFUL",    "content": {        "fraudStatus": "CLEAN",        "applicationNumber": "202101271406447219",        "channelReference": ""    },    "links": []}';
	public static final String POSITIVE_RESPONSE_BODY_3 = '{    "status": "SUCCESSFUL",    "errors": null,    "data": "Meta data successfully updated",    "links": []}';

	@testSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CQcreateAndLinkAccountV9_IH_v1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ FraudSyncApplication_IH_V1.INTEGRATION_SERVICE_NAME }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ AccountsMetadata_IH_v1.INTEGRATION_SERVICE_NAME });
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
			Product2 prod = new Product2(Name = 'Cheque Product', Family = 'Cheque', ProductCode = '11021');
			insert prod;

			Pricebook2 pb = new Pricebook2();
			pb.IsActive = true;
			pb.id = test.getStandardPricebookId();
			update pb;

			PricebookEntry customPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
			insert customPrice;

			Account account = new Account();
			account.ID_Number__pc = '9308305015082';
			account.FirstName = 'TestCVSServicesHelper';
			account.LastName = 'Tester';
			account.Gender__pc = 'Male';
			account.Next_of_Kin_Last_Name__pc = 'Testing';
			account.Next_of_Kin_First_Name_s__pc = 'Testing';
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
			insert account;

			site__c siteRec = new site__c();
			siteRec.Site_Code__c = '1334';
			siteRec.Name = 'Test';
			insert siteRec;

			Opportunity opp = new Opportunity();
			opp.Name = 'Test Cheque Onboarding';
			opp.CloseDate = Date.today();
			opp.StageName = 'New';
			opp.Pricebook2Id = pb.id;
			opp.AccountId = account.id;
			opp.Site__c = siteRec.id;
			opp.CBPIndicator__c = '123456789';
			insert opp;

			Opportunity opp_no_acc = new Opportunity();
			opp_no_acc.Name = 'Test Cheque Onboarding NO ACCOUNT';
			opp_no_acc.CloseDate = Date.today();
			opp_no_acc.StageName = 'New';
			opp_no_acc.Pricebook2Id = pb.id;
			opp_no_acc.AccountId = account.id;
			opp_no_acc.Site__c = siteRec.id;
			opp_no_acc.CBPIndicator__c = '123456789';
			insert opp_no_acc;

			Application__c app = new Application__c();
			app.Opportunity__c = opp.id;
			app.Source_of_Funds__c = 'ALLOWANCE';
			insert app;

			Application__c app1 = new Application__c();
			app1.Opportunity__c = opp_no_acc.id;
			app1.Source_of_Funds__c = 'ALLOWANCE';
			insert app1;

			OpportunityLineItem oppLineItem = new OpportunityLineItem();
			oppLineItem.OpportunityId = opp.id;
			oppLineItem.Product2Id = prod.id;
			oppLineItem.PricebookEntryId = customPrice.id;
			oppLineItem.Quantity = 1;
			oppLineItem.TotalPrice = 100;
			oppLineItem.Policy_Number__c = '12345678901';
			oppLineItem.FraudSyncStatus__c = 'CLEAN';
			insert oppLineItem;

			OpportunityLineItem oppLineItem2 = new OpportunityLineItem();
			oppLineItem2.OpportunityId = opp_no_acc.id;
			oppLineItem2.Product2Id = prod.id;
			oppLineItem2.PricebookEntryId = customPrice.id;
			oppLineItem2.Quantity = 1;
			oppLineItem2.TotalPrice = 100;
			oppLineItem2.Policy_Number__c = '';
			oppLineItem2.FraudSyncStatus__c = 'CLEAN';
			insert oppLineItem2;

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

			Application_Product__c appProd2 = new Application_Product__c();
			appProd2.Opportunity__c = opp_no_acc.Id;
			appProd2.Opportunity_Product_Id__c = oppLineItem2.Id;
			insert appProd2;

			Payment_Plan__c paymentPlan = new Payment_Plan__c();
			paymentPlan.Account_Holder_Name__c = 'A69E00000I0vGaQAJ';
			paymentPlan.Account_Type__c = 'Cheque';
			paymentPlan.Bank_Name__c = 'ABSA';
			paymentPlan.Method__c = 'Cheque';
			paymentPlan.Status__c = 'New';

			insert paymentPlan;
		}
	}

	@isTest
	static void createChequeAccountExistingAccountNumberTest() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
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

		CreateRetailAccountCommon common = new CreateRetailAccountCommon();
		common.paymentPlanId = '';
		common.usePackageAccount = false;
		common.sourceOfFunds = 'BONUS';
		common.productFamily = 'Cheque';
		common.fraudIndicator = 'N';
		common.fraudStatus = 'CLEAN';
		common.applicationNumber = '202107251308319876';

		Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Cheque Onboarding' LIMIT 1];
		System.runAs(au) {
			Test.startTest();
			CQcreateAndLinkAccountController.callCQcreateAcct(opportunity.Id, common);
			System.assert(opportunity != null, 'Test Successful');
			Test.stopTest();
		}
	}
	@isTest
	public static void createAcctNumberForCQ() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_3));
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_2));
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

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

		CreateRetailAccountCommon common = new CreateRetailAccountCommon();
		common.paymentPlanId = '';
		common.usePackageAccount = false;
		common.sourceOfFunds = 'BONUS';
		common.productFamily = 'Cheque';
		common.fraudIndicator = 'N';
		common.fraudStatus = 'CLEAN';
		common.applicationNumber = '202107251308319876';
		common.accountName = 'TESTING';
		common.openingReason = '';
		common.managerNumber = '13';
		common.mandateNumber = '113';

		Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Cheque Onboarding NO ACCOUNT' LIMIT 1];
		System.runAs(au) {
			Test.startTest();
			CQcreateAndLinkAccountController.callCQcreateAcct(opportunity.Id, common);
			CQcreateAndLinkAccountController.chequeUpdateAccountOpenDetails(opportunity.Id, common);
			System.assert(opportunity != null, 'Test Successful');
			Test.stopTest();
		}

	}

	@isTest
	public static void createAcctNumberForCQusePackageAccount() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_3));
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY_2));
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

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

		Payment_Plan__c paymentPlan = [SELECT Id FROM Payment_Plan__c WHERE Account_Holder_Name__c = 'A69E00000I0vGaQAJ' LIMIT 1];

		CreateRetailAccountCommon common = new CreateRetailAccountCommon();
		common.paymentPlanId = paymentPlan.Id;
		common.usePackageAccount = true;
		common.sourceOfFunds = 'BONUS';
		common.productFamily = 'Cheque';
		common.fraudIndicator = 'N';
		common.fraudStatus = 'CLEAN';
		common.applicationNumber = '202107251308319876';
		common.accountName = 'TESTING';
		common.openingReason = '';
		common.managerNumber = '13';
		common.mandateNumber = '113';

		Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Cheque Onboarding NO ACCOUNT' LIMIT 1];
		System.runAs(au) {
			Test.startTest();
			CQcreateAndLinkAccountController.callCQcreateAcct(opportunity.Id, common);
			CQcreateAndLinkAccountController.chequeUpdateAccountOpenDetails(opportunity.Id, common);
			System.assert(opportunity != null, 'Test Successful');
			Test.stopTest();
		}

	}

	@isTest
	public static void testdetermineEddLevelVL() {
		Test.startTest();
		String resp = CQcreateAndLinkAccountController.determineEddLevel('Very Low');
		System.assertEquals('VL', resp, 'Test Successful');
		Test.stopTest();
	}

	@isTest
	public static void testdetermineEddLevelL() {
		Test.startTest();
		String resp = CQcreateAndLinkAccountController.determineEddLevel('Low');
		System.assertEquals('L', resp, 'Test Successful');
		Test.stopTest();
	}
	@isTest
	public static void testdetermineEddLevelM() {
		Test.startTest();
		String resp = CQcreateAndLinkAccountController.determineEddLevel('Medium');
		System.assertEquals('M', resp, 'Test Successful');
		Test.stopTest();
	}

	@isTest
	public static void testdetermineEddLevelH() {
		Test.startTest();
		String resp = CQcreateAndLinkAccountController.determineEddLevel('High');
		System.assertEquals('H', resp, 'Test Successful');
		Test.stopTest();
	}

	@isTest
	public static void testdetermineEddLevelVH() {
		Test.startTest();
		String resp = CQcreateAndLinkAccountController.determineEddLevel('Very High');
		System.assertEquals('VH', resp, 'Test Successful');
		Test.stopTest();
	}
}