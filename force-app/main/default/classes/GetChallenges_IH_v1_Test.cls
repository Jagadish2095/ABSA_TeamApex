/**
 * @description test class for GetChallenges hanlder/ service
 * @author Humbelani Denge
 */
@isTest
public class GetChallenges_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GetChallenges_v1';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ GetChallenges_IH_v1.INTEGRATION_SERVICE_NAME });
	}

	@IsTest
	static void testPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();

		GetChallenges_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode);

		Test.stopTest();
	}
	/**
	 * @description calls handler method for dummy call out
	 * @return GetChallenges_Resp_IB_v1
	 */
	private static GetChallenges_Resp_IB_v1 callHandlerMethod() {
		GetChallenges_Req_IB_v1 dummyBean = GetChallenges_Req_IB_v1.createDummyRequest();
		GetChallenges_Resp_IB_v1 responseBean = GetChallenges_IH_v1.GetChallenges(dummyBean.cifKey);
		return responseBean;
	}
}