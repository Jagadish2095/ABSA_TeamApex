/**
 * @description Test Integration Handler for Absa Life get policy schedule
 * @author Bhanumurty Rayala
 * @created 2021-10-19
 */
@isTest
public class AbsaLifeGetPolicySchedule_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GetPolicySchedule_v1';
	@TestSetup
	static void makeData() {
		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ AbsaLifeGetPolicySchedule_IH_v1.INTEGRATION_SERVICE_NAME }
		);
	}
	@isTest
	static void testPolicyScheduleGet() {
		Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);
		Test.startTest();
		String policyNumber = '6637984798';
		AbsaLifeGetPolicySchedule_Resp_IB_v1 responseBean = AbsaLifeGetPolicySchedule_IH_v1.policyScheduleGet(
			policyNumber
		);
		System.assertEquals(200, responseBean.statusCode, 'Assert Failed');
		Test.stopTest();
	}
}