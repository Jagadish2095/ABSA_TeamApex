/**
 * @description Integration Test Class for ServiceProvidersDataEnquiry Service
 * @author  Koketso Mpshane
 * @date    05/05/2021
 */
@isTest
public class ServiceProvidersDataEnquiry_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ServiceProvidersDataEnquiry_v1';
	/**
	 * @description Method to create test data
	 */
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ServiceProvidersDataEnquiry_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}
	/**
	 * @description Method to create test data
	 */
	@IsTest
	static void testServiceProvidersDataEnquiry() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();
		Map<String, String> customHeaders = new Map<String, String>();
		customHeaders.put('currentversion', '1.0');
		ServiceProvidersDataEnquiry_Resp_IB_v1 responseBean = ServiceProvidersDataEnquiry_IH_v1.serviceProvidersDataEnquiry(customHeaders);
		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}
}