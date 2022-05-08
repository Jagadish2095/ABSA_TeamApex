/**
 * @description Integration Test Class for ServiceCustomerEligibility Service
 * @author  Koketso Mpshane
 * @date    05/05/2021
 * @updated 08/07/2021 - Koketso Mpshane
 */
@isTest
public class ServiceCustomerEligibility_IH_V1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ServiceCustomerAndAccount_v1';
	public static final String STATIC_RESOURCE_NAME_MOCK_NEGATIVE = 'Mock_Negative_ServiceCustomerAndAccount_v1';
	/**
	 * @description Method to create test data
	 */
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ServiceCustomerEligibility_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}
	/**
	 * @description Method to testServiceCustomerEligibility
	 */
	@IsTest
	static void testServiceCustomerEligibility() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();

		ServiceCustomerEligibility_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}
	/**
	 * @description Method to callHandlerMethod
	 * @return ServiceCustomerEligibility_Resp_IB_v1
	 */
	private static ServiceCustomerEligibility_Resp_IB_v1 callHandlerMethod() {
		ServiceCustomerEligibility_Req_IB_v1 dummyBean = ServiceCustomerEligibility_Req_IB_v1.createDummyRequest();
		ServiceCustomerEligibility_Resp_IB_v1 responseBean = ServiceCustomerEligibility_IH_v1.ServiceCustomerEligibilityV1(
			dummyBean.SPID,
			dummyBean.Phonenumber,
			dummyBean.AcctTyp,
			dummyBean.Amount,
			dummyBean.RetrievalReferenceNumber
		);

		return responseBean;
	}
}