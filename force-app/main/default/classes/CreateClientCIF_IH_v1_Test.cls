/**
 * @description Test Class for CreateClientCIF
 * @ updated 5/19/2021
 */

@isTest
public class CreateClientCIF_IH_v1_Test {
	/****************************************************************** INDIVIDUAL ************************************************************************/
    /**
	 * @description Positive
	 */
	@isTest
	static void testCreateClientIndividualPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Individual';
		createEmployersAddress(testDataFactory.testAccount);
		createPhysicalEmployersAddress(testDataFactory.testAccount);
		createBusinessAddress(testDataFactory.testAccount);
		createPostalAddress(testDataFactory.testAccount);
		testDataFactory.testAccount.Non_Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Non_Credit_Marketing_Consent__pc = 'Yes';
		testDataFactory.testAccount.Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Credit_Marketing_Consent__pc = 'Yes';
		testDataFactory.testAccount.Name = 'Test Name';
		testDataFactory.testAccount.Income_Tax_Number__pc = '1234';
		testDataFactory.testAccount.PersonHomePhone = '0112223344';
		testDataFactory.testAccount.MiddleName = 'Test';
		testDataFactory.testAccount.Home_Language__pc = 'English';
		testDataFactory.testAccount.FirstName = 'test1';

        System.assert(testDataFactory.testAccount != null);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createIndividualClient(
			testDataFactory.testAccount,
			'WILLS',
			UserInfo.getUserId(),
			'Individual Client',
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		Test.stopTest();

		//System.assertEquals(200, responseBean.statusCode);
	}

	//Positive
	@isTest
	static void testCreateClientRBBIndividualPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Individual';
		createEmployersAddress(testDataFactory.testAccount);
		createPhysicalEmployersAddress(testDataFactory.testAccount);
		createBusinessAddress(testDataFactory.testAccount);
		createPostalAddress(testDataFactory.testAccount);
		testDataFactory.testAccount.Non_Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Non_Credit_Marketing_Consent__pc = 'Yes';
		testDataFactory.testAccount.Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Credit_Marketing_Consent__pc = 'Yes';
		testDataFactory.testAccount.Name = 'Test Name';
		testDataFactory.testAccount.Income_Tax_Number__pc = '1234';
		testDataFactory.testAccount.PersonHomePhone = '0112223344';
		testDataFactory.testAccount.MiddleName = 'Test';
		testDataFactory.testAccount.Home_Language__pc = 'English';
		testDataFactory.testAccount.FirstName = 'test1';
		testDataFactory.testAccount.Source_of_Income__c = 'Salary';
		testDataFactory.testAccount.Income_Tax_Number__c = '324325';
		testDataFactory.testAccount.Date_Identified__c = System.today();
		testDataFactory.testAccount.SIC_Classification_3__c = 'Salary';
		testDataFactory.testAccount.Q1a_Client_affected_by_Regulation_3_1_F__c = true;
		testDataFactory.testAccount.Q1c_Exchange_Control_Expiry_date__c = System.today();
		testDataFactory.testAccount.Q2a_Client_affected_by_Regulation_3_1_F__c = true;
		testDataFactory.testAccount.Q2c_Exchange_Control_Expiry_date__c = System.today();

        System.assert(testDataFactory.testAccount != null);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createIndividualClient(
			testDataFactory.testAccount,
			'RBB',
			UserInfo.getUserId(),
			'Individual Client',
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		Test.stopTest();

		//System.assertEquals(200, responseBean.statusCode);
	}

	//Positive
	@isTest
	static void testCreateClientRBBSolePropPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Sole Trader';
		testDataFactory.testAccount.Client_Group__c = 'SOLE TRADER CLIENT';
		createEmployersAddress(testDataFactory.testAccount);
		createPhysicalEmployersAddress(testDataFactory.testAccount);
		createBusinessAddress(testDataFactory.testAccount);
		createPostalAddress(testDataFactory.testAccount);
		testDataFactory.testAccount.Non_Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Non_Credit_Marketing_Consent__pc = 'Yes';
		testDataFactory.testAccount.Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Credit_Marketing_Consent__pc = 'Yes';
		testDataFactory.testAccount.Name = 'Test Name';
		testDataFactory.testAccount.Income_Tax_Number__pc = '1234';
		testDataFactory.testAccount.PersonHomePhone = '0112223344';
		testDataFactory.testAccount.MiddleName = 'Test';
		testDataFactory.testAccount.Home_Language__pc = 'English';
		testDataFactory.testAccount.FirstName = 'test1';
		testDataFactory.testAccount.Source_of_Income__c = 'Salary';
		testDataFactory.testAccount.Q1a_Client_affected_by_Regulation_3_1_F__c = true;
		testDataFactory.testAccount.Q1c_Exchange_Control_Expiry_date__c = System.today();
		testDataFactory.testAccount.Q2a_Client_affected_by_Regulation_3_1_F__c = true;
		testDataFactory.testAccount.Q2c_Exchange_Control_Expiry_date__c = System.today();
        System.assert(testDataFactory.testAccount != null);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createIndividualClient(
			testDataFactory.testAccount,
			'RBB',
			UserInfo.getUserId(),
			'Individual Client',
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		Test.stopTest();

		//System.assertEquals(200, responseBean.statusCode);
	}

	//Positive
	@isTest
	static void testCreateClientRBBMiniIndividualPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Group__c = 'Individual';
		testDataFactory.testAccount.Client_Type__c = 'Private Individual';
		testDataFactory.testAccount.Communication_Language__pc = 'English';
		createEmployersAddress(testDataFactory.testAccount);
		createPhysicalEmployersAddress(testDataFactory.testAccount);
		createBusinessAddress(testDataFactory.testAccount);
		createPostalAddress(testDataFactory.testAccount);
		testDataFactory.testAccount.Non_Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Non_Credit_Marketing_Consent__pc = 'Yes';
		testDataFactory.testAccount.Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Credit_Marketing_Consent__pc = 'Yes';
		testDataFactory.testAccount.Name = 'Test Name';
		testDataFactory.testAccount.Income_Tax_Number__pc = '1234';
		testDataFactory.testAccount.PersonHomePhone = '0112223344';
		testDataFactory.testAccount.MiddleName = 'Test';
		testDataFactory.testAccount.Home_Language__pc = 'English';
		testDataFactory.testAccount.FirstName = 'test1';
		testDataFactory.testAccount.Source_of_Income__c = 'Salary';
		testDataFactory.testAccount.PersonTitle = 'Mr.';
		testDataFactory.testAccount.Initials__pc = 'T';

        System.assert(testDataFactory.testAccount != null);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createMiniIndividualClient(
			testDataFactory.testAccount,
			'RBB Mini',
			UserInfo.getUserId(),
			'Individual Client',
			null,
			null
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		Test.stopTest();

		//System.assertEquals(200, responseBean.statusCode);
	}

	//Positive
	@isTest
	static void testCreateClientRBBMiniIndividualNegative() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.NEGATIVE_STRING,
				StringConstants.NEGATIVE_STRING,
				StringConstants.NEGATIVE_STRING,
				StringConstants.NEGATIVE_STRING
			)
		);

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Individual';
		createEmployersAddress(testDataFactory.testAccount);
		createPhysicalEmployersAddress(testDataFactory.testAccount);
		createBusinessAddress(testDataFactory.testAccount);
		createPostalAddress(testDataFactory.testAccount);
		testDataFactory.testAccount.Non_Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Non_Credit_Marketing_Consent__pc = 'Yes';
		testDataFactory.testAccount.Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Credit_Marketing_Consent__pc = 'Yes';
		testDataFactory.testAccount.Name = 'Test Name';
		testDataFactory.testAccount.Income_Tax_Number__pc = '1234';
		testDataFactory.testAccount.PersonHomePhone = '0112223344';
		testDataFactory.testAccount.MiddleName = 'Test';
		testDataFactory.testAccount.Home_Language__pc = 'English';
		testDataFactory.testAccount.FirstName = 'test1';
		testDataFactory.testAccount.Source_of_Income__c = 'Salary';

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createMiniIndividualClient(
			testDataFactory.testAccount,
			'RBB Mini',
			UserInfo.getUserId(),
			'Individual Client',
			null,
			null
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		Test.stopTest(); 

		System.assertEquals(400, responseBean.statusCode);
	}

	//Validate Error
	@isTest
	static void testCreateClientIndividualCvsValidateError() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.NEGATIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Individual';
		createEmployersAddress(testDataFactory.testAccount);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createIndividualClient(
			testDataFactory.testAccount,
			'WILLS',
			UserInfo.getUserId(),
			'Individual Client',
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();

		try {
			CreateClientCIF_Resp_IB_v1 responseBean1 = CreateClientCIF_IH_v1.createIndividualClient(
				null,
				'WILLS',
				UserInfo.getUserId(),
				null,
				new List<String>{ 'nonCreditMarketIndP' },
				new List<String>{ 'creditMarketIndP)' }
			);
		} catch (exception ex) {
            system.debug(ex);
		}

		Test.stopTest();
		System.assertEquals(400, responseBean.statusCode);
	}

	//Validate Error
	@isTest
	static void testCreateClientMiniIndividualCvsValidateError() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.NEGATIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Individual';
		createEmployersAddress(testDataFactory.testAccount);

        System.assert(testDataFactory.testAccount != null);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createMiniIndividualClient(
			testDataFactory.testAccount,
			'RBB Mini',
			UserInfo.getUserId(),
			'Individual Client',
			null,
			null
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();

		try {
			CreateClientCIF_Resp_IB_v1 responseBean1 = CreateClientCIF_IH_v1.createMiniIndividualClient(null, null, UserInfo.getUserId(), null, null, null);
		} catch (exception ex) {
            system.debug(ex);
		}

		Test.stopTest();
		//System.assertEquals(200, responseBean.statusCode);
	}

	//No Settings 1
	@isTest
	static void testCreateClientIndividualNoIntegrationSettings1() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);

		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Individual';
		createEmployersAddress(testDataFactory.testAccount);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createIndividualClient(
			testDataFactory.testAccount,
			'WILLS',
			UserInfo.getUserId(),
			'Individual Client',
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		Test.stopTest();

		System.assertEquals(500, responseBean.statusCode);
	}

	//No Settings 2
	@isTest
	static void testCreateClientIndividualNoIntegrationSettings2() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });

		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Individual';
		testDataFactory.testAccount.AgriClass_Percentage__c = 54;
		testDataFactory.testAccount.AgriClass__c = '12';
		testDataFactory.testAccount.AgriClass_Percentage__c = 54;
		testDataFactory.testAccount.CASA_Reference_Number__c = '12345';
		testDataFactory.testAccount.Income_Tax_Number__c = '12345';

		createEmployersAddress(testDataFactory.testAccount);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createIndividualClient(
			testDataFactory.testAccount,
			'WILLS',
			UserInfo.getUserId(),
			'Individual Client',
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		Test.stopTest();

		System.assertEquals(400, responseBean.statusCode);
	}

	//No Translations
	@isTest
	static void testCreateClientIndividualNoTranslations() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testProspectAccount.Client_Type__c = 'Individual';
		createEmployersAddress(testDataFactory.testProspectAccount);

		testDataFactory.testContact.AccountId = testDataFactory.testJointAccount.Id;
		update testDataFactory.testContact;

		String testProspectAccountContactId = testDataFactory.testContact.Id;
		AccountContactRelation acr = new AccountContactRelation();
		acr.AccountId = testDataFactory.testAccount.id;
		acr.ContactId = testProspectAccountContactId;
		acr.Roles = 'Contact Person';
		insert acr;

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createIndividualClient(
			testDataFactory.testProspectAccount,
			'WILLS',
			UserInfo.getUserId(),
			'Individual Client',
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		Test.stopTest();

		System.assertEquals(500, responseBean.statusCode);
	}

	/****************************************************************** BUSINESS ************************************************************************/

    /**
	 * @description  Positive
	*/
	@isTest
	static void testCreateClientBusinessPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS, StringConstants.UPD_JNT_PART_BY_CLIENT_CODE }
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Joint & Several';
		testDataFactory.testAccount.Name = 'Test Name';
		testDataFactory.testAccount.Income_Tax_Number__pc = '1234';
		testDataFactory.testAccount.PersonHomePhone = '0112223344';
		testDataFactory.testAccount.MiddleName = 'Test';
		//testDataFactory.testContact = createAddressData(testDataFactory.testContact);
		//testDataFactory.testContact.Primary_Client__c = true;

        System.assert(testDataFactory.testAccount != null);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createBusinessClient(
			testDataFactory.testAccount,
			new List<Account>{ testDataFactory.testProspectAccount },
			testDataFactory.testProspectAccount.Id,
			'Business Client',
			'WILLS',
			UserInfo.getUserId(),
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		Test.stopTest();

		//System.assertEquals(200, responseBean.statusCode);
	}

	//Validate Error
	@isTest
	static void testCreateClientBusinessCvsValidateError() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.NEGATIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Joint & Several';
		//testDataFactory.testContact = createAddressData(testDataFactory.testContact);
		//testDataFactory.testContact.Primary_Client__c = false;

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createBusinessClient(
			testDataFactory.testAccount,
			new List<Account>{ testDataFactory.testProspectAccount },
			testDataFactory.testProspectAccount.Id,
			'Business Client',
			'WILLS',
			UserInfo.getUserId(),
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();

		try {
			CreateClientCIF_Resp_IB_v1 responseBean1 = CreateClientCIF_IH_v1.createBusinessClient(
				null,
				new List<Account>{ testDataFactory.testProspectAccount },
				null,
				null,
				'WILLS',
				UserInfo.getUserId(),
				new List<String>{ 'nonCreditMarketIndP' },
				new List<String>{ 'creditMarketIndP)' }
			);
		} catch (exception ex) {
            system.debug(ex);
		}

		Test.stopTest();
		System.assertEquals(400, responseBean.statusCode);
	}

	//No Settings 1
	@isTest
	static void testCreateClientBusinessNoIntegrationSettings1() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Joint & Several';
		//testDataFactory.testContact = createAddressData(testDataFactory.testContact);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createBusinessClient(
			testDataFactory.testAccount,
			new List<Account>{ testDataFactory.testProspectAccount },
			testDataFactory.testProspectAccount.Id,
			'Business Client',
			'WILLS',
			UserInfo.getUserId(),
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		Test.stopTest();

		System.assertEquals(500, responseBean.statusCode);
	}

	//No Settings 2
	@isTest
	static void testCreateClientBusinessNoIntegrationSettings2() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Joint & Several';
		//testDataFactory.testContact = createAddressData(testDataFactory.testContact);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createBusinessClient(
			testDataFactory.testAccount,
			new List<Account>{ testDataFactory.testProspectAccount },
			testDataFactory.testProspectAccount.Id,
			'Business Client',
			'WILLS',
			UserInfo.getUserId(),
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		Test.stopTest();

		System.assertEquals(400, responseBean.statusCode);
	}

	//No Translations
	@isTest
	static void testCreateClientBusinessNoTranslations() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Joint & Several';
		//testDataFactory.testContact = createAddressData(testDataFactory.testContact);

		Test.startTest();
		// Call the method to test
		CreateClientCIF_Resp_IB_v1 responseBean = CreateClientCIF_IH_v1.createBusinessClient(
			testDataFactory.testAccount,
			new List<Account>{ testDataFactory.testProspectAccount },
			testDataFactory.testProspectAccount.Id,
			'Business Client',
			'WILLS',
			UserInfo.getUserId(),
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		System.debug('responseBean :' + responseBean);
		CreateClientCIF_Resp_IB_v1.dummyResponse();
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		Test.stopTest();

		System.assertEquals(500, responseBean.statusCode);
	}
	//No Translations
	@isTest
	static void testCreateBusinessprospectclient() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			new CreateClientCIFMock_ApiRest(
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING,
				StringConstants.POSITIVE_STRING
			)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_Create_Client_V12 });
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_ADDRESS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();
		testDataFactory.testAccount.Client_Type__c = 'Private Company';
		testDataFactory.testAccount.Client_Group__c = 'Non Individual';
		testDataFactory.testAccount.Non_Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Non_Credit_Marketing_Consent__pc = 'Yes';
		testDataFactory.testAccount.Credit_Marketing_Indicator__pc = 'SMS';
		testDataFactory.testAccount.Credit_Marketing_Consent__pc = 'Yes';
		//testDataFactory.testAccount.name ='test';
		testDataFactory.testAccount.Registration_Number__c = '1234';
		testDataFactory.testAccount.Income_Tax_Number__c = '54321';
		//testDataFactory.testAccount.Financial_Year_End__c
		testDataFactory.testAccount.Source_of_Income__c = 'Donation';
		testDataFactory.testAccount.Country_of_Operation__c = 'Antarctica;Austria';
		testDataFactory.testAccount.VAT_Registration_Number__c = 12345;
		testDataFactory.testAccount.AgriClass__c = 'yes';
		testDataFactory.testAccount.AgriClass_Percentage__c = 90;
		testDataFactory.testAccount.CASA_Reference_Number__c = '123';
		testDataFactory.testAccount.Income_Tax_Number__c = '1234';
		testDataFactory.testAccount.VAT_Registration_Number__c = 4321;
		testDataFactory.testAccount.Foreign_Tax_Number__c = 2345;
		testDataFactory.testAccount.Country_of_Foreign_tax__c = 'South Africa';
		testDataFactory.testAccount.Date_Identified__c = system.today();
		testDataFactory.testAccount.Date_Verified__c = system.today();
		testDataFactory.testAccount.Is_Marketing_Consent_Phone__c = true;
		testDataFactory.testAccount.Is_Marketing_Consent_SMS__c = true;
		testDataFactory.testAccount.Is_Marketing_Consent_Post__c = true;
		testDataFactory.testAccount.Is_Marketing_Consent_voice_rec__c = true;
		testDataFactory.testAccount.Preferred_Communication_Info__c = 'test';
		testDataFactory.testAccount.Q4a_Client_affected_by_Regulation_3_1_F__c = true;
		testDataFactory.testAccount.Q4c_Exchange_Control_Expiry_date__c = System.today();
		// testDataFactory.testAccount.Address_Type__c=StringConstants.PHYSICAL_ADDR_STRING;
		//testDataFactory.testAccount.
		//testDataFactory.testAccount.

		update testDataFactory.testAccount;
		List<Address__c> addListToBeInsert = new List<Address__c>();

		Address__c add1 = new Address__c();
		add1.Account__c = (testDataFactory.testAccount).id;
		add1.Address_Type__c = StringConstants.RESIDENTIAL_STRING;
		add1.Address1__c = 'Address1';
		add1.Address2__c = 'Address2';
		add1.Address3__c = 'Address3';
		add1.Address5__c = 'Address5';
		add1.Shipping_Street__c = 'Address1';
		add1.Shipping_Suburb__c = 'Address2';
		add1.Shipping_City__c = 'Address3';
		add1.Shipping_Zip_Postal_Code__c = '0124';
		add1.Shipping_State_Province__c = 'Address5';
		addListToBeInsert.add(add1);

		Address__c add2 = new Address__c();
		add2.Account__c = (testDataFactory.testAccount).id;
		add2.Address_Type__c = StringConstants.PHYSICAL_ADDR_STRING;
		add2.Address1__c = 'Address1';
		add2.Address2__c = 'Address2';
		add2.Address3__c = 'Address3';
		add2.Address5__c = 'Address5';
		add2.Shipping_Street__c = 'Address1';
		add2.Shipping_Suburb__c = 'Address2';
		add2.Shipping_City__c = 'Address3';
		add2.Shipping_Zip_Postal_Code__c = '0124';
		add2.Shipping_State_Province__c = 'Address5';
		addListToBeInsert.add(add2);

		Address__c add3 = new Address__c();
		add3.Account__c = (testDataFactory.testAccount).id;
		add3.Address_Type__c = StringConstants.POSTAL_STRING;
		add3.Address1__c = 'Address1';
		add3.Address2__c = 'Address2';
		add3.Address3__c = 'Address3';
		add3.Address5__c = 'Address5';
		add3.Shipping_Street__c = 'Address1';
		add3.Shipping_Suburb__c = 'Address2';
		add3.Shipping_City__c = 'Address3';
		add3.Shipping_Zip_Postal_Code__c = '0124';
		add3.Shipping_State_Province__c = 'Address5';
		addListToBeInsert.add(add3);

		Address__c addHO = new Address__c();
		addHO.Account__c = (testDataFactory.testAccount).id;
		addHO.Address_Type__c = StringConstants.HEAD_OFFICE_ADDR_STRING;
		addHO.Address1__c = 'Address1';
		addHO.Address2__c = 'Address2';
		addHO.Address3__c = 'Address3';
		addHO.Address5__c = 'Address5';
		addHO.Shipping_Street__c = 'Address1';
		addHO.Shipping_Suburb__c = 'Address2';
		addHO.Shipping_City__c = 'Address3';
		addHO.Shipping_Zip_Postal_Code__c = '0124';
		addHO.Shipping_State_Province__c = 'Address5';
		addListToBeInsert.add(addHO);

		Address__c addReg = new Address__c();
		addReg.Account__c = (testDataFactory.testAccount).id;
		addReg.Address_Type__c = StringConstants.REGISTERED_ADDR_STRING;
		addReg.Address1__c = 'Address1';
		addReg.Address2__c = 'Address2';
		addReg.Address3__c = 'Address3';
		addReg.Address5__c = 'Address5';
		addReg.Shipping_Street__c = 'Address1';
		addReg.Shipping_Suburb__c = 'Address2';
		addReg.Shipping_City__c = 'Address3';
		addReg.Shipping_Zip_Postal_Code__c = '0124';
		addReg.Shipping_State_Province__c = 'Address5';
		addListToBeInsert.add(addReg);

		insert addListToBeInsert;

		createBusinessAddress(testDataFactory.testAccount);

		List<Account> acList = [
			SELECT id, Client_Type__c, name, Registration_Number__c, Income_Tax_Number__c, Financial_Year_End__c, Source_of_Income__c
			FROM Account
			WHERE id = :(testDataFactory.testAccount).id
		];
		List<Contact> conList = [SELECT id FROM contact WHERE accountId = :acList[0].id];
		system.assertEquals(1, acList.size());
		system.assertEquals(1, conList.size());
		//system.assertEquals('test;test1;test3',acList[0].Source_of_Income__c);

		List<AccountContactRelation> accRel = [SELECT id, Roles, accountId FROM AccountContactRelation LIMIT 1];
		system.assertEquals(1, accRel.size());
		// system.assertEquals((testDataFactory.testAccount).id, accRel[0].accountId);
		accRel[0].Roles = 'Contact Person';
		//accRel[0].accountId=(testDataFactory.testAccount).id;
		update accRel[0];

		Test.startTest();
		CreateClientCIF_IH_v1.getBusinessProspectTranslations(testDataFactory.testAccount, new List<Account>{ testDataFactory.testProspectAccount }, null);
		map<CreateClientCIF_Resp_IB_v1, Sys_Log_Integration__c> responseBean = CreateClientCIF_IH_v1.createBusinessProspectClient(
			testDataFactory.testAccount,
			new List<Account>{ testDataFactory.testProspectAccount },
			testDataFactory.testProspectAccount.Id,
			'Business Prospect',
			null,
			UserInfo.getUserId(),
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);
		system.debug('responseBean-----' + responseBean);
		CreateClientCIF_Req_IB_v1.createDummyRequest();
		CreateClientCIF_Resp_IB_v1.dummyResponse();

		//TdB -
		accRel[0].Roles = 'PARTNERSHIP';
		update accRel[0];
		map<CreateClientCIF_Resp_IB_v1, Sys_Log_Integration__c> responseBeanPart = CreateClientCIF_IH_v1.createBusinessProspectClient(
			testDataFactory.testAccount,
			new List<Account>{ testDataFactory.testProspectAccount },
			testDataFactory.testProspectAccount.Id,
			'Business Prospect',
			null,
			UserInfo.getUserId(),
			new List<String>{ 'nonCreditMarketIndP' },
			new List<String>{ 'creditMarketIndP)' }
		);

		Test.stopTest();
	}

    /**
	 * @description  Create Address Date
     * @param accountP
     * @return Account
	*/
	public static Account createAddressData(Account accountP) {
		accountP.BillingStreet = '123 street';
		accountP.BillingCity = 'Johannesburg';
		accountP.BillingCountry = 'South Africa';
		accountP.BillingPostalCode = '1234';
		return accountP;
	}

    /**
	 * @description  Create Employer Address
     * @param accountP
	*/
	public static void createEmployersAddress(Account accountP) {
		Address__c address = new Address__c();
		address.Account__c = accountP.Id;
		address.Address_Type__c = 'Employers';
		address.Address1__c = 'Johannesburg';
		address.Address2__c = 'South Africa';
		address.Address3__c = '123 street';
		address.Address4__c = 'Bryanston';
		address.Address5__c = '1234';
		address.Shipping_City__c = 'Johannesburg';
		address.Shipping_Country__c = 'South Africa';
		address.Shipping_Street__c = '123 street';
		address.Shipping_Suburb__c = 'Bryanston';
		address.Shipping_Zip_Postal_Code__c = '1234';
		insert address;
	}

    /**
	 * @description  Create Physical Address
     * @param accountP
	*/
	public static void createPhysicalEmployersAddress(Account accountP) {
		Address__c address = new Address__c();
		address.Account__c = accountP.Id;
		address.Address_Type__c = 'Physical Address';
		address.Address1__c = 'Johannesburg';
		address.Address2__c = 'South Africa';
		address.Address3__c = '123 street';
		address.Address4__c = 'Bryanston';
		address.Address5__c = '1234';
		address.Shipping_City__c = 'Johannesburg';
		address.Shipping_Country__c = 'South Africa';
		address.Shipping_Street__c = '123 street';
		address.Shipping_Suburb__c = 'Bryanston';
		address.Shipping_Zip_Postal_Code__c = '1234';
		insert address;
	}

    /**
	 * @description  Create Business Address
     * @param accountP
	*/
	public static void createBusinessAddress(Account accountP) {
		Address__c address = new Address__c();
		address.Account__c = accountP.Id;
		address.Address_Type__c = 'Business Address';
		address.Address1__c = 'Johannesburg';
		address.Address2__c = 'South Africa';
		address.Address3__c = '123 street';
		address.Address4__c = 'Bryanston';
		address.Address5__c = '1234';
		address.Shipping_City__c = 'Johannesburg';
		address.Shipping_Country__c = 'South Africa';
		address.Shipping_Street__c = '123 street';
		address.Shipping_Suburb__c = 'Bryanston';
		address.Shipping_Zip_Postal_Code__c = '1234';
		insert address;
	}

    /**
	 * @description  Create Postal Address
     * @param accountP
	*/
	public static void createPostalAddress(Account accountP) {
		Address__c address = new Address__c(); 
		address.Account__c = accountP.Id;
		address.Address_Type__c = 'Postal';
		address.Address1__c = 'Johannesburg';
		address.Address2__c = 'South Africa';
		address.Address3__c = '123 street';
		address.Address4__c = 'Bryanston';
		address.Address5__c = '1234';
		address.Shipping_City__c = 'Johannesburg';
		address.Shipping_Country__c = 'South Africa';
		address.Shipping_Street__c = '123 street';
		address.Shipping_Suburb__c = 'Bryanston';
		address.Shipping_Zip_Postal_Code__c = '1234';
		insert address;
	}
}