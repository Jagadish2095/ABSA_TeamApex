/**
 * @description Integration Test Class for ServiceAccountAdjustment Service
 * @author  Koketso Mpshane
 * @date    05/05/2021
 * @updated 08/07/2021 - Koketso Mpshane
 */
@isTest
public class ServiceAccountAdjustment_IH_V1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ServiceCustomerAndAccount_v1';
	public static final String STATIC_RESOURCE_NAME_MOCK_NEGATIVE = 'Mock_Negative_ServiceCustomerAndAccount_v1';
	/**
	 * @description Method to create test data
	 */
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ServiceAccountAdjustment_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}
	/**
	 * @description Method to testServiceAccountAdjustment
	 */
	@IsTest
	static void testServiceAccountAdjustment() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();

		ServiceAccountAdjustment_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}
	/**
	 * @description Method to callHandlerMethod
	 * @return ServiceAccountAdjustment_Resp_IB_v1
	 */
	private static ServiceAccountAdjustment_Resp_IB_v1 callHandlerMethod() {
		ServiceAccountAdjustment_Req_IB_v1 dummyBean = ServiceAccountAdjustment_Req_IB_v1.createDummyRequest();
		ServiceAccountAdjustment_Resp_IB_v1 responseBean = ServiceAccountAdjustment_IH_v1.ServiceAccountAdjustmentV1(
			dummyBean.SPID,
			dummyBean.Phonenumber,
			dummyBean.AcctTyp,
			dummyBean.AccNumber,
			dummyBean.Amount,
			dummyBean.RetrievalReferenceNumber
		);

		return responseBean;
	}
}