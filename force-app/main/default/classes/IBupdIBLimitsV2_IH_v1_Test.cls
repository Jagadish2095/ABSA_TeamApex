@isTest
public class IBupdIBLimitsV2_IH_v1_Test {
     public static final String POSITIVE_RESPONSE_BODY = '{"IBupdIBLimitsV2Response":{"nbsapdpo": {"echoKey": null, "reasonCode": 0, "returnCode": 0, "serviceVersion": "BUSO001", "version": null }, "nbsmsgo3": { "nbrUserErrs": 1, "nbrUserMsgs": 1,  "sysErrTxt": null, "version": "MSG3001" } }}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IBupdIBLimitsV2_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        IBupdIBLimitsV2_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static IBupdIBLimitsV2_Resp_IB_v1 callHandlerMethod() {

        IBupdIBLimitsV2_Req_IB_v1 dummyBean = IBupdIBLimitsV2_Req_IB_v1.createDummyRequest();
        IBupdIBLimitsV2_Resp_IB_v1 responseBean = IBupdIBLimitsV2_IH_v1.IBupdIBLimitsV2(dummyBean);
        return responseBean;
    }
}