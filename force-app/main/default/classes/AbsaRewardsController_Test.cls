/** 
 * @description Test class for for AbsaRewardsCloseOrEscalateCTRL 
 * @author Simangaliso Mathenjwa.
 * @since 29 November 2021
 */
@IsTest
public class AbsaRewardsController_Test {

    @IsTest
    public static void getAllChallengesTest() {
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GetChallenges_v1';
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ GetChallenges_IH_v1.INTEGRATION_SERVICE_NAME}
		);

        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

        Test.startTest();
		GetChallenges_Resp_IB_v1 testResponse = AbsaRewardsController.getAllChallenges('MADIDNJ001');
		System.assertEquals(200, testResponse.statusCode, 'Assert Failed');
		Test.stopTest();
    }

    @IsTest
    public static void getVoucherHistoryOfCustomerTest() {
        String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GetVoucherHistoryOfCustomer_v1';
        IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ GetVoucherHistoryOfCustomer_IH_v1.INTEGRATION_SERVICE_NAME}
		);

        Test.setMock(
			HttpCalloutMock.class,
			Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
		);

        Test.startTest();
		GetVoucherHistoryOfCustomer_Resp_IB_v1 testResponse = AbsaRewardsController.getVoucherHistoryOfCustomer('MADIDNJ001', '9101265784089');
		System.assertEquals(200, testResponse.statusCode, 'Assert Failed');
		Test.stopTest();
    }
    
}