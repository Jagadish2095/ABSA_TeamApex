/**
 * @description Integration Test Class for BAPISFAccntDescr Service
 * @author  Koketso Mpshane
 * @date    19/05/2021
 */
@isTest
public class BAPISFAccntDescr_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_BAPISFAccntDescr_v1';
	/**
	 * @description Method to create test data
	 */
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ BAPISFAccntDescr_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}
	/**
	 * @description Method to testBAPISFAccntDescr
	 */
	@IsTest
	static void testBAPISFAccntDescr() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();

        BAPISFAccntDescr_Resp_IB_v1 res = new BAPISFAccntDescr_Resp_IB_v1();
        BAPISFAccntDescr_Resp_IB_v1 responseBean = callHandlerMethod();

		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}

    private static BAPISFAccntDescr_Resp_IB_v1 callHandlerMethod() {
        List<String> accounts = new List<String>{'00090274692', '00074685337', '00074685345'};
		BAPISFAccntDescr_Resp_IB_v1 responseBean = BAPISFAccntDescr_IH_v1.BAPISFAccntDescr(accounts,'ab0131R');
		return responseBean;
	}

}