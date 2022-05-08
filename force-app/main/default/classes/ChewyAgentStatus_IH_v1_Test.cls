/*
 * @description: ChewyAgentStatus_IH_v1_Test test class to test ChewyAgentStatus_IH_v1
 * @author: Chandra Bhushan
 * @updated: 09/03/2021
 */
@isTest
public class ChewyAgentStatus_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ChewyAgentStatus_v1';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ ChewyAgentStatus_IH_v1.INTEGRATION_SERVICE_NAME });
	}

	@isTest
	static void testPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();
		ChewyAgentStatus_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	private static ChewyAgentStatus_Resp_IB_v1 callHandlerMethod() {
		ChewyAgentStatus_Req_IB_v1 requestBean = ChewyAgentStatus_Req_IB_v1.createDummyRequest();
		ChewyAgentStatus_Resp_IB_v1 responseBean = ChewyAgentStatus_IH_v1.ChewyAgentStatus(requestBean);
		return responseBean;
	}
}