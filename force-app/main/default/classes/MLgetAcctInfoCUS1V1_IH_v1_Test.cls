/** 
 * @description Test Integration Handler for MLgetAcctInfoforCUS1V1Service Service
 * @author Simangaliso Mathenjwa.
 * @since 26 May 2021
 * @updated Koketso Mpshane 08-06-2021
 */
@IsTest
public class MLgetAcctInfoCUS1V1_IH_v1_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MLgetAcctInfoforCUS1V1Service_v1';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ MLgetAcctInfoCUS1V1_IH_v1.INTEGRATION_SERVICE_NAME }
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

		MLgetAcctInfoCUS1V1_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}

    private static MLgetAcctInfoCUS1V1_Resp_IB_v1 callHandlerMethod() {
		MLgetAcctInfoCUS1V1_Req_IB_v1 dummyBean = MLgetAcctInfoCUS1V1_Req_IB_v1.createDummyRequest();
		MLgetAcctInfoCUS1V1_Resp_IB_v1 responseBean = MLgetAcctInfoCUS1V1_IH_v1.getAccountInfo(
			String.valueOf(dummyBean.MLB854I.MLB854I_INPUT_AREA.MLB854I_ACCT_NUMBER),
			dummyBean.MLB854I.MLB854I_INPUT_AREA.MLB854I_REQ_TYPE
		);
		return responseBean;
	}
    
}