/**
 * @description Integration Handler Test for CClistAccsLinkedToCombiV1 Service
 * @author Humbelani Denge
 * @created 2021-02-12
 */
@IsTest
public class CClistAccsLinkedToCombiV1_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_CClistAccsLinkedToCombiV1';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CClistAccsLinkedToCombiV1_IH_v1.INTEGRATION_SERVICE_NAME }
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

		CClistAccsLinkedToCombiV1_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'not equals to 200');

		Test.stopTest();
	}

	private static CClistAccsLinkedToCombiV1_Resp_IB_v1 callHandlerMethod() {
		CClistAccsLinkedToCombiV1_Req_IB_v1 dummyBean = CClistAccsLinkedToCombiV1_Req_IB_v1.createDummyRequest();
		CClistAccsLinkedToCombiV1_Resp_IB_v1 responseBean = CClistAccsLinkedToCombiV1_IH_v1.CCListAccsLinkedToCombi(
			dummyBean.CClistAccsLinkedToACombiCardV1.Ccp308i.combiNbr
		);
		return responseBean;
	}
}