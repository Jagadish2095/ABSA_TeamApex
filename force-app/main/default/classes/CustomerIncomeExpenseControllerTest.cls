/**
 * @description Test Coverage for CustomerIncomeExpenseController
 * @author Aaron Castelyn: Absa
 * @created 2021-01-11
 */

@isTest
public class CustomerIncomeExpenseControllerTest {
	public static final String POSITIVE_RESPONSE_BODY = '{"applyResponse":{"return":{"application":{"annualCreditLimitIncreases":false,"applicationNumber":102010080131011579,"applicationType":"P","campaignId":0,"cardProdSubProdGroupId":0,"channelCode":"B","consents":{"deaConsent":false},"corpCode":"ABSA","creditLifeRequired":false,"creditLimitApproved":0,"creditLimitSelected":0,"creditStatus":{"description":"Pre-Scoring Approved","id":"08"},"dateCreated":"2020-10-08T01:31:01.999+02:00","debitOrderDetails":null,"externalConsumerData":{"customerId":9407229216088,"customerSourceCode":"ABSA","customerSourceReferenceNumber":"THIS IS A TEST3"},"hasAcceptedCourierCollectionFee":false,"hasAcceptedSpecifiedCreditLimit":false,"knockOutQuestions":{"absaRewards":false,"casaClauseRead":true,"creditBureauConsent":false,"creditLifeTermsAndConditionsRead":false,"curatorship":false,"currentlyUnderDebtCounselling":false,"debitOrderByPass":false,"declaredInsolvent":false,"monthlyGrossIncomeAboveMin":false,"olderThan18Years":false,"pendingDebtCounselling":false,"permanentSAResident":false,"registeredForeingTax":false,"rehabilitation":{"everBeenDeclaredInsolvent":false,"everUndergoneDebtCounselling":false},"spouseConsent":false,"termsAndConditionsRead":true},"linkedAccountSelected":null,"lockVersionId":43678,"lowValuePaymentRequired":false,"marketingSiteId":4592,"numberOfSecondaryApplicantsRequested":0,"packageId":null,"personWhoCreatedApplication":"ABAJ013","pinOptionSelected":null,"primaryApplicant":{"cardCollection":null,"cardProdSubProdGroupId":0,"casaInformation":{"referenceNumber":0,"versionNumber":0},"cellPhoneNumber":{"countryCode":null,"extension":null,"number":"0725845698"},"emailAddress":null,"employer":{"address":null,"name":null},"expense":null,"familyStatus":{"maritalStatus":0,"numberOfDependents":0},"financialInformationSuppliedCorrect":false,"firstNames":"FABIAN GERONE","hasSocialGrant":false,"homeFaxNumber":null,"homeTelephoneNumber":null,"idOrRegistrationNo":"9407229216088       ","identificationType":"01","income":{"disposableMonthlyIncome":0,"grossMonthlyIncome":0,"grossMonthlySalary":0,"nettMonthlyIncome":0,"otherIncome":{"amount":0}},"incomeTaxNumber":0,"initials":"FG        ","isInBusinessRescueAffectedParty":false,"marketingConsentGiven":false,"mayCheckCreditWorthiness":false,"mayReceiveMarketingViaEmail":false,"mayReceiveMarketingViaPost":false,"mayReceiveMarketingViaSMS":false,"mayReceiveMarketingViaTelephone":false,"nextOfKin":null,"postalAddress":null,"preAssessed":{"preAssessedGrossIncome":90000,"preTmrNettIncome":70000,"preAssessedGrossIncomeAccepted":true},"qualification":{"hasPostMatricQualification":false},"residentialAddress":null,"shareInfoWithCreditProviders":false,"sourceOfIncome":0,"surname":"PALADI","tempPermitNumber":0,"titleType":"01","workFaxNumber":null,"workTelephoneNumber":null},"productGroupId":1,"quote":null,"statementDeliveryMethodSelected":null,"statusGroup":1},"responseCommons":{"messageTimeStamp":"2020-10-08T01:31:09.325+02:00","success":"TRUE"}}}}';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CCApplicationService_apply_IH_v1.INTEGRATION_SERVICE_NAME }
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
			Advisor_Code__c = '112233'
		);
		insert au;
	}

	@isTest
	static void testGetApplication() {
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
			Account a = createTestAccount();
			Opportunity o = createTestOpportunity(a.id);

			Application__c app = CustomerIncomeExpenseController.GetApplication(a.id, o.Id);

			System.assert(app != null, 'GetApplication has a value');
		}
	}

	@isTest
	static void testIncomeExpense() {
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
			Account a = createTestAccount();
			Opportunity o = createTestOpportunity(a.id);

			Application__c app = CustomerIncomeExpenseController.GetApplication(a.id, o.Id);

			string si = CustomerIncomeExpenseController.GetIncome(app.Id);

			system.assert(si.length() > 0, 'Received an income value');

			CustomerIncomeExpenseController.saveIncome(si);

			Application_Income_and_Expense__c income = CustomerIncomeExpenseController.GetRecord(app.Id, 'Monthly Income', 'Gross Income');

			system.assert(income != null, 'Have income value');

			string se = CustomerIncomeExpenseController.GetDebtExpenses(app.Id);

			System.assert(se.length() > 0, 'Have expenses');

			CustomerIncomeExpenseController.saveDebtExpenses(se);

			Application_Income_and_Expense__c expense = CustomerIncomeExpenseController.GetRecord(app.Id, 'Fixed Debt', 'Asset Payment');

			system.assert(expense != null, 'Have expense result');

			string sle = CustomerIncomeExpenseController.GetLivingExpenses(app.Id);

			System.assert(sle.length() > 0, 'Have living expenses');

			CustomerIncomeExpenseController.saveLivingExpenses(sle);

			Application_Income_and_Expense__c livingExpense = CustomerIncomeExpenseController.GetRecord(app.id, 'Living Expenses', 'Household Expense');

			system.assert(livingExpense != null, 'Have living expense result');

			Double d = CustomerIncomeExpenseController.GetIncomeLeft(app.Id);

			system.assert(d >= 0, 'Have income left');
		}
	}

	@isTest
	static void testApplyClientUpdate() {
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

			Account acc = createTestAccount();
			Application__c app = CreateTestApplication(acc.id);

			createTestResidentialAddress(acc.id);
			createTestPostalAddress(acc.id);

			CreateTestProduct(acc.id, app.id);

			try {
				CCApplicationService_CltUpdate_Req_IB_v1 requestBean = CCApplicationService_CltUpdate_Req_IB_v1.createDummyRequest();

				string response = CustomerIncomeExpenseController.ApplyClientUpdate(app.id, '102107151416305567');

				System.assert(response != null, 'ClientUpdate result');
			} catch (Exception ex) {
				String s = ex.getMessage();

				System.assert(s.length() > 0, 'Have an error');
			}

			Test.stopTest();
		}
	}

	@isTest
	static void testApplyFinalScoring() {
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

			Account acc = createTestAccount();
			Application__c app = CreateTestApplication(acc.id);

			createTestEmployerAddress(acc.id);

			CreateTestIncomeExpense(app.id, 'Monthly Income', 'Other Income');
			CreateTestIncomeExpense(app.id, 'Monthly Income', 'Gross Income');
			CreateTestIncomeExpense(app.id, 'Monthly Income', 'Net Income');
			CreateTestIncomeExpense(app.id, 'Monthly Income', 'Rental Income');
			CreateTestIncomeExpense(app.id, 'Monthly Income', 'Other');
			CreateTestIncomeExpense(app.id, 'Monthly Income', 'Bank Statements Consent');

			CreateTestIncomeExpense(app.id, 'Fixed Debt', 'Asset Payment');
			CreateTestIncomeExpense(app.id, 'Fixed Debt', 'Credit Payment');
			CreateTestIncomeExpense(app.id, 'Fixed Debt', 'Loan Payment');
			CreateTestIncomeExpense(app.id, 'Fixed Debt', 'Homeloan Payment');
			CreateTestIncomeExpense(app.id, 'Fixed Debt', 'Retail Payment');
			CreateTestIncomeExpense(app.id, 'Fixed Debt', 'Joint Responsible');

			CreateTestIncomeExpense(app.id, 'Living Expenses', 'Household Expense');
			CreateTestIncomeExpense(app.id, 'Living Expenses', 'Fuel Expense');
			CreateTestIncomeExpense(app.id, 'Living Expenses', 'Education Fee');
			CreateTestIncomeExpense(app.id, 'Living Expenses', 'Insurance Polices');
			CreateTestIncomeExpense(app.id, 'Living Expenses', 'Maintenance Expense');
			CreateTestIncomeExpense(app.id, 'Living Expenses', 'Rent');
			CreateTestIncomeExpense(app.id, 'Living Expenses', 'Other Amount');

			Test.startTest();

			string response = CustomerIncomeExpenseController.ApplyFinalScoring(app.id, '', '', '', '');

			System.assert(response != null, 'FinalScoring result');

			Test.stopTest();
		}
	}

	@isTest
	static void testApplyQuoteAccept() {
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

			Account acc = createTestAccount();
			Application__c app = CreateTestApplication(acc.id);

			string response = CustomerIncomeExpenseController.ApplyQuoteAccept(app.id, '', '', '', '');

			System.assert(response != null, 'ApplyQuoteAccept result');

			Test.stopTest();
		}
	}

	/**
	 * @description createTestAccount
	 * @return Account
	 */
	public static Account createTestAccount() {
		Account acc = new Account();

		acc.FirstName = 'Test';
		acc.LastName = 'Account';
		acc.PersonEmail = 'test@account.com';
		acc.PersonMobilePhone = '0123456789';
		acc.ID_Number__pc = '8412117626084';
		acc.PersonBirthdate = Date.valueOf('1984-12-11');
		acc.Titles__pc = 'Mr';
		acc.CIF__c = 'TESTCUST01';
		acc.Next_of_Kin_Cellphone_Number__pc = '0123456789';
		acc.Next_of_Kin_Telephone_Number__pc = '0123456789';

		insert acc;

		return acc;
	}

	/**
	 * @description createTestOpportunity
	 * @param accountId
	 * @return Opportunity
	 */
	public static Opportunity createTestOpportunity(Id accountId) {
		Opportunity o = new Opportunity();

		o.Name = 'DummyOpportunity';
		o.AccountId = accountId;
		o.Amount = 10000;
		o.CloseDate = Date.today().addDays(5);
		o.StageName = 'Prospecting';

		insert o;

		return o;
	}

	/**
	 * @description createTestApplication
	 * @param accountId
	 * @return Application__c
	 */
	private static Application__c createTestApplication(Id accountId) {
		Application__c app = new Application__c();

		app.Account__c = accountId;

		insert app;

		return app;
	}

	/**
	 * @description createTestResidentialAddress
	 * @param accountId
	 */
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

	/**
	 * @description createTestPostalAddress
	 * @param accountId
	 */
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

	/**
	 * @description createTestEmployerAddress
	 * @param accountId
	 */
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

	/**
	 * @description createTestProduct
	 * @param accountId
	 * @param applicationId
	 */
	private static void createTestProduct(Id accountId, Id applicationId) {
		//Create Product and Price Book
		Product2 p = new Product2();

		p.Name = 'Test';
		p.ProductCode = '11032';
		p.Price_Scheme_Code__c = 'CQT01S48';
		p.IsActive = true;

		insert p;

		PriceBookEntry pbe = new PriceBookEntry();

		pbe.UnitPrice = 1;
		pbe.Pricebook2Id = Test.getStandardPricebookId();
		pbe.Product2Id = p.Id;
		pbe.IsActive = true;

		insert pbe;

		//Create Opportunity
		Opportunity opp = new Opportunity();

		opp.accountId = accountId;
		opp.Name = 'Test';
		opp.StageName = 'Registration';
		opp.CloseDate = System.today() + 1;
		opp.PriceBook2Id = Test.getStandardPricebookId();

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

	/**
	 * @description createTestIncomeExpense
	 * @param applicationId
	 * @param category
	 * @param expenseValue
	 */
	private static void createTestIncomeExpense(Id applicationId, string category, string expenseValue) {
		Application_Income_and_Expense__c result = new Application_Income_and_Expense__c();

		result.Application__c = applicationId;
		result.Category__c = category;
		result.Expense_Value__c = expenseValue;
		result.Applicant_Value__c = 0;

		insert result;
	}
}