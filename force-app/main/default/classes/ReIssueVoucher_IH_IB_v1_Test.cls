/** 
 * @description Test Integration Handler for GetAvailableVouchers Service
 * @author Simangaliso Mathenjwa.
 * @since 29 November 2021
 */
@IsTest
public class ReIssueVoucher_IH_IB_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ReIssueVoucher';

    @TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ReIssueVoucher_IH_IB_v1.INTEGRATION_SERVICE_NAME }
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

		ReIssueVoucher_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}

    private static ReIssueVoucher_Resp_IB_v1 callHandlerMethod() {
		ReIssueVoucher_Req_IB_v1 dummyBean = ReIssueVoucher_Req_IB_v1.createDummyRequest();
        Map<String, String> requestFieldsMap = new Map<String, String>();
        requestFieldsMap.put('txnReference', dummyBean.txnReference);
		requestFieldsMap.put('cifKey', dummyBean.cifKey);
		requestFieldsMap.put('idNumber', dummyBean.idNumber);
		requestFieldsMap.put('partnerId', dummyBean.partnerId);
		requestFieldsMap.put('offerId', dummyBean.offerId);
		requestFieldsMap.put('oldRewardPinVoucher', dummyBean.oldRewardPinVoucher);
		requestFieldsMap.put('challengeId', dummyBean.challengeId);
		ReIssueVoucher_Resp_IB_v1 responseBean = ReIssueVoucher_IH_IB_v1.callReissueVoucher(requestFieldsMap);
		return responseBean;
	}
}