/**
 * @description Controller Test Class For StopOrderMaintenance
 * @author Rudolf Niehaus
 * @since 2020-05-23
 * @updated 2021/04/13
 */
@isTest
public class StopOrderMaintenanceTest {
	@isTest
	public static void testListStopOrders() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'ABSA TEST123';

		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '9302212347096';
		accountList[0].AccountNumber = '4047995828';
		accountList[0].CIF__c = 'ZUMAD  001';

		insert accountList;

		MBListSourceInstructionsV1_Req_IB_v1 dummyBeanParent = MBListSourceInstructionsV1_Req_IB_v1.createDummyRequest();
		MBListSourceInstructionsV1_Req_IB_v1.Mbs305i dummyBean = dummyBeanParent.MBListSourceInstructionsV1.mbs305i;

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new MBListSourceInstructionsV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.MB_LIST_SOURCE_INSTRUCTIONS_V1 }
		);

		Test.startTest();
		User userRecord = StopOrderMaintenance.getLoggedInUserDetails();
		Map<String, Map<String, String>> benMap = StopOrderMaintenance.getBeneficiaryList(accountList[0].Id, accountList[0].AccountNumber, userRecord);
		system.assertNotEquals(null, benMap, 'list is null');
		Test.stopTest();
	}

	@isTest
	public static void testUpdateStopOrders() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'ABSA TEST123';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '9302212347096';
		accountList[0].AccountNumber = '4048017641';
		accountList[0].CIF__c = 'ZUMAD  001';

		insert accountList;

		List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
		caseList[0].Subject = 'TESTCASE123';
		caseList[0].AccountId = accountList[0].Id;
		insert caseList;

		map<String, Schema.RecordTypeInfo> recordTypeMap = Lookup__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Lookup__c lup = new Lookup__c();
		lup.recordTypeId = recordTypeMap.get('Bank').getRecordTypeId();
		lup.Name = 'TESTBANK123';
		insert lup;
		Lookup__c lupb = new Lookup__c();
		lupb.recordTypeId = recordTypeMap.get('Branch').getRecordTypeId();
		lupb.Name = 'THEBRANCH';
		lupb.Bank__c = lup.Id;
		lupb.Branch_Code__c = '250655';
		insert lupb;

		MBSupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBSupdateInstructionV1_Req_IB_v1.createDummyRequest();
		MBSupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new MBSupdateInstructionV1_Mock_ApiRest(StringConstants.POSITIVE_STRING));

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.MB_UPDATE_BENEFICIARIES_V1 }
		);

		Test.startTest();

		User userRecord = StopOrderMaintenance.getLoggedInUserDetails();

		String responsString = StopOrderMaintenance.updateBeneficiary(
			accountList[0].Id,
			'3',
			'2021',
			'20200601',
			'20200706',
			'1',
			'1Y',
			'199',
			'4048017641',
			'02',
			'632005',
			'02',
			'62001847237',
			lupb.Id,
			'2021',
			'2021',
			userRecord,
			'update'
		);
		system.assertNotEquals(null, responsString, 'response string is null');
		Test.stopTest();
	}

	@isTest
	public static void testAddStopOrders() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'ABSA TEST123';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '9302212347096';
		accountList[0].AccountNumber = '4047995828';
		accountList[0].CIF__c = 'ZUMAD  001';

		insert accountList;

		List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
		caseList[0].Subject = 'TESTCASE123';
		caseList[0].AccountId = accountList[0].Id;
		insert caseList;

		map<String, Schema.RecordTypeInfo> recordTypeMap = Lookup__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Lookup__c lup = new Lookup__c();
		lup.recordTypeId = recordTypeMap.get('Bank').getRecordTypeId();
		lup.Name = 'TESTBANK123';
		insert lup;
		Lookup__c lupb = new Lookup__c();
		lupb.recordTypeId = recordTypeMap.get('Branch').getRecordTypeId();
		lupb.Name = 'TESTBANK123';
		lupb.Bank__c = lup.Id;
		lupb.Branch_Code__c = '250655';
		insert lupb;

		MBSupdateInstructionV1_Req_IB_v1 dummyBeanParent = MBSupdateInstructionV1_Req_IB_v1.createDummyRequest();
		MBSupdateInstructionV1_Req_IB_v1.Mbp300i dummyBean = dummyBeanParent.MBupdateInstructionV1.mbp300i;

		Test.setMock(HttpCalloutMock.class, new CreateInstructionMock_ApiRest_v2(StringConstants.POSITIVE_STRING));
		//Insert Integration Settings
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.CREATE_INSTRUCTION });
		IntegrationTestDataFactory.insertIntegrationTranslations();

		Test.startTest();

		User userRecord = StopOrderMaintenance.getLoggedInUserDetails();

		String responseString = StopOrderMaintenance.updateBeneficiary(
			accountList[0].Id,
			dummyBean.instrNo,
			dummyBean.instrRefName,
			dummyBean.actDate,
			dummyBean.endDate,
			dummyBean.payDay,
			dummyBean.freq,
			dummyBean.amount,
			dummyBean.srcAcc,
			dummyBean.srcAccType,
			dummyBean.srcClrCode,
			dummyBean.trgAccType,
			dummyBean.trgAcc,
			lup.Id,
			dummyBean.srcStmtRef,
			dummyBean.trgStmtRef,
			userRecord,
			'insert'
		);

		System.assert(String.isNotEmpty(responseString), 'request unsuccessful');
		Test.stopTest();
	}

	@isTest
	public static void testGetCombicardNo() {
		CIgetAcctLinkedToClientCode_Req_IB_v1 dummyBean = new CIgetAcctLinkedToClientCode_Req_IB_v1();
		dummyBean.createDummyRequest();

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetAcctLinkedToClientCodeMock_ApiRest(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.API_MANAGER,
			new List<String>{ StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE }
		);

		Test.startTest();

		String accessAcc = StopOrderMaintenance.getCombiCardNumber('ZUMAD  001');
		System.assert(String.isNotEmpty(accessAcc), 'access account is empty');
		Test.stopTest();
	}

	@isTest
	public static void testRemoveStopOrders() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'ABSA TEST123';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '9302212347096';
		accountList[0].AccountNumber = '4047995828';
		accountList[0].CIF__c = 'ZUMAD  001';

		insert accountList;

		List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
		caseList[0].Subject = 'TESTCASE123';
		caseList[0].AccountId = accountList[0].Id;
		insert caseList;

		MBdeleteInstructionV2_Req_IB_v1 dummyBeanParent = MBdeleteInstructionV2_Req_IB_v1.createDummyRequest();
		MBdeleteInstructionV2_Req_IB_v1.Mbs306i dummyBean = dummyBeanParent.MBdeleteInstructionV2.mbs306i;

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new MBdeleteInstructionV2_Mock_ApiRest(StringConstants.POSITIVE_STRING));

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.MB_DELETE_BENEFICIARIES_V2 }
		);

		Test.startTest();

		User userRecord = StopOrderMaintenance.getLoggedInUserDetails();

		String responseString = StopOrderMaintenance.removeBeneficiary(accountList[0].Id, dummyBean.instrNo, userRecord);
		System.assert(responseString.contains('Successfully Removed'), 'removal unsuccessful');
		Test.stopTest();
	}

	@isTest
	public static void testEmailStopOrders() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'ABSA TEST123';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '9302212347096';
		accountList[0].PersonEmail = 'dummy@test.co.za';
		accountList[0].AccountNumber = '4047995828';
		accountList[0].CIF__c = 'ZUMAD  001';

		insert accountList;

		List<Case> caseList = TestDataFactory.getCases('Service_Request', 1);
		caseList[0].Subject = 'TESTCASE123';

		Date sla = Date.today().addDays(15);
		caseList[0].External_SLA_End_Date__c = sla;
		caseList[0].AccountId = accountList[0].Id;

		insert caseList;

		map<String, Schema.RecordTypeInfo> recordTypeMap = Lookup__c.sObjectType.getDescribe().getRecordTypeInfosByDeveloperName();
		Lookup__c lup = new Lookup__c();
		lup.recordTypeId = recordTypeMap.get('Bank').getRecordTypeId();
		lup.Name = 'TESTBANK123';
		insert lup;
		Lookup__c lupb = new Lookup__c();
		lupb.recordTypeId = recordTypeMap.get('Branch').getRecordTypeId();
		lupb.Name = 'TESTBANK123';
		lupb.Bank__c = lup.Id;
		lupb.Branch_Code__c = '250655';
		insert lupb;

		String jsonStr =
			'[{"key":"3","value":["KINGPRICE","20200601","KINGPRICE","199","ANNUALLY","FIRSTRAND",' +
			'"000000000000062001847237","KINGPRICE"]},{"key":"4","value":["TEST Lockdown","20200601",' +
			'"TEST Lockdown","100","MONTHLY","FIRSTRAND","000000000000062001847237","TEST Lockdown"]},' +
			'{"key":"24","value":["CYCLE LAB","20200529","Cycle lab extras","3500","DAILY","FIRSTRAND",' +
			'"000000000000062001847237","RWNIEHAUS"]},{"key":"26","value":["J&B Liquor","20200601","Wine Club",' +
			'"1500","DAILY","FIRSTRAND","000000000000062001847237","RWNIEHAUS"]},{"key":"27","value":["CYCLE LAB",' +
			'"20200529","Cycle lab extras","3500","DAILY","FIRSTRAND","000000000000062001847237","RWNIEHAUS"]},' +
			'{"key":"28","value":["Amazon","20200601","KindleUnlimited","275","DAILY","FIRSTRAND","000000000000062001847237",' +
			'"NIE007"]},{"key":"30","value":["PP Pharmacy","20200601","ABC","450","DAILY","FIRSTRAND","000000000000062001847237",' +
			'"NIE009"]},{"key":"31","value":["MTB Rides","20200601","Monthly Park acc","250","DAILY","FIRSTRAND","000000000000062001847237",' +
			'"RWNIE001"]}]';

		Test.startTest();

		// DO NOT REMOVE - WILL BE USED WHEN DOCFUSION IS READY *******
		//StopOrderMaintenance.sendStopOrderHistory(jsonStr, 'dummy@test.co.za', caseList[0].Id);

		List<String> rq = StopOrderMaintenance.getFreqancy();
		System.assertNotEquals(null, rq, 'frequency list is empty');

		String result = StopOrderMaintenance.translateFreqancy('None', 'in');
		System.assertNotEquals(null, result, 'result is null');
		String resultOut = StopOrderMaintenance.translateFreqancy('None', 'out');
		System.assertNotEquals(null, resultOut, 'resultOut is null');

		StopOrderMaintenance.closeCaseAction(caseList[0].Id);

		Lookup__c testLookUp = StopOrderMaintenance.getSelectedBranchRecordDetails(lupb.Branch_Code__c);
		Lookup__c testLookUpByName = StopOrderMaintenance.getBankIdByName(lup.Name);
		System.assertNotEquals(null, testLookUp, 'testLookUp is null');
		System.assertNotEquals(null, testLookUpByName, 'testLookUpByName is null');
		Test.stopTest();
	}
}