/*
 * @description: Test Integration Handler for CQgetInterestRateDetailsV1 Service
 * @author JQUEV
 * @created 2021-01-15
 */

@IsTest
public class CQgetInterestRateDetailsV1_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_CQgetInterestRateDetailsV1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ CQgetInterestRateDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME });
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        CQgetInterestRateDetailsV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertnotEquals(Null, responseBean.statusCode);

        Test.stopTest();
    }

    private static CQgetInterestRateDetailsV1_Resp_IB_v1 callHandlerMethod() {
        CQgetInterestRateDetailsV1_Req_IB_v1.createDummyRequest();
        CQgetInterestRateDetailsV1_Resp_IB_v1 responseBean = CQgetInterestRateDetailsV1_IH_v1.getInterestRateDetails('470703551');
        return responseBean;
    }
}