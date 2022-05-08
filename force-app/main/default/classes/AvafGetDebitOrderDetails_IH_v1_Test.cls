/*
 * Test Integration Handler for AVAF Get Debit Order Details Service
 * @author Danie Booysen
 * @created 2020-11-18
 */
@IsTest
public class AvafGetDebitOrderDetails_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AvafGetDebitOrderDetails_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AvafGetDebitOrderDetails_IH_v1.INTEGRATION_SERVICE_NAME }
        );
    }

    @isTest
    static void testAvafGetDebitOrderDetails() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Test.startTest();
        AvafGetDebitOrderDetails_Resp_IB_v1 respBean = callHandlerMethod();
        System.assertEquals(200, respBean.statusCode);
        Test.stopTest();
    }

    private static AvafGetDebitOrderDetails_Resp_IB_v1 callHandlerMethod() {
        AvafGetDebitOrderDetails_Req_IB_v1 req = AvafGetDebitOrderDetails_Req_IB_v1.createDummyRequest();
        AvafGetDebitOrderDetails_Resp_IB_v1 respBean = AvafGetDebitOrderDetails_IH_v1.AvafGetDebitOrderDetails(req.BAPI_SF_DO_DETAILS[0].I_ACCOUNT);
        return respBean;
    }
}