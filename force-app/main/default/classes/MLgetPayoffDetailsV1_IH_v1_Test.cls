/** 
 * @description Test Integration Handler for MLgetPayoffDetailsV1 Service
 * @author Jason Quevauvilliers
 * @created 2020-10-20
 * Edited by Simangaliso: 27 Aug 2021
 */

@IsTest
public class MLgetPayoffDetailsV1_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MLgetPayoffDetailsV1_v1';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ MLgetPayoffDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@IsTest
	static void testPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();

		MLgetPayoffDetailsV1_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}

	/**
	 * @description dummy method
	 * @return MLgetPayoffDetailsV1_Resp_IB_v1
	 */
	private static MLgetPayoffDetailsV1_Resp_IB_v1 callHandlerMethod() {
		MLgetPayoffDetailsV1_Req_IB_v1 dummyBean = MLgetPayoffDetailsV1_Req_IB_v1.createDummyRequest();
		MLgetPayoffDetailsV1_Resp_IB_v1 responseBean = MLgetPayoffDetailsV1_IH_v1.MLgetPayoffDetailsV1(
			dummyBean.mLgetPayoffDetailsV1.mlp778i.mortgageLoanNo,
			dummyBean.mLgetPayoffDetailsV1.mlp778i.payAllAcc,
			dummyBean.mLgetPayoffDetailsV1.mlp778i.effectiveDate,
			dummyBean.mLgetPayoffDetailsV1.mlp778i.includeCommit
		);
		return responseBean;
	}
}