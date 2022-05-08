/**
 * @description Test Class for AICCodeplexIFrameController
 * @author JQUEV
 * @created 2021-01-04
 * Modified: Changed Custom Label API Name
 */
@IsTest
public class AICCodeplexIFrameControllerTest {
	public static final String CLAIM_NUMBER = '847675';

	@TestSetup
    /**
	 * @description Create test data
	 */
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ AICCodeplexGetSessionToken_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@IsTest
    /**
	 * @description test positive
	 */
	static void testPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
				StringConstants.POSITIVE_STRING,
				AICCodeplexGetSessionToken_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
			)
		);

		Test.startTest();

		String responseUrl = callHandlerMethod();
		System.assertNotEquals(null, responseUrl, 'Assert Failed');

		Test.stopTest();
	}

	@IsTest
	/**
	 * @description Test Negative Case
	 */
	static void testNegative() {
		String responseUrl;
		Test.startTest();
		try {
			responseUrl = callHandlerMethod();
		} catch (Exception e) {
			System.assertEquals(null, responseUrl, 'Assert Failed');
		}
		Test.stopTest();
	}

	/**
	 * @description Handler method to call the class
	 * @return method response
	 */
	private static String callHandlerMethod() {
		String responseUrl = AICCodeplexIFrameController.getIFrameURL(CLAIM_NUMBER);
		return responseUrl;
	}
}