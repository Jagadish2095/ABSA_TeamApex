/**
 * @description test class for BAPIAccountFinancialInformation.
 * @author Bhanumurty Rayala
 * @created 2021-06-09
 */
@isTest
public class BAPIAccountFinancialInformationTest {
	@TestSetup
	static void makeData() {
		Account testAccount = new Account();
		testAccount.Name = 'Test Account';
		testAccount.AccountNumber = '000123456';
		insert testAccount;

		Contact testContact = new Contact();
		testContact.FirstName = 'Test';
		testContact.LastName = 'Test';
		testContact.Email = 'test@testcontact.com';
		testContact.Accountid = testAccount.id;
		insert testContact;

		Case testCase = new Case(Subject = 'Test Controller Acct Case');
		insert testCase;
	}

	@IsTest
	static void testGetAccFinInformation() {
		List<Account> testAccountNumber = [SELECT Id, Name, AccountNumber FROM Account WHERE Name LIKE 'Test Account'];
		Test.startTest();
		BAPI_SF_AccountFinInfo_Resp_IB_v1 testResponse = BAPIAccountFinancialInformation.getAccFinInformation(testAccountNumber.get(0).AccountNumber);
		System.assertEquals(500, testResponse.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void testGetAgentDetails() {
		Test.startTest();
		User testUser = BAPIAccountFinancialInformation.getAgentDetails();
		System.assertNotEquals(null, testUser.AB_Number__c, 'Assert Failed');
		Test.stopTest();
	}

	@isTest
	static void testClientSendEmailABSA() {
		List<Account> testAccountId = [SELECT Id, Name, AccountNumber FROM Account WHERE Name LIKE 'Test Account'];
		Case caseId = [SELECT Id, Subject FROM Case WHERE Subject LIKE 'Test Controller Acct Case'];
		Map<String, String> testMap = new Map<String, String>();
		testMap.put('[Surname]', 'Test');
		testMap.put('[Account number]', '123456789');
		testMap.put('[Arrears]', '12345.89');
		testMap.put('[Client account number]', '123456789');
		testMap.put('[Instalment amount]', '12345.89');
		testMap.put('[Name and Surname]', 'Test Test');
		testMap.put('[Contact number]', '0987654321');
		testMap.put('[Insert email address]', 'test@testagent.com');
		testMap.put('[Instalment date]', '2021-06-25');
		testMap.put('[insert date]', '2021-06-25');
		Test.startTest();
		BAPIAccountFinancialInformation.clientSendEmail(testMap, 'notContacted', 'test@testclient.com', caseId.Id);
		Integer callouts = Limits.getCallouts();
		System.assertNotEquals(1, callouts, 'Assert Failed');
		Test.stopTest();
	}
}