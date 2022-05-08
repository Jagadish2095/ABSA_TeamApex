/**
 * @description Integration Test Class for Retrieve Tags Service
 * @author  Manideep kenche
 * @date    2021-08-18
 */
@istest
public class RetreiveTag_IH_v1_Test {
	public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_RetrieveTags_v1';

	//creating test data
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ RetreiveTag_IH_v1.INTEGRATION_SERVICE_NAME });
	}
	@IsTest
	static void testPositive() {
		// Set mock callout class
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

		Test.startTest();
		//pass string AGENCY_ID;
		RetreiveTag_Resp_IB_v1 responseBean = RetreiveTag_IH_v1.RetreiveTag('170305299');
		
		System.assertEquals(200, responseBean.statusCode);

		Test.stopTest();
	}
}