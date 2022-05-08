/**
 * @description test class for GetVoucherHistoryOfCustomer_IH_v1 hanlder/service
 * @author Humbelani Denge
 */
@isTest
public class GetVoucherHistoryOfCustomer_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GetVoucherHistoryOfCustomer_v1';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ GetVoucherHistoryOfCustomer_IH_v1.INTEGRATION_SERVICE_NAME }
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

		GetVoucherHistoryOfCustomer_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode);

		Test.stopTest();
	}
	/**
	 * @description calls handler method for dummy call out
	 * @return GetVoucherHistoryOfCustomer_Resp_IB_v1
	 */
	private static GetVoucherHistoryOfCustomer_Resp_IB_v1 callHandlerMethod() {
		GetVoucherHistoryOfCustomer_Req_IB_v1 dummyBean = GetVoucherHistoryOfCustomer_Req_IB_v1.createDummyRequest();
		GetVoucherHistoryOfCustomer_Resp_IB_v1 responseBean = GetVoucherHistoryOfCustomer_IH_v1.GetVoucherHistoryOfCustomer(
			dummyBean.cifKey,
			dummyBean.header.applicationId
		);
		return responseBean;
	}
}