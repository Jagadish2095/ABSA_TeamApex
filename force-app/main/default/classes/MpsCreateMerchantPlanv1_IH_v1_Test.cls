/*
* Test Integration Handler for MpsCreateMerchantPlanv1 Service
* @author Prashant Jain
* @created 2020-06-08
*/

@isTest
public class MpsCreateMerchantPlanv1_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"MPScreateMerchantPlanV1Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001"},"zbp005o":{"mrchAcctNbr":"00000000000000001037894","refNum":"GN20202010378","result":"00000 SUCCESS"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{MpsCreateMerchantPlanv1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        MpsCreateMerchantPlanv1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static MpsCreateMerchantPlanv1_Resp_IB_v1 callHandlerMethod() {
        MpsCreateMerchantPlanv1_Req_IB_v1 dummyBean = MpsCreateMerchantPlanv1_Req_IB_v1.createDummyRequest();
        MpsCreateMerchantPlanv1_Resp_IB_v1 responseBean = MpsCreateMerchantPlanv1_IH_v1.MpsCreateMerchantPlanv1(dummyBean);
        return responseBean;
    }
}