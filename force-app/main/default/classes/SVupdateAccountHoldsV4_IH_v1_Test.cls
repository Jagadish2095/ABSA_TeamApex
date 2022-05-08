/**
 * @description Lightning cmp controller for View and remove holds(Savings and cheques)
 * Author: Lulu Rankwe
 * Date :  12/06/2020
 */
@isTest
public class SVupdateAccountHoldsV4_IH_v1_Test {
	@isTest
	static void testSVupdateAccountHoldsV4Positive() {
		SVupdateAccountHoldsV4_Req_IB_v1 dummyReq = new SVupdateAccountHoldsV4_Req_IB_v1();
		SVupdateAccountHoldsV4_Req_IB_v1 dummyReqBean = dummyReq.createDummy();
		SVupdateAccountHoldsV4_Resp_IB_v1 dummyResponseBean = SVupdateAccountHoldsV4_Resp_IB_v1.dummyResponse();

		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new SVupdateAccountHoldsV4_Mock_ApiRest(StringConstants.POSITIVE_STRING));
		//Insert Integration Settings
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.SV_UPDATE_ACCOUNT_HOLDS }
		);
		IntegrationTestDataFactory.insertIntegrationTranslations();

		Test.startTest();
		Map<SVupdateAccountHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SVupdateAccountHoldsV4_IH_v1.callTosvupdateaccountholdsV4(
			'9050986380',
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
			'N',
			'N',
			'8089',
			'25699',
			'25699'
		);
		SVupdateAccountHoldsV4_Resp_IB_v1 responseBean = (new List<SVupdateAccountHoldsV4_Resp_IB_v1>(responseMap.keySet()))[0];
		system.assertEquals(200, responseBean.statusCode);
		Test.stopTest();
	}

	@isTest
	static void testSVupdateAccountHoldsV4Negetive() {
		Test.setMock(HttpCalloutMock.class, new SVupdateAccountHoldsV4_Mock_ApiRest(StringConstants.NEGATIVE_STRING));
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT_API_RB_STRING,
			new List<String>{ StringConstants.SV_UPDATE_ACCOUNT_HOLDS }
		);

		Test.startTest();
		Map<SVupdateAccountHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = SVupdateAccountHoldsV4_IH_v1.callTosvupdateaccountholdsV4(
			'',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'Y',
			'N',
			'N',
			'N',
			'N',
			'N',
			'N',
			'0',
			'N',
			'0',
			'N',
			'N',
			'N',
			'N',
			'N'
		);
		SVupdateAccountHoldsV4_Resp_IB_v1 responseBean = (new List<SVupdateAccountHoldsV4_Resp_IB_v1>(responseMap.keySet()))[0];
		system.assertNotEquals(200, responseBean.statusCode);
		Test.stopTest();
	}
}