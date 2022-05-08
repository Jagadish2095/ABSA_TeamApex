/** 
 * @description Test Integration Handler for GetAvailableVouchers Service
 * @author Simangaliso Mathenjwa.
 * @since 29 November 2021
 */
@IsTest
public class GetAvailableVouchers_IH_IB_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GetAvailableVouchers';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ GetAvailableVouchers_IH_IB_v1.INTEGRATION_SERVICE_NAME }
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

		GetAvailableVouchers_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}

    private static GetAvailableVouchers_Resp_IB_v1 callHandlerMethod() {
		GetAvailableVouchers_Req_IB_v1 dummyBean = GetAvailableVouchers_Req_IB_v1.createDummyRequest();
		GetAvailableVouchers_Resp_IB_v1 responseBean = GetAvailableVouchers_IH_IB_v1.callGetAvailableVouchers(dummyBean.txnReference);
		return responseBean;
	}
}