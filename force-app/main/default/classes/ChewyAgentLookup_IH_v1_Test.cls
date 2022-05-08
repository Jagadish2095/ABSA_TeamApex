/**
 * @description ChewyAgentLookup_IH_v1_Test test class to test ChewyAgentLookup_IH_v1
 * @author Chandra Bhushan
 * @updated Koketso Mpshane 09/11/2021
 */
@IsTest
public class ChewyAgentLookup_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ChewyAgentLookup_v1';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ ChewyAgentLookup_IH_v1.INTEGRATION_SERVICE_NAME });
	}

	@IsTest
	static void testPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();
		ChewyAgentLookup_Resp_IB_v1 responseBean = callHandlerMethod('EXTC150');
		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	private static ChewyAgentLookup_Resp_IB_v1 callHandlerMethod(String abNumber) {
		ChewyAgentLookup_Resp_IB_v1 responseBean = ChewyAgentLookup_IH_v1.getAgentIdFromChewy(abNumber);
		return responseBean;
	}
}