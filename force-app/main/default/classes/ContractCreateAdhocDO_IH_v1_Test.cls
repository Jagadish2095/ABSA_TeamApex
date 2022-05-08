/*
 * Integration Handler Test class for ContractCreateAdhocDO Service
 * @author Koketso Mpshane
 * @created 2021-02-12

 * @updated 2021-03-12

 */
@isTest
public class ContractCreateAdhocDO_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ContractCreateAdhocDO_v1';
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ ContractCreateAdhocDO_IH_v1.INTEGRATION_SERVICE_NAME }
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

		ContractCreateAdhocDO_Resp_IB_v1 responseBean = callHandlerMethod();

		System.assertEquals(200, responseBean.statusCode, 'Assert failed');


		Test.stopTest();
	}

	private static ContractCreateAdhocDO_Resp_IB_v1 callHandlerMethod() {
		ContractCreateAdhocDO_Req_IB_v1 dummyBean = ContractCreateAdhocDO_Req_IB_v1.createDummyRequest();
		ContractCreateAdhocDO_Resp_IB_v1 responseBean = ContractCreateAdhocDO_IH_v1.contractCreateAdhocDO(
			dummyBean.Contract_CreateAdhocDO.pstrPolicyNumber,
			dummyBean.Contract_CreateAdhocDO.pobjBankContract,
			dummyBean.Contract_CreateAdhocDO.p8dtCollectionDate
		);

		return responseBean;
	}
}