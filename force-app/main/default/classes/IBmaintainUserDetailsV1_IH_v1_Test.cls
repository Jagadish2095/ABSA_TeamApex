/*
 * IBmaintainUserDetailsV1 Service Test
 * @author Willy Zuvana
 * @created 2021-07-06
 */
@isTest
public class IBmaintainUserDetailsV1_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"IBmaintainUserDetailsV1Response":{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":null},"nbsmsgo":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":[{"msgClass":"NHSMGC01","msgCode":"0042","msgErrInd":"E","msgTxt":"User name (SAM SMITH) or ID Passport (1212323) duplicated"}]}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IBmaintainUserDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        IBmaintainUserDetailsV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static IBmaintainUserDetailsV1_Resp_IB_v1 callHandlerMethod() {
        IBmaintainUserDetailsV1_Req_IB_v1 dummyBean = IBmaintainUserDetailsV1_Req_IB_v1.createDummyRequest();
        IBmaintainUserDetailsV1_Resp_IB_v1 responseBean = IBmaintainUserDetailsV1_IH_v1.IBmaintainUserDetailsV1(dummyBean);
        return responseBean;
    }
}