/**
 * @description BeneficiaryMaintenanceTest test class for testing BeneficiaryMaintenance
 * @author Rudolf Niehaus
 * @created 2020-03-30
 */
@isTest
public class BeneficiaryMaintenanceTest {
	@isTest
	public static void testBeneficiaryMaintenance() {
		WillsTestDataFactory testDataFactory = new WillsTestDataFactory();

		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				MBlistInstPerSourceAccV1_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ MBlistInstPerSourceAccV1_IH_v1.INTEGRATION_SERVICE_NAME }
		);

		Test.startTest();

		Map<String, List<Object>> responseMap = BeneficiaryMaintenance.getBeneficiaryListMap('CIF001', '4048009098', 'VP');
		System.assertNotEquals(null, responseMap, 'Assert Failed');
		BeneficiaryMaintenance.getLoggedInUserDetails();
		Lookup__c testBankLookup = BeneficiaryMaintenance.getBankIdByName(testDataFactory.testBank.Name);
		Lookup__c testBranchLookup = BeneficiaryMaintenance.getSelectedBranchRecordDetails(testDataFactory.testBank.Branch_Code__c);

		Test.stopTest();
	}

    @isTest
	public static void testEBSBeneficiaryMaintenance() {

        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ EBSBeneficiaries_IH_v1.INTEGRATION_SERVICE_NAME }
		);

		Test.startTest();
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				EBSBeneficiaries_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Map<String, List<Object>> responseMap = BeneficiaryMaintenance.getEBSBeneficiaries('JINPIX 001', '04483850000192464');
		Test.stopTest();

        system.assertEquals(23, responseMap.keySet().size(), 'Assert Failed');

	}

	@testSetup
	static void dataCreation() {
		Account account = new Account(Name = 'Test Account');
		insert account;

		Contact contact = new Contact(LastName = 'Test contact', AccountId = account.Id, Email = 'agents@support.co.za');
		insert contact;

		Document_Template__c docTemp = new Document_Template__c(
			Name = 'IVR_Beneficiary_List',
			Document_Type__c = 'IVR_Beneficiary_List',
			XML__c = '{beneficiaryList}'
		);
		insert docTemp;

		Service_Group__c serviceGroupRecord = new Service_Group__c(
			Name = 'Everyday Banking',
			Queue__c = 'Queue',
			Active__c = true,
			Assign_Record_Type__c = 'Service Request',
			Response_Email_Address__c = 'businessbanking@absa.africa'
		);
		insert serviceGroupRecord;

		Map<String, Schema.RecordTypeInfo> caseRecordTypeMap = Case.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();

		Case testCase = new Case(
			Communication_Method__c = 'Email',
			Status = 'New',
			Origin = 'Email',
			AccountId = account.Id,
			Risk_Management_Centre__c = 'Digital Fraud',
			Email__c = 'test@test.com',
			recordTypeId = caseRecordTypeMap.get('Service_Request').getRecordTypeId(),
			Subject = 'test',
			Description = 'test',
			Expectation_of_the_Customer__c = 'test',
			sd_Service_Group_Id__c = serviceGroupRecord.Id,
			Incident_Date__c = date.today(),
            Site__c = 'test'
		);
		insert testCase;
	}

	@isTest
	public static void testCIGetAccount() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'SKOSANA';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '8505225522085';
		accountList[0].CIF__c = 'ARENTAL001';
		insert accountList;

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);

		Test.startTest();
		String responseBean = BeneficiaryMaintenance.getAccountDetails(accountList[0].Id);
		System.assert(responseBean.startsWith('['));
		Test.stopTest();
	}

	@isTest
	public static void testCIGetAccountNoAccountWithId() {
		Test.startTest();
		String responseBean = BeneficiaryMaintenance.getAccountDetails(null);
		System.assert(responseBean.startsWith('Error'));
		Test.stopTest();
	}

	@isTest
	public static void testCIGetAccountNoIntegrationService() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'SKOSANA';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '8505225522085';
		accountList[0].CIF__c = 'ARENTAL001';
		insert accountList;

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
		Test.startTest();
		String responseBean = BeneficiaryMaintenance.getAccountDetails(accountList[0].Id);
		System.assert(responseBean.startsWith('Error'));
		Test.stopTest();
	}

	@isTest
	public static void testUpdateBeneficiary() {
		WillsTestDataFactory testDataFactory = new WillsTestDataFactory();

		Test.setMock(HttpCalloutMock.class, new MBupdateInstructionV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.MB_UPDATE_BENEFICIARIES_V1 }
		);

		Test.startTest();
		String ivrResponseMap;

		String responseMap = BeneficiaryMaintenance.updateBeneficiary(
			testDataFactory.testAccount.id,
			'50',
			'Test Name',
			'4048009098',
			'02',
			'632005',
			'02',
			'62001847237',
			testDataFactory.testBranch.id,
			'Test Ref',
			'Test Own Ref',
			testDataFactory.testUser,
            '00'
		);
		ivrResponseMap = BeneficiaryMaintenance.updateIVRBeneficiary(
			testDataFactory.testAccount.id,
			'50',
			'Test Name',
			'4048009098',
			'02',
			'02',
			'62001847237',
			testDataFactory.testBranch.id,
			'Test Ref',
			'Test Own Ref',
			'00009',
			'00027'
		);

		Test.stopTest();
		system.assertEquals(true, String.isNotBlank(ivrResponseMap), 'Assert Failed');
	}

	@isTest
	public static void testDeleteBeneficiary() {
		WillsTestDataFactory testDataFactory = new WillsTestDataFactory();

		Test.setMock(HttpCalloutMock.class, new MBdeleteInstructionV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.MB_DELETE_BENEFICIARIES_V2 }
		);

		Test.startTest();

		String responseMap = BeneficiaryMaintenance.removeBeneficiary(testDataFactory.testAccount.id, '50', testDataFactory.testUser,'00');

		Test.stopTest();
		system.assertEquals(true, String.isNotBlank(responseMap), 'Assert Passed');
	}

	@isTest
	public static void testaddBeneficiaryRecord() {
		WillsTestDataFactory testDataFactory = new WillsTestDataFactory();

		Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest(StringConstants.POSITIVE_STRING));

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CREATE_INSTRUCTION });

		Test.startTest();
		String responseMap;

		responseMap = BeneficiaryMaintenance.addBeneficiaryRecord(
			'550220261',
			'02',
			'Test Name',
			'CQ',
			testDataFactory.testBranch.id,
			'3001325523',
			'own ref',
			'ben ref',
			testDataFactory.testUser
		);
		Test.stopTest();
		system.assertEquals(true, String.isNotBlank(responseMap), 'Assert Passed');
	}

	@isTest
	static void testGetBeneficiaryData() {
		String testBeneficiaries = '[{"actDate":"00000000","amount":"0.00","cifKey":"BOUCHI 001","clientType":"I","endDate":"20991231","freeBankIndicator":"N","frequency":"VP","iipAllowIndicator":"N","instrNumber":"0000006","instrRefName":"Fred Flitston2","instrStatus":"CURRENT","instrType":"VP","intExtBenIndicator":"I","ivrNominate":"00001","lastMaintDate":"20210325","lastMaintTeller":"99999","mandNumber":"0000000","multiNumber":"00000","payDay":"00","priNumber":"000","sourceAccount":"000000004938050012371328","sourceClrCode":"000000","sourceInstCode":"ABSA BANK","sourceStatementRef":"Fred Flitston","startDate":"20210325","targetAccount":"000000000000009050723102","targetAccountType":"Savings","targetBusinessCode":"0000000","targetClrCode":"632005","targetInstCode":"ABSA BANK","targetStatementRef":"erewrew","tieb":"00000","timeRange":"000","uniqueEFT":"800046591C"},{"actDate":"00000000","amount":"0.00","cifKey":"BOUCHI 001","clientType":"I","endDate":"20991231","freeBankIndicator":"N","frequency":"VP","iipAllowIndicator":"Y","instrNumber":"0000008","instrRefName":"Nyandane","instrStatus":"CURRENT","instrType":"VP","intExtBenIndicator":"E","ivrNominate":"00000","lastMaintDate":"20210323","lastMaintTeller":"99999","mandNumber":"0000000","multiNumber":"00000","payDay":"00","priNumber":"000","sourceAccount":"000000004938050012371328","sourceClrCode":"000000","sourceInstCode":"ABSA BANK","sourceStatementRef":"UAT Nyandane","startDate":"20210323","targetAccount":"000000000000000203099621","targetAccountType":"02","targetBusinessCode":"0000000","targetClrCode":"014442","targetInstCode":"STD S.A.","targetStatementRef":"Nyandane UAT","tieb":"00000","timeRange":"000","uniqueEFT":"80004B0638"}]';
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ Sys_Utilities_General.getEnvironment(), DocumentTemplateProcessor.DOCUMENT_TEMPLATE_PROCESSOR }
		);
		Account acc = [SELECT Id FROM Account LIMIT 1];

		Test.startTest();
		String response = BeneficiaryMaintenance.getBeneficiaryData(testBeneficiaries, 'IVR_Beneficiary_List', acc.Id);
		Test.stopTest();
		//Using assertNotEquals to null because the DocumentTemplateProcessor returns no content when running tests,
		// and as a result the code to retrieve the generated document cannot be test because of the underlying problem
		System.assertNotEquals(null, response, 'Assert Failed');
	}

	@isTest
	static void testSendBeneficiaryList() {
		Case testCase = [SELECT Id FROM Case LIMIT 1];

		//Using  an HTML template because the HTML body of the email is being set
		EmailTemplate eTemplate = [SELECT Id, DeveloperName FROM EmailTemplate WHERE TemplateType = 'HTML' LIMIT 1];

		Test.startTest();
		String sendEmailResp = BeneficiaryMaintenance.sendBeneficiaryList(
			testCase.Id,
			'test@example.com',
			eTemplate.DeveloperName,
			'sampleBase64PdfData',
			'IVR_Beneficiary_List'
		);
		Test.stopTest();
		System.assertEquals('Email sent Successfully', sendEmailResp, 'Assert Failed');
	}
}