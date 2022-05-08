/**
 * @description Integration Test Bean for CopyOfNatis Integration Handler Service
 * @author Bhanumurty Rayala
 * @created 2021-03-04
 */
@isTest
public class AVAFCopyOfNatis_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AVAFCopyOfNatis_v1';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ AVAFCopyOfNatis_IH_v1.INTEGRATION_SERVICE_NAME });
	}

	/**
	 * @description Test Method for a positive scenario
	 */
	@IsTest
	static void testPositive() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();
		AVAFCopyOfNatis_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	/**
	 * @description Method to send a dummy request
	 * @return AVAFCopyOfNatis_Resp_IB_v1 object
	 */
	private static AVAFCopyOfNatis_Resp_IB_v1 callHandlerMethod() {
		AVAFCopyOfNatis_Req_IB_v1 dummyBean = AVAFCopyOfNatis_Req_IB_v1.createDummyRequest();
		AVAFCopyOfNatis_Resp_IB_v1 responseBean = AVAFCopyOfNatis_IH_v1.avafCopyOfNatis(
			dummyBean.userIdNumber,
			dummyBean.userEmail,
			dummyBean.userName,
			dummyBean.accountNumber,
			dummyBean.userSurname
		);
		return responseBean;
	}
}