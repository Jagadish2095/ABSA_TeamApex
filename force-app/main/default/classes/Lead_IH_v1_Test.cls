/**
 *  @description Get Absa Instant life Lead response object integration service class test
 *  @author Satya Boyenepalli
 * @since  28/07/2021
 **/

@isTest
public class Lead_IH_v1_Test {
	public static final String POSITIVE_RESPONSE_BODY = '{"ConfirmationId":"95a8d8f0486645f1bb0032283313e2fc","ValidationErrors":[]}';

	/**
	 * @description Test Data

	 */

	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ Lead_IH_v1.INTEGRATION_SERVICE_NAME });
	}

	/**
	 * @description Service Mock Data

	 */
	@isTest
	static void testPositive_Lead() {
		// Set mock callout class
		Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
		Test.startTest();
		Lead_Res_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode);
		Test.stopTest();
	}
	/**
	 * @description Service Call Handler Method
	 *@return Lead_Res_IB_v1
	 */
	private static Lead_Res_IB_v1 callHandlerMethod() {
		Lead_Req_IB_v1 dummyBean = Lead_Req_IB_v1.CreateDummyRequest();
		Lead_Res_IB_v1 dummyRespBean = Lead_Res_IB_v1.dummyResponse();
		Lead_Res_IB_v1 responseBean = new Lead_Res_IB_v1();
		responseBean = Lead_IH_v1.AbsaInstantLifeLead(dummyBean);
		System.assertEquals(200, responseBean.statusCode);
		return responseBean;
	} 
}