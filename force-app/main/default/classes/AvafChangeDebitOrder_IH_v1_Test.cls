/*
 * Test Integration Handler for AvafChangeDebitOrder Service
 * @author Humbelani Denge
 * @created 2020-11-23
 */

@IsTest
public class AvafChangeDebitOrder_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AvafChangeDebitOrder_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ AvafChangeDebitOrder_IH_v1.INTEGRATION_SERVICE_NAME });
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        AvafChangeDebitOrder_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static AvafChangeDebitOrder_Resp_IB_v1 callHandlerMethod() {
        AvafChangeDebitOrder_Req_IB_v1 dummyBean = AvafChangeDebitOrder_Req_IB_v1.createDummyRequest();
        AvafChangeDebitOrder_Resp_IB_v1 responseBean = AvafChangeDebitOrder_IH_v1.AvafChangeDebitOrder(
            dummyBean.I_ACCOUNT,
            dummyBean.BAPI_SF_DO_CHG[0].ZDEBIT_ORDER,
            dummyBean.BAPI_SF_DO_CHG[0].ZCOLDAY,
            dummyBean.BAPI_SF_DO_CHG[0].ZCOLSTARTDATE,
            dummyBean.BAPI_SF_DO_CHG[0].ZCOLENDDATE,
            dummyBean.BAPI_SF_DO_CHG[0].ZCOLAMOUNT,
            dummyBean.BAPI_SF_DO_CHG[0].ZCOLBANKID,
            dummyBean.BAPI_SF_DO_CHG[0].ZBANK_ACC
        );
        return responseBean;
    }
}