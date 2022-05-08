/**
 * @description       : Test class for CommercialBureauEnquiry_IH_v1
 * @author            : Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @last modified on  : 2021-06-09
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-09   Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)   Initial Version
 **/

@IsTest
public class CommercialBureauEnquiry_IH_v1_Test {
	private static final String POSITIVE_RESPONSE_BODY = CommercialBureauEnquiry_Resp_IB_v1.getStringDummyResponse();

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ CommercialBureauEnquiry_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}

	@isTest
	public static void testCommercialBureauEnquiry() {
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		String apppcceid = '000000406946';

		Test.startTest();
		String testResponse = JSON.serialize(CommercialBureauEnquiry_IH_v1.commercialBureauEnquiry(apppcceid));
		Test.stopTest();

		System.assert(testResponse.contains(apppcceid));
	}
}