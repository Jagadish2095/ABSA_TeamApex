@isTest
public class IBupdIBUserNotificationDetailsV1_IH_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"IBupdIBUserNotificationDetailsV1Response":{"nbsapdpo": {"echoKey": null, "reasonCode": 0, "returnCode": 0, "serviceVersion": "BUSO001", "version": null }, "nbsmsgo3": { "msgEntry": { "msgClass": "NHSMGC01",  "msgCode": "0003", "msgErrInd": "E", "msgTxt": "Please capture a valid Access Account number" }, "nbrUserErrs": 1, "nbrUserMsgs": 1,  "sysErrTxt": null, "version": "MSG3001" } }}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IBupdIBUserNotificationDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        IBupdIBUserNotificationDetailsV1_Resp_IB responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static IBupdIBUserNotificationDetailsV1_Resp_IB callHandlerMethod() {

        IBupdIBUserNotificationDetailsV1_Req_IB dummyBean = IBupdIBUserNotificationDetailsV1_Req_IB.createDummyRequest();
        IBupdIBUserNotificationDetailsV1_Resp_IB responseBean = IBupdIBUserNotificationDetailsV1_IH_v1.IBupdIBUserNotificationDetailsV1(dummyBean);
        return responseBean;
    }
}