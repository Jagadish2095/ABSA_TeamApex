/**
 * @description Test class for CClistCardSummaryTrackingInfo Service
 * @author Jason Quevauvilliers
 * @created 2021-03-26
 */
@IsTest
public class CClistCardSummaryTrackingInfo_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_CClistCardSummaryTrackingInfo_v1';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CClistCardSummaryTrackingInfo_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@isTest
	static void testGetCardDeliveryDetails() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();
		CClistCardSummaryTrackingInfo_Resp_IB_v1 respBean = callHandlerMethod();
		System.assertEquals(200, respBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}

	/**
	 * @description method to call the Handler class
	 * @return CClistCardSummaryTrackingInfo_Resp_IB_v1
	 */
	private static CClistCardSummaryTrackingInfo_Resp_IB_v1 callHandlerMethod() {
		CClistCardSummaryTrackingInfo_Req_IB_v1 req = CClistCardSummaryTrackingInfo_Req_IB_v1.createDummyRequest();
		CClistCardSummaryTrackingInfo_Resp_IB_v1 respBean = CClistCardSummaryTrackingInfo_IH_v1.getCardDeliveryDetails(
			req.CClistCardSummaryTrackingInfoV2.ccp401i.clientCode
		);
		return respBean;
	}
}