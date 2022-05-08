/**
 * @description Integration Test Class for InvolvedPartiesFlagging Service
 * @author  Humbelani Denge
 * @date    16/06/2021
 */

@IsTest
public class InvolvedParties_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_InvolvedPartiesFlagging_v1';
	/**
	 * @description Method to create test data
	 */
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ 'Involved Parties Create', 'Involved Parties Update' }
		);
	}
	/**
	 * @description Method to create test data
	 */
	@IsTest
	static void testInvolvedPartiesCreate() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();
		Map<String, String> flags = new Map<String, String>();
		InvolvedParties_Req_IB_v1 dummyBean = InvolvedParties_Req_IB_v1.createDummyRequest();
		flags.put(dummyBean.content.flags[0].type.code, dummyBean.content.flags[0].status);
		InvolvedParties_Resp_IB_v1 responseBean = InvolvedParties_IH_v1.involvedPartiesFlagging(flags, 'create', 'TOMATOE002');
		System.assertEquals(200, responseBean.statusCode, 'Assert failed');

		Test.stopTest();
	}

	@IsTest
	static void testInvolvedPartiesUpdate() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();
		Map<String, String> flags = new Map<String, String>();
		InvolvedParties_Req_IB_v1 dummyBean = InvolvedParties_Req_IB_v1.createDummyRequest();
		flags.put(dummyBean.content.flags[0].type.code, dummyBean.content.flags[0].status);
		InvolvedParties_Resp_IB_v1 responseBeanForUpdate = InvolvedParties_IH_v1.involvedPartiesFlagging(flags, 'update', 'TOMATOE002');
		System.assertEquals(200, responseBeanForUpdate.statusCode, 'Assert failed');

		Test.stopTest();
	}
}