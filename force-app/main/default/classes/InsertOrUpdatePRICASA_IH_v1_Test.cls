@isTest
public class InsertOrUpdatePRICASA_IH_v1_Test {
	@isTest
	static void InsertOrUpdatePRICASAPositiveResponse() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		//Insert Integration Settings
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.INSERT_OR_UPDATE_PRI });

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new InsertOrUpdatePRICASAMock_ApiRest(StringConstants.POSITIVE_STRING));

		Test.startTest();
		// This causes a fake response to be sent from the class that implements HttpCalloutMock.
		InsertOrUpdatePRICASA_Resp_IB_v1 response = InsertOrUpdatePRICASA_IH_v1.insertOrUpdatePRICASA(
			testDataFactory.testAccount,
			testDataFactory.testOpportunity.id,
			UserInfo.getUserId(),
			testDataFactory.testQuote
		);
		//System.assertEquals(500, response.statusCode);
		System.assertNotEquals(response, null);
		Test.stopTest();
	}

	@isTest
	static void InsertOrUpdatePRICASANegativeNoAccountResponse() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		//Insert Integration Settings
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.INSERT_OR_UPDATE_PRI });

		Test.startTest();
		// This causes a fake response to be sent from the class that implements HttpCalloutMock.
		InsertOrUpdatePRICASA_Resp_IB_v1 response = InsertOrUpdatePRICASA_IH_v1.insertOrUpdatePRICASA(
			null,
			null,
			UserInfo.getUserId(),
			testDataFactory.testQuote
		);
		System.assertEquals(500, response.statusCode);
		Test.stopTest();
	}

	@isTest
	static void InsertOrUpdatePRICASANegativeNoMockResponse() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		//Insert Integration Settings
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{ StringConstants.INSERT_OR_UPDATE_PRI });

		Test.startTest();
		// This causes a fake response to be sent from the class that implements HttpCalloutMock.
		InsertOrUpdatePRICASA_Resp_IB_v1 response = InsertOrUpdatePRICASA_IH_v1.insertOrUpdatePRICASA(
			testDataFactory.testAccount,
			testDataFactory.testOpportunity.id,
			UserInfo.getUserId(),
			testDataFactory.testQuote
		);
		System.assertEquals(500, response.statusCode);
		Test.stopTest();
	}

	@isTest
	static void InsertOrUpdatePRICASADummyTest() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new InsertOrUpdatePRICASAMock_ApiRest(StringConstants.POSITIVE_STRING));

		Test.startTest();

		InsertOrUpdatePRICASA_Req_IB_v1 requestBean = new InsertOrUpdatePRICASA_Req_IB_v1();
		requestBean.createDummyRequest();
		System.assertNotEquals(requestBean, null);
		Test.stopTest();
	}

	@isTest
	static void InsertOrUpdatePRICASANoIntegrationSettings() {
		WimiTestDataFactory testDataFactory = new WimiTestDataFactory();

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new InsertOrUpdatePRICASAMock_ApiRest(StringConstants.NEGATIVE_STRING));

		Test.startTest();
		// This causes a fake response to be sent from the class that implements HttpCalloutMock.
		InsertOrUpdatePRICASA_Resp_IB_v1 response = InsertOrUpdatePRICASA_IH_v1.insertOrUpdatePRICASA(
			testDataFactory.testAccount,
			testDataFactory.testOpportunity.id,
			UserInfo.getUserId(),
			testDataFactory.testQuote
		);
		System.assertEquals(500, response.statusCode);
		Test.stopTest();
	}
}