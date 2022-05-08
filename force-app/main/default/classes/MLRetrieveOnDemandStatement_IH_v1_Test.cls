/*
 * Test Integration Handler MLRetrieveOnDemandStatement_IH_v1 Service
 *
 * @author  Chandra Bhushan Singh : ABSA
 * @version v1.0
 * @since   2020-12-02
 * @W-
 */

@IsTest
public class MLRetrieveOnDemandStatement_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MLRetrieveOnDemandStatement_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ MLRetrieveOnDemandStatement_IH_v1.INTEGRATION_SERVICE_NAME }
        );
    }

    @IsTest
    static void testPositive() {
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Test.startTest();

        MLRetrieveOnDemandStatement_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static MLRetrieveOnDemandStatement_Resp_IB_v1 callHandlerMethod() {
        MLRetrieveOnDemandStatement_Req_IB_v1 dummyBean = MLRetrieveOnDemandStatement_Req_IB_v1.createDummyRequest();
        MLRetrieveOnDemandStatement_Resp_IB_v1 responseBean = MLRetrieveOnDemandStatement_IH_v1.onDemandStatementRequest(
            dummyBean.numberOfMonths,
            dummyBean.accountType,
            dummyBean.accountNumber
        );
        return responseBean;
    }
}