/** 
 * @description test class for MBGetPaymentDetailsCntrl
 * @author Jagadish Thummala
 * @created 16/03/2022
 */
@IsTest
public class MBGetPaymentDetailsCntrl_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MBgetPaymentDetailV3_v1';

    @TestSetup
    static void makeData(){

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ MBgetPaymentDetailV3_IH_v1.INTEGRATION_SERVICE_NAME }
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

        MBgetPaymentDetailV3_Resp_IB_v1 responseBean = MBGetPaymentDetailsCntrl.getPaymentDetails('80002D83AB');

		System.assertEquals(200, responseBean.statusCode, 'Assert failed');


        Test.stopTest();
    }

}