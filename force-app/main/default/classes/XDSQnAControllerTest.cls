/*
 Controller Test Class For XDS Controller class
*
* @author  Almas Aleem : Absa
* @version v1.0
* @since   2019-09-18
*/

@IsTest(seeAllData=false)
public class XDSQnAControllerTest {
	@IsTest
	public static void testXDS() {
		//Get test data
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'SKOSANA';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '8505225522085';

		insert accountList;

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new XDSGetQuestionsMock_ApiRest(StringConstants.POSITIVE_STRING));
		// IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {'Jitterbit Auth Path'});

		// System.debug([SELECT Id,Name FROM Integration_Service__c where Name =:StringConstants.XDS_GetQuestions]);
		//IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.XDS_GetQuestions});

		Test.startTest();
		XDSGetQuetions_Resp_IB_v1 responseBean = XDSQnAController.getQuesAndAnsList(accountList[0].Id);

		System.assertNotEquals(null, responseBean, 'Assert Failed');

		Test.stopTest();
		XDSGetQuetions_Req_IB_v1 reqbean = new XDSGetQuetions_Req_IB_v1();
		reqbean.creatDummyRequest();
		XDSGetQuestions_IH_v1.getToXDSGetQuetionsService(reqBean);
		XDSGetQuetions_Resp_IB_v1.DummyRequestForXDSVerification();
	}

	@IsTest
	public static void testXDS1() {
		//Get test data
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'SKOSANA';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '8505225522085';

		insert accountList;

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new XDSGetQuestionsMock_ApiRest(StringConstants.POSITIVE_STRING));
		// IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.Jitterbit2, new list<String> {'Jitterbit Auth Path'});
		// IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.XDS_GetQuestions});

		Test.startTest();
		//XDSGetQuetions_Resp_IB_v1 responseBean = XDSQnAController.getQuesAndAnsList(accountList[0].Id);

		XDSGetQuetions_Resp_IB_v1 responseBean = XDSQnAController.getQuestions('8505225522085', 'SKOSANA');

		System.assertNotEquals(null, responseBean, 'Assert Failed');

		Test.stopTest();
		XDSGetQuetions_Req_IB_v1 reqbean = new XDSGetQuetions_Req_IB_v1();
		reqbean.creatDummyRequest();
		XDSGetQuestions_IH_v1.getToXDSGetQuetionsService(reqBean);
		XDSGetQuetions_Resp_IB_v1.DummyRequestForXDSVerification();
	}

	@IsTest
	public static void testXDSResponse() {
		String staticResourceNameMockPositiveXDSSubmitQuestion = 'Mock_Positive_XDSSubmitQuestions_v1';

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ABSAOnlineStatementDownload_IH_v1.INTEGRATION_SERVICE_NAME }
		);

		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				staticResourceNameMockPositiveXDSSubmitQuestion
			)
		);
		Account acc = new Account();
		acc.name = 'test acc';
		acc.CIF__c = 'HJKLL';
		insert acc;

		Test.startTest();
		XDSQnAController.XDSVerificationResult response = XDSQnAController.verifyClient('{}');
		XDSQnAController.XDSVerificationResult responseXDS = XDSQnAController.verifyClientXDS('{}', acc.Id);
		System.assertNotEquals(null, response, 'Assert Failed');
		Test.stopTest();
	}

	@IsTest
	public static void testXDSNegative() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'SKOSANA';
		insert accountList;

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new XDSGetQuestionsMock_ApiRest(StringConstants.NEGATIVE_STRING));
		//IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.Jitterbit2, new list<String> {'Jitterbit Auth Path'});
		//IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.XDS_GetQuestions});

		Test.startTest();
		XDSGetQuetions_Resp_IB_v1 responseBean = XDSQnAController.getQuesAndAnsList(accountList[0].Id);

		System.assertNotEquals(null, responseBean, 'Assert Failed');

		XDSGetQuetions_Req_IB_v1 reqBean = new XDSGetQuetions_Req_IB_v1();
		reqBean.idNumber = '7108095432088';
		reqBean.surname = 'Sizwe';
		XDSGetQuestions_IH_v1.getToXDSGetQuetionsService(reqBean);
		XDSQnAController.getQuestions('7108095432088', 'Sizwe');
		Test.stopTest();
	}

	@IsTest
	static void validateXDSGetQuestionsNegativeWithOutIdNumber() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'XDSGetQuestions';
		insert accountList;
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new XDSGetQuestionsMock_ApiRest(StringConstants.POSITIVE_STRING));
		//IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.Jitterbit2, new list<String> {'Jitterbit Auth Path'});
		//IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.XDS_GetQuestions});

		Test.startTest();
		Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> resonseMap = XDSGetQuestions_IH_v1.callToXDSGetQuetionsService(accountList[0].id);
		XDSGetQuetions_Resp_IB_v1 responseBean = (new List<XDSGetQuetions_Resp_IB_v1>(resonseMap.keySet()))[0];
		System.debug('XDGetQUetions responseBean Negative with No ID: ' + responseBean);
		System.assertEquals(500, responseBean.statusCode, 'Assert Failed');

		XDSGetQuetions_Req_IB_v1 reqBean = new XDSGetQuetions_Req_IB_v1();
		reqBean.idNumber = '7108095432088';
		reqBean.surname = 'Sizwe';
		XDSGetQuestions_IH_v1.getToXDSGetQuetionsService(reqBean);
		Test.stopTest();
	}

	@IsTest
	static void validateXDSGetQuestionsNegativeWithOutIntigrationSettings() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'XDSGetQuestions';
		accountList[0].ID_Type__pc = 'SA Identity Document';
		accountList[0].ID_Number__pc = '123456';
		insert accountList;
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new XDSGetQuestionsMock_ApiRest(StringConstants.NEGATIVE_STRING));
		// IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.Jitterbit2, new list<String> {'Jitterbit Auth Path'});
		//IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.JITTERBIT_API_RB_STRING, new list<String> {StringConstants.XDS_GetQuestions});

		Test.startTest();
		Map<XDSGetQuetions_Resp_IB_v1, List<Sys_Log_Integration__c>> resonseMap = XDSGetQuestions_IH_v1.callToXDSGetQuetionsService(accountList[0].id);
		XDSGetQuetions_Resp_IB_v1 responseBean = (new List<XDSGetQuetions_Resp_IB_v1>(resonseMap.keySet()))[0];
		System.debug('XDGetQUetions responseBean Negative with No ID: ' + responseBean);

		System.assertNotEquals(null, responseBean, 'Assert Failed');

		XDSGetQuetions_Req_IB_v1 reqBean = new XDSGetQuetions_Req_IB_v1();
		reqBean.idNumber = '7108095432088';
		reqBean.surname = 'Sizwe';
		XDSGetQuestions_IH_v1.getToXDSGetQuetionsService(reqBean);
		Test.stopTest();
	}

	@IsTest
	public static void testXDSByPass() {
		Case caseRec = new Case();
		caseRec.Status = 'New';
		caseRec.OwnerId = UserInfo.getUserId();
		insert caseRec;

		Contact con = new Contact();
		con.FirstName = 'john';
		con.LastName = 'smith';
		con.Email = 'jj@smith.com';
		insert con;

		Test.startTest();

		XDSQnAController.XDSBypassResult result = XDSQnAController.logXDSBypass(caseRec.Id, true);
		XDSQnAController.XDSBypassResult result1 = XDSQnAController.logXDSBypass(caseRec.Id, false);

		Test.stopTest();
		System.assertEquals(true, String.isNotBlank(result.xdsBypassBy), 'Assert Failed');
		System.assertEquals(true, String.isEmpty(result1.xdsBypassBy), 'Assert Failed');
	}

	@IsTest
	public static void testXDSSPA() {
		List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual_Client', 1);
		accountList[0].LastName = 'SKOSANA';
		insert accountList;

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ StringConstants.CIgetSpecialPowerOfAttorneyV4_STRING }
		);

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CIgetSpecialPowerOfAttorney_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		Test.startTest();
		CIgetSpecialPowerOfAttorneyV4_Resp_IB_v1 responseBean = XDSQnAController.getSpecialPA('3501000021');
		XDSQnAController.getAccountProducts(accountList[0].Id);

		System.assertNotEquals(null, responseBean, 'Assert Failed');

		/*XDSGetQuetions_Req_IB_v1 reqBean= new XDSGetQuetions_Req_IB_v1();
        reqBean.idNumber='7108095432088';
        reqBean.surname='Sizwe';
        XDSGetQuestions_IH_v1.getToXDSGetQuetionsService(reqBean);
        XDSQnAController.getQuestions('7108095432088','Sizwe');*/
		Test.stopTest();
	}

	@IsTest
	public static void testXDSGPA() {
		/*List<Account> accountList = TestDataFactory.getPersonAccounts('lastName', 'Individual Client', 1);
        accountList[0].LastName = 'SKOSANA';
        insert accountList;*/

		Account acctSecondary = new Account();
		acctSecondary.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Client').getRecordTypeId();
		acctSecondary.ID_Number__pc = '6803037015089';
		acctSecondary.ID_Type__c = 'SA Identity Document';
		acctSecondary.FirstName = 'First Name';
		acctSecondary.LastName = 'Test Last Name';
		acctSecondary.Initials__pc = 'I';
		acctSecondary.PersonTitle = 'Mr';
		acctSecondary.Client_Type__c = 'Individual Client';
		acctSecondary.CASA_Reference_Number__c = '12454';
		acctSecondary.CASA_Screening_Status__c = 'Matched';
		acctSecondary.AccountNumber = '3501000021';
		insert acctSecondary;

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ StringConstants.cigetgeneralpowerofattorneyv4_STRING }
		);

		Test.setMock(HttpCalloutMock.class, new cigetgeneralpowerofattorney_Mock_ApiRest(StringConstants.POSITIVE_STRING));

		Test.startTest();
		cigetgeneralpowerofattorneyv4_Resp_IB_v1 responseBean = XDSQnAController.getGeneralPA('3501000021');
		XDSQnAController.getAccountName(acctSecondary.Id);

		System.assertNotEquals(null, responseBean, 'Assert Failed');

		/*XDSGetQuetions_Req_IB_v1 reqBean= new XDSGetQuetions_Req_IB_v1();
        reqBean.idNumber='7108095432088';
        reqBean.surname='Sizwe';
        XDSGetQuestions_IH_v1.getToXDSGetQuetionsService(reqBean);
        XDSQnAController.getQuestions('7108095432088','Sizwe');*/
		Test.stopTest();
	}

	@IsTest
	public static void testMandateValidation() {
		Test.setMock(HttpCalloutMock.class, new CIgetSigningInstructionsV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));

		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ StringConstants.CI_GET_SIGNING_INSTRUCTIONS_V4 });

		Test.startTest();
		String response = XDSQnAController.getMandate('4048009098');
		Test.stopTest();
		System.assertNotEquals(null, response, 'Assert Failed');
	}

	@IsTest
	public static void testSessionCacheValues() {
		Test.startTest();
		XDSQnAController.setSessionCacheValues('SKOSANA');
		ClientIDnVPollingApex.ClientIDnVSessionObject clientIDnVSessionObj = XDSQnAController.getSessionCacheValues('SKOSANA');
		Test.stopTest();
		System.assert(clientIDnVSessionObj.matched, 'Assert Failed');
	}
}