/** 
 * @description Test Integration Handler for MLupdAcctInfoforCUS1V1Service Service
 * @author Simangaliso Mathenjwa
 * @since 26 May 2021
 */
@IsTest
public class MLupdAcctInfoCUS1V1_IH_v1_Test {
    
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MLupdAcctInfoforCUS1V1Service';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ MLupdAcctInfoCUS1V1_IH_v1.INTEGRATION_SERVICE_NAME }
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

		MLupdAcctInfoCUS1V1_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}

    private static MLupdAcctInfoCUS1V1_Resp_IB_v1 callHandlerMethod() {
		MLupdAcctInfoCUS1V1_Req_IB_v1 dummyBean = MLupdAcctInfoCUS1V1_Req_IB_v1.createDummyRequest();
		MLupdAcctInfoCUS1V1_Resp_IB_v1 responseBean = MLupdAcctInfoCUS1V1_IH_v1.doUpdate(
			String.valueOf(dummyBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_ACCT_NUMBER),
			dummyBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_PRIME_ACCT_ID,
            dummyBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_NEW_PAYMENT_DUE_DAY,
            dummyBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_REF_NUMBER,
            dummyBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_SCHM_CODE,
            dummyBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_REQ_TYPE
		);
		return responseBean;
	}

}