/**
 * @description Test class for DLGetExceptionReport Service
 * @author Jason Quevauvilliers
 * @created 2021-03-31

 * @updated Jason Quevauvilliers

 */
@IsTest
public class DLGetExceptionReport_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GetExceptionReport_v1';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ DLGetExceptionReport_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@isTest
	static void testGetExceptionReport() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();
		DLGetExceptionReport_Resp_IB_v1 respBean = callHandlerMethod();
		System.assertEquals(200, respBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	/**
	 * @description method to call the Handler class
	 * @return DLGetExceptionReport_Resp_IB_v1
	 */
	private static DLGetExceptionReport_Resp_IB_v1 callHandlerMethod() {
		DLGetExceptionReport_Req_IB_v1 req = DLGetExceptionReport_Req_IB_v1.createDummyRequest();
		DLGetExceptionReport_Resp_IB_v1 respBean = DLGetExceptionReport_IH_v1.getExceptionReport(req.cifKey);
		return respBean;
	}
}