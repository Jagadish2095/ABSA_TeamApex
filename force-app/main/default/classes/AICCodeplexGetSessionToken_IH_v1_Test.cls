/**
 * @description Test Integration Handler for AICCodeplexGetSessionToken Service
 * @author JQUEV
 * @created 2020-12-10
 */

@IsTest
public class AICCodeplexGetSessionToken_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AICCodeplexGetSessionToken_v1';

    /**
	 * @description Create test data
	 */
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ AICCodeplexGetSessionToken_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

    /**
	 * @description Test positive
	 */
	@IsTest
	static void testPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();

		AICCodeplexGetSessionToken_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

		Test.stopTest();
	}

    /**
	 * @description Handler method
	 * @return AICCodeplexGetSessionToken_Resp_IB_v1 object
	 */
	private static AICCodeplexGetSessionToken_Resp_IB_v1 callHandlerMethod() {
		AICCodeplexGetSessionToken_Req_IB_v1 dummyBean = AICCodeplexGetSessionToken_Req_IB_v1.createDummyRequest();
		AICCodeplexGetSessionToken_Resp_IB_v1 responseBean = AICCodeplexGetSessionToken_IH_v1.getSessionToken();
		return responseBean;
	}
}