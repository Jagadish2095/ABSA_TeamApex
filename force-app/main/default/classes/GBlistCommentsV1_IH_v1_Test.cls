/**
* @description Test Integration Handler for GBlistCommentsV1 Service
* @author Jagadish Thummala
* @created 2022-04-06
*/
@IsTest
public class GBlistCommentsV1_IH_v1_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_GBlistCommentsV1';

    @TestSetup
    static void makeData(){

		IntegrationTestDataFactory.insertIntegrationSettings(
			StringConstants.JITTERBIT2,
			new List<String>{ GBlistCommentsV1_IH_v1.INTEGRATION_SERVICE_NAME }
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

        GBlistCommentsV1_Resp_IB_V1 responseBean = callHandlerMethod();

		System.assertEquals(200, responseBean.statusCode, 'Assert failed');


        Test.stopTest();
    }
    private static GBlistCommentsV1_Resp_IB_V1 callHandlerMethod() {
        GBlistCommentsV1_Req_IB_v1 dummyBean = GBlistCommentsV1_Req_IB_v1.createDummyRequest();
        GBlistCommentsV1_Resp_IB_V1 responseBean = GBlistCommentsV1_IH_v1.getComments(dummyBean.GBlistCommentsV1.gsp007i.dateFrom,
                                                   dummyBean.GBlistCommentsV1.gsp007i.clientCode,dummyBean.GBlistCommentsV1.gsp007i.inputBranch);
        return responseBean;
    }
}