/*
 * @description Integration Bean for RewardsGetlookups Test Service
 * @author Jabulani Mashia
 * @created 2021-08-026
 */
@isTest
public class RewardsGetlookups_IH_v1_Test {
	public static final String POSITIVE_RESPONSE_BODY = '{"GetLookupsResponse":{"GetLookupsResult":{"DebitOrderAmounts":{"NonStaffAnnualFee":278.4,"NonStaffMonthlyFee":23.2,"StaffAnnualFee":139.2,"StaffMonthlyFee":11.6},"Languages":{"Language":[{"Code":"CLAAFR","Description":"Afrikaans"},{"Code":"CLAENG","Description":"English"},{"Code":"CLANDE","Description":"Ndebele"},{"Code":"CLANSO","Description":"North Sotho"},{"Code":"CLAOTH","Description":"Other"},{"Code":"CLASSO","Description":"South Sotho"},{"Code":"CLASWA","Description":"Swazi"},{"Code":"CLATSO","Description":"Tsonga"},{"Code":"CLATSW","Description":"Tswana"},{"Code":"CLAVEN","Description":"Venda"},{"Code":"CLAXHO","Description":"Xhosa"},{"Code":"CLAZUL","Description":"Zulu"}]},"MethodResponse":{"ErrorCode":"E0001","ErrorReferenceNumber":"8a558baf-223b-43b4-a21b-934bc6779dda"},"NotificationMethods":{"NotificationMethod":[{"Code":"NOMEMA","Description":"E-Mail"},{"Code":"NOMPOS","Description":"Post"},{"Code":"NOMSMS","Description":"Sms"},{"Code":"NOMTEL","Description":"Telephone"}]},"RedemptionTypes":null,"StatementNotificationMethods":{"StatementNotificationMethod":[{"Code":"NOMEMA","Description":"E-Mail"},{"Code":"NOMPOS","Description":"Post"}]}}}}';

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ rewardsGetlookups_IH_v1.INTEGRATION_SERVICE_NAME });
	}

	@isTest
	static void testPositive() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		Test.startTest();

		RewardsGetlookups_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode);

		Test.stopTest();
	}

	private static RewardsGetlookups_Resp_IB_v1 callHandlerMethod() {
		RewardsGetlookups_Req_IB_v1 dummyBean = RewardsGetlookups_Req_IB_v1.createDummyRequest();
		RewardsGetlookups_Resp_IB_v1 responseBean = RewardsGetlookups_IH_v1.rewardsGetlookups(dummyBean);

		return responseBean;
	}
}