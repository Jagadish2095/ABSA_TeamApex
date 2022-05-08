/**
 * @description Test class for UpsertCustomer_ApiRest_v1
 * @author  Jason Quevauvilliers
 * @created 2021-03-12

 * @Modified: JQUEV 2021-03-23

 */
@IsTest
public class UpsertCustomer_ApiRest_v1_Test {
	//@description Positive Create Account in SF (201)
	@isTest
	static void testUpsertCustomer_CreateInSF_Positive() {
		Test.setMock(
			HttpCalloutMock.class,
			new AccountCreate_CIF_MDM_Test.AccountCreate_CIF_MDM_Mock_ApiRest(StringConstants.POSITIVE_STRING, null, null, null, 'Individual', null)
		);
		IntegrationTestDataFactory.insertIntegrationSettingsJitterbit(StringConstants.API_MANAGER, new List<String>{ 'Get Client Details' });

		RestRequest request = new RestRequest();
		request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/upsertCustomer/v01';
		request.httpMethod = 'GET';
		request.addParameter('cifCode', 'TEST   009');
		RestContext.request = request;

		List<Account> beforeAccounts = [SELECT Id FROM Account];
		System.assertEquals(0, beforeAccounts.size(), 'Assert Failed');

		Test.startTest();
		String response = UpsertCustomer_ApiRest_v1.upsertCustomer();
		Test.stopTest();

		List<Account> afterAccounts = [SELECT Id FROM Account];
		System.assertEquals(afterAccounts[0].Id, response, 'Assert Failed');
	}

	//@description Positive Account Found in SF (200)
	@isTest
	static void testUpsertCustomer_FoundInSF_Positive() {
		Account testAcc = new Account();
		testAcc.CIF__c = 'TEST   009';
		testAcc.FirstName = 'TestFirst';
		testAcc.LastName = 'TestLast';
		insert testAcc;

		RestRequest request = new RestRequest();
		request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/upsertCustomer/v01';
		request.httpMethod = 'GET';
		request.addParameter('cifCode', 'TEST   009');
		RestContext.request = request;

		Test.startTest();
		String response = UpsertCustomer_ApiRest_v1.upsertCustomer();
		System.assertEquals(testAcc.Id, response, 'Assert Failed');
		Test.stopTest();
	}

	//@description Negative Create Account in SF (500) No Mock
	@isTest
	static void testUpsertCustomer_CreateInSF_Negative() {
		RestRequest request = new RestRequest();
		request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/upsertCustomer/v01';
		request.httpMethod = 'GET';
		request.addParameter('cifCode', 'TEST   009');
		RestContext.request = request;

		Test.startTest();
		String response = UpsertCustomer_ApiRest_v1.upsertCustomer();

		System.assert(response.startsWith('No Integration_API__c / Integration_Service__c Records Found For This Service'), 'Assert Failed');

		Test.stopTest();
	}

	//@description Bad Request (400)
	@isTest
	static void testUpsertCustomer_BadRequest_Negative() {
		RestRequest request = new RestRequest();
		request.requestUri = System.URL.getSalesforceBaseURL().toExternalForm() + '/services/apexrest/upsertCustomer/v01';
		request.httpMethod = 'GET';
		RestContext.request = request;

		Test.startTest();
		try {
			String response = UpsertCustomer_ApiRest_v1.upsertCustomer();
		} catch (Exception e) {
			System.assertEquals(e.getMessage(), 'Required parameter missing: cifCode', 'Assert Failed');
		}
		Test.stopTest();
	}
}