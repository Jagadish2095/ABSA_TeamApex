/* @description Lightning cmp controller for View and remove holds(Savings and cheques)
 * Author: Lulu Rankwe
 * Date :  12/06/2020
 */
@isTest
public class CQupdAcctHoldsV4_IH_v1_Test {
	@isTest
	static void CQupdAcctHoldsV4Positive() {
		CQupdAcctHoldsV4_Req_IB_v1 dummyReq = new CQupdAcctHoldsV4_Req_IB_v1();
		CQupdAcctHoldsV4_Req_IB_v1 dummyReqBean = dummyReq.createDummy();
		CQupdAcctHoldsV4_Resp_IB_v1 dummyResponseBean = CQupdAcctHoldsV4_Resp_IB_v1.dummyResponse();

		Test.setMock(HttpCalloutMock.class, new CQupdAcctHoldsV4_Mock_Api(StringConstants.POSITIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.CQ_UPDATE_ACCOUNT_HOLDS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		Test.startTest();
		Map<CQupdAcctHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQupdAcctHoldsV4_IH_v1.callTocqupdacctholdsv4(
			'4047995828',
			'N',
			'Y',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N'
		);
		CQupdAcctHoldsV4_Resp_IB_v1 responseBean = (new List<CQupdAcctHoldsV4_Resp_IB_v1>(responseMap.keySet()))[0];
		system.assertEquals(200, responseBean.statusCode);
		Test.stopTest();
	}

	@isTest
	static void CQupdAcctHoldsV4Negative() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new CQupdAcctHoldsV4_Mock_Api(StringConstants.NEGATIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.CQ_UPDATE_ACCOUNT_HOLDS }
		);

		Test.startTest();
		Map<CQupdAcctHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CQupdAcctHoldsV4_IH_v1.callTocqupdacctholdsv4(
			'000000000',
			'N',
			'Y',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N'
		);
		CQupdAcctHoldsV4_Resp_IB_v1 responseBean = (new List<CQupdAcctHoldsV4_Resp_IB_v1>(responseMap.keySet()))[0];
		system.assertNotEquals(200, responseBean.statusCode);
		Test.stopTest();
	}
}