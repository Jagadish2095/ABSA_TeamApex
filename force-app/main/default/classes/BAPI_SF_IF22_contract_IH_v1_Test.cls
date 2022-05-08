/**
* @description Test class for the BAPI_SF_IF22_contract_IH_v1 class
* @author  Kabelo Aphane
* @create   7 June 2021
*/
@IsTest
public class BAPI_SF_IF22_contract_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_BAPI_SF_IF22_contractInformation_v1';
	/**
	 * @description Method to create test data
	 */
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{BAPI_SF_IF22_contract_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}
   /**
	 * @description Method to testServiceBAPI_SF_IF22_contractInformation
	 */
	@IsTest
	static void testServiceBAPI_SF_IF22_contractInformation() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();

		BAPI_SF_IF22_contract_Resp_IB_v1 responseBean = callHandlerMethod();
		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}
    /**
	 * @description Method to callHandlerMethod
	 * @return BAPI_SF_IF22_contract_Resp_IB_v1
	 */
	private static BAPI_SF_IF22_contract_Resp_IB_v1 callHandlerMethod() {
		BAPI_SF_IF22_contract_Req_IB_v1 dummyBean = BAPI_SF_IF22_contract_Req_IB_v1.createDummyRequest();
		BAPI_SF_IF22_contract_Resp_IB_v1 responseBean = BAPI_SF_IF22_contract_IH_v1.getBAPISFIF22ContactInfov1(
			dummyBean.BAPI_SF_IF22.I_ACCOUNT
		);

		return responseBean;
	}
}