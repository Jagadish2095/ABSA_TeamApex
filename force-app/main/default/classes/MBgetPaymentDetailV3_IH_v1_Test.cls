/**
* @description Test Integration Handler for MBgetPaymentDetailV3 Service
* @author Chandra Bhushan
* @created 2020-03-12

 * @updated 2021-04-09

*/

@IsTest
public class MBgetPaymentDetailV3_IH_v1_Test {


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

        MBgetPaymentDetailV3_Resp_IB_v1 responseBean = callHandlerMethod();

		System.assertEquals(200, responseBean.statusCode, 'Assert failed');


        Test.stopTest();
    }

    private static MBgetPaymentDetailV3_Resp_IB_v1 callHandlerMethod() {
        MBgetPaymentDetailV3_Req_IB_v1 dummyBean = MBgetPaymentDetailV3_Req_IB_v1.createDummyRequest();
        MBgetPaymentDetailV3_Resp_IB_v1 responseBean = MBgetPaymentDetailV3_IH_v1.MBgetPaymentDetailV3(dummyBean.MBgetPaymentDetailV3.Mbp323i.uniqueEft);
        return responseBean;
    }
}