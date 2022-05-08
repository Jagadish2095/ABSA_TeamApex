/**
 *@description Response Integration Bean for CAactionQuotationV6 Test 
 * @author Jabulani Mashia
 * @created 2021-09-06
 **/
@isTest
public with sharing class CAactionQuotationV6_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"CAS096O":{"can096oOutPutArea":{"wkOptInstalItems":73.8,"wkCrlIntRate":17.5,"wkClientDialCode":0,"wkInstalPaymentMWO":"M","wkCrProviderNM":"ABSA CARD","wkBlInstal":0,"wkDateAdded":0,"wkBlInstalXtras":0,"wkCrProviderTel":"11 501-5050","wkBlTotFees":0,"wkAccountFee":25,"wkCrProviderAddr4":"0001","wkCrProviderAddr3":"PRETORIA","wkMonthlyServiceFee":0,"wkCrProviderAddr2":"","wkCrProviderAddr1":"P O BOX 3915","wkiResult":"00","wkQuoteGenReturnCode":"","wkCrlInstal":1500,"wkRbpInd":"N","wkTotalCredit":18000,"wkInitFee":0,"wkOptInstalDesc":"","wkClientTel":"","wkCrlTotFees":0,"wkiNewStatus":"OFF","wkBlTotInterest":0,"wkVariableIntMarkup":14,"wkactType":"INT","wkAcctTypeDesc":"ABSA GOLD CARD VISA GOLD CREDIT CARD","wkTotAllInstals":0,"wkClpPct":0.41,"wkSurname":"","wkCrlTotAllInstal":21150,"wkQuoteCurrentStat":"OFF","wkBlIntRate":0,"wkLcpFee":0,"wkClientLang":"","wkCrlTotInterest":3150,"wkName":"","wkClientAddr1":"","wkClientAddr3":"","wkDateUpdated":1210906,"wkClientAddr2":"","wkClientAddr4":"","wkCrlNbrInstal":12,"wkCrlInstalXtras":262.5,"wkClpAmt":73.8,"wkTotInterestFees":3150,"wkiQuoteNumber":0,"wkBlTotAllInstal":0}}}';
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ CAactionQuotationV6_IH_v1.INTEGRATION_SERVICE_NAME });
	}
	@isTest
	static void testPositive() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		Test.startTest();
		CAactionQuotationV6_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode);
		Test.stopTest();
	}
	private static CAactionQuotationV6_Resp_IB_v1 callHandlerMethod() {
		CAactionQuotationV6_Req_IB_v1 dummyBean = CAactionQuotationV6_Req_IB_v1.createDummyRequest();
		CAactionQuotationV6_Resp_IB_v1 responseBean = CAactionQuotationV6_IH_v1.caActionQuotation(dummyBean);
		return responseBean;
	}
}