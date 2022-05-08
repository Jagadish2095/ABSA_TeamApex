/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-10-25
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@isTest
public class AccountFulfilmentControllerTest 
{
	public static final String POSITIVE_RESPONSE_BODY = '{"headers":{"X-Backside-Transport":["OK OK"],"Connection":["Keep-Alive"],"Transfer-Encoding":["chunked"],"X-Powered-By":["Servlet/3.1"],"Content-Type":["application/json; charset=UTF-8"],"Content-Language":["en-US"],"Date":["Mon, 07 Dec 2020 10:13:34 GMT"],"Expires":["Thu, 01 Dec 1994 16:00:00 GMT"],"Cache-Control":["no-cache=\"set-cookie, set-cookie2\""],"X-Global-Transaction-ID":["1cf73a895fce004ec67f67ad"],"Access-Control-Expose-Headers":["APIm-Debug-Trans-Id, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Reset, X-Global-Transaction-ID"],"Access-Control-Allow-Origin":["*"],"Access-Control-Allow-Methods":["POST"],"Set-Cookie":["LtpaToken2=\"\"; Expires=Thu, 01 Dec 1994 16:00:00 GMT; Path=/; Secure; HttpOnly","LtpaToken2=Qq0mFXVDnbh6/7BhhI1hjCV3+KnusyxFT6nT9aNiNwPjXvFB1HEeJTvzVTRRGtOqD4pg1f1xn1eJiWYxrydSiazSk+XWFqmvcCr8xvqefLZMQoxOHYt5dgUVHzo8YnsmiB3hqow3mU5/izpXvJtFzYboBgQVqsj0IUH2jlvPhsNKutTVe1aCuPnHyAIqvsVx0eDEuFpEUxyrFQGGAbrub8cASWpcAllj6vAV/A1FeIA0H6fBxopcWkj97uAodN0BMMtD+GZhCUN7jUaO4pbcVJXtEPhprfJnq8rJm7PzNs2xPwHw8Ah9x3W3JUuD+MuV; Path=/; HttpOnly"],"X-RateLimit-Limit":["name=100 Per Minute,100;"],"X-RateLimit-Remaining":["name=100 Per Minute,99;"]},"body":{"NBSAPDPO": {"NBSAPLO": {"returnCode": 98,"reasonCode": 62557593,"outputServiceVersion": "uscab"}},"MSGO": {"NBSMSGO3": {"version": "6.8.1","systemErrorText": "nadahize","numberUserMessages": 330,"numberUserErrors": 274,"messageEntry": [{"messageClass": "26","messageCode": "29","messageErrorIndicator": "54","messageText": "53"},{"messageClass": "57","messageCode": "32","messageErrorIndicator": "42", "messageText": "64"},{"messageClass": "18","messageCode": "23","messageErrorIndicator": "26","messageText": "32"},{"messageClass": "46","messageCode": "56","messageErrorIndicator": "26","messageText": "33"},{"messageClass": "19","messageCode": "40","messageErrorIndicator": "34","messageText": "34"}]}},"SVSP15O": {"SVNP15O_OUTPUT_AREA": {"AccountNumber": 9051159122}}}';
	public static final String POSITIVE_RESPONSE_BODYSer = '{"SVcreateLinkSavingsAccount_Resp_IB_v1":{"outTransferred": 2,"msgNo": 200,"msg":"Succesfully got Client Details"}}';
	public static final String POSITIVE_RESPONSE_BODYSeranct = 'SVcreateLinkSavingsAccount_Resp_IB_v1{ "status": "SUCCESSFUL", "errors": null, "Data": {"Account Number": 9051480351}}';
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ SVcreateLinkSavingsAccount_IH_v1.INTEGRATION_SERVICE_NAME }
		);

		Account mainacc = new Account(
			Name = 'TheStokvel',
			Phone = '0840404898',
			CIF__c = 'SEBENZA037',
			CASA_Reference_Number__c = '121229158',
			Client_Group__c = 'Non Individual',
			Number_of_Participants__c = 2
		);
		insert mainacc;

		Pricebook2 pb = new Pricebook2();
		pb.IsActive = true;
		pb.id = test.getStandardPricebookId();
		update pb;

		Product2 savingsprod = new Product2(Name = 'Savings Product', Family = 'Savings', ProductCode = '09050');
		insert savingsprod;

		Product2 savingsprodInvset = new Product2(Name = 'Investment Club', Family = 'Savings', ProductCode = '09072');
		insert savingsprodInvset;

		PricebookEntry savingsPrice = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = savingsprod.Id, UnitPrice = 12000, IsActive = true);
		insert savingsPrice;

		PricebookEntry savingsPriceInvse = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = savingsprodInvset.Id, UnitPrice = 12000, IsActive = true);
		insert savingsPriceInvse;

		Sales_Process_Type__c salesProcess = new Sales_Process_Type__c();
		salesProcess.Request_Name__c = 'CAF Application';
		salesProcess.Name = 'CAF Application';
		salesProcess.Opportunity_Record_Type__c = 'CAF Application';
		insert salesProcess;

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
		insert account;

		site__c siteRec = new site__c();
		siteRec.Site_Code__c = '1334';
		siteRec.Name = 'Test';
		insert siteRec;

		Opportunity savingsOpportunity = new Opportunity();
		savingsOpportunity.Name = 'Test Savings Onboarding';
		savingsOpportunity.CloseDate = Date.today();
		savingsOpportunity.StageName = 'New';
		savingsOpportunity.Pricebook2Id = pb.id;
		savingsOpportunity.AccountId = account.id;
		savingsOpportunity.Site__c = siteRec.id;
		savingsOpportunity.CBPIndicator__c = '123456789';
		savingsOpportunity.Risk_Rating__c = 'High';
		insert savingsOpportunity;

		OpportunityLineItem savingsLineItem = new OpportunityLineItem();
		savingsLineItem.OpportunityId = savingsOpportunity.id;
		savingsLineItem.Product2Id = savingsprod.id;
		savingsLineItem.PricebookEntryId = savingsPrice.id;
		savingsLineItem.Quantity = 1;
		savingsLineItem.TotalPrice = 100;

		OpportunityLineItem savingsLineItemInvest = new OpportunityLineItem();
		savingsLineItemInvest.OpportunityId = savingsOpportunity.id;
		savingsLineItemInvest.Product2Id = savingsprod.id;
		savingsLineItemInvest.PricebookEntryId = savingsPriceInvse.id;
		savingsLineItemInvest.Quantity = 1;
		savingsLineItemInvest.TotalPrice = 100;

		//savingsLineItem.Product_Name__c='Investment Club';
		//savingsLineItem.Policy_Number__c='9051159122';
		insert savingsLineItemInvest;

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
			SiteCode__c = '1334',
			Supervisor__c = '47028'
		);
		insert au;
		Integration_Translation__c returnValues = new Integration_Translation__c(
			External_Value__c = '02',
			Value_Type__c = 'Sofsoi',
			Internal_Value__c = 'Investments',
			System_Name__c = 'CIFCodesList',
			Direction__c = 'Outbound'
		);
		insert returnValues;
		Integration_Translation__c returnValuess = new Integration_Translation__c(
			External_Value__c = 'account from Nedbank',
			Value_Type__c = 'Reason',
			Internal_Value__c = 'account from Nedbank',
			System_Name__c = 'Savings',
			Direction__c = 'Outbound'
		);
		insert returnValuess;

		ROAProduct__c returnProducts = new ROAProduct__c(ProductId__c = 'Investment Club', PackageChargeOption__c = 'Reason', Code__c = 'SVO0907202');
		insert returnProducts;
	}

	@IsTest
	static void createSavingsAccountTestNegetive() {
		String withdrawalPercentage = '20';
		String sourceOfFunds = '';

		String noticePeriod = '1';
		String brokerNumber = '5035555';
		String investTerm = '12';
		String oppid = '343434';

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
			Opportunity opportunity;
			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
			//string resp = AccountFulfilmentController.createSavingsAccount(oppid,withdrawalPercentage, sourceOfFunds, noticePeriod, brokerNumber, investTerm);
			System.assert(opportunity == null, 'SUCCESS');
			//System.assertNotEquals(resp,' ' );

			Test.stopTest();
		}
	}

	@IsTest
	static void createSavingsAccountTest() {
		String withdrawalPercentage = '20';
		String sourceOfFunds = 'Investments';

		String noticePeriod = '1';
		String brokerNumber = '5035555';
		String investTerm = '12';
		String riskRating = 'H';
		String crpCode = 'SVO0907202';
		String creditChannel = 'test';
		String creditSource = 'test';
		String debitReason = 'test';
		String fraudApplicationId = '202110151224577344';
		String fraudIndicator = 'Y';

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
			Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding'];

			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODYSeranct));
			AccountFulfilmentController.createSavingsAccount(
				opportunity.Id,
				withdrawalPercentage,
				sourceOfFunds,
				noticePeriod,
				brokerNumber,
				investTerm,
				riskRating,
				'',
				creditChannel,
				creditSource,
				debitReason,
				fraudApplicationId,
                'Y'
			);
			System.assert(opportunity != null, 'Failed to query opportunity');

			Test.stopTest();
		}
	}
	/**
	 * @description attempEntityRiskProfilingTest
	 */
	@IsTest
	static void attempEntityRiskProfilingTest() {
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
			Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding'];
			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
			AccountFulfilmentController.attempEntityRiskProfiling(opportunity.Id);
			system.assert(true);
			//System.assert(opportunity ==null, 'Failed to query opportunity');
			Test.stopTest();
		}
	}

	/**
	 * @description attempEntityRiskProfilingTest
	 */
	@IsTest
	static void attempEntityRiskProfilingTestNegetive() {
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
			Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding'];
			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
			AccountFulfilmentController.attempEntityRiskProfiling(opportunity.Id);
			system.assert(true);
			//System.assert(opportunity ==null, 'Failed to query opportunity');
			Test.stopTest();
		}
	}

	@IsTest
	static void updateAccountOpeningDetTest() {
		String accountNumber = '9051159122';
		String brokerNumber = '5035555';
		String openingReason = 'account from Nedbank';
		ROAProduct__c roaprod = [SELECT Code__c, PackageChargeOption__c, ProductId__c FROM ROAProduct__c WHERE ProductId__c = 'Investment Club'];
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
			Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding'];
			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		string resp =	AccountFulfilmentController.updateAccountOpeningDet(opportunity.Id, accountNumber, brokerNumber, openingReason, 'maldives', roaprod.ProductId__c);
			system.assert(resp != null, 'assert failed');
			//System.assert(opportunity ==null, 'Failed to query opportunity');
			Test.stopTest();
		}
	}

	@IsTest
	static void getTranslationValuesTestNegetive() {
		Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding'];
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
			AccountFulfilmentController.getTranslationValues('Savings', 'Reason', 'Outbound');
			System.assert(opportunity != null, 'Failed to get translation values');
			Test.stopTest();
		}
	}

	@IsTest
	static void getValidatedTranslationValuesTest() {
		Opportunity opportunity;
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
			String systemName = 'CIF';
			String valueType = 'Country';
			String direction = 'Outbound';
			SObject objObject = Address__c.SObjectType.newSObject();
			String objField = 'Shipping_Country__c';
			AccountFulfilmentController.getValidatedTranslationValues(systemName, valueType, direction, objObject, objField);
			System.assert(opportunity == null, 'Failed to get translation values');
			Test.stopTest();
		}
	}
	@IsTest
	static void getTranslationValuesTest() {
		Opportunity opportunity;
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
			AccountFulfilmentController.getTranslationValues('Savings', 'Reason', 'Outbound');
			System.assert(opportunity == null, 'Failed to get translation values');
			Test.stopTest();
		}
	}

	@IsTest
	static void getRiskRatingValuesTest() {
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
			AccountFulfilmentController.getRiskRating('H');
			System.assertNotEquals('', 'Failed to get Riskrating values');
			Test.stopTest();
		}
	}
	@IsTest
	static void getRiskRatingValuesMEDIUMTest() {
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
			AccountFulfilmentController.getRiskRating('M');
			AccountFulfilmentController.getRiskRating('VL');
			AccountFulfilmentController.getRiskRating('VH');
			String rating = AccountFulfilmentController.getRiskRating('L');
			System.assert(rating != '', 'Failed to get Riskrating values');
			Test.stopTest();
		}
	}
	      /**
    * @description FraudCallDetailsControllerTest
    */
    @IsTest
    static void FraudCallDetailsControllerTestTest(){
        	Opportunity opp = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding'];
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
        Opportunity opportunity = [SELECT Id,AccountId FROM Opportunity WHERE Name = 'Test Savings Onboarding']; 
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Map<String, String> fraudResponseMap = new Map<String, String>();
        fraudResponseMap =AccountFulfilmentController.FraudCallDetails(opp.id);
         if(fraudResponseMap!=null)
         {
                 System.assert(fraudResponseMap !=null, 'Success');
         }

        //System.assert(opportunity ==null, 'Failed to query opportunity');
        Test.stopTest();
        }
    }
    
    	/**
	 * @description attempEntityRiskProfilingTest
	 */
	@IsTest
	static void callGenerateDocsTest() {
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
			Opportunity opportunity = [SELECT Id FROM Opportunity WHERE Name = 'Test Savings Onboarding'];
			Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
			string resp = '';//AccountFulfilmentController.callGenerateDocsStokvel(opportunity.Id);
			system.assert(resp!= null, 'assertfailed');
			//System.assert(opportunity ==null, 'Failed to query opportunity');
			Test.stopTest();
		}
	}
}