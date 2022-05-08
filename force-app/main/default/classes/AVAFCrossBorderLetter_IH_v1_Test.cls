/**
 * @description Test Integration Handler AVAFCrossBorderLetter_IH_v1 Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-11-16
 * @W-006962
 */

@IsTest
public class AVAFCrossBorderLetter_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AVAFCrossBorderLetter_v1';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ AVAFCrossBorderLetter_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@IsTest
	static void testPositive() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();

		AVAFCrossBorderLetter_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode);

		Test.stopTest();
	}

	private static AVAFCrossBorderLetter_Resp_IB_v1 callHandlerMethod() {
		AVAFCrossBorderLetter_Req_IB_v1 dummyBean = AVAFCrossBorderLetter_Req_IB_v1.createDummyRequest();
		AVAFCrossBorderLetter_Resp_IB_v1 responseBean = AVAFCrossBorderLetter_IH_v1.crossBorderLetterRequest(
			dummyBean.accountNumber,
			dummyBean.userEmail,
			dummyBean.userIdNumber,
			dummyBean.userName,
			dummyBean.userSurname,
			dummyBean.driverName,
			dummyBean.driverIdNumber,
			dummyBean.periodStart,
			dummyBean.periodEnd
		);
		return responseBean;
	}
}