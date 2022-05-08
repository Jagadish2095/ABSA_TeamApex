/*
* Test Integration Handler for CIupdAcctDtlsForClientV1 Service
* @author Rudolf Niehaus
* @created 2020-10-03
 * 1.1   2021-05-27   André Pietersen (IQ Business)   Added CORP code
 * 1.2   2021-05-27   André Pietersen (IQ Business)   Added Multiple SOF
 * 1.3   2021-05-27   Brian Maswanganganyi            Change SOF to SOFSOI
 * 1.4   2021-10-25   André Pietersen (IQ Business)   Changed to SOF with front-end changes
*/

@isTest
public class CIupdAcctDtlsForClientV1_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"CIupdAcctDtlsForClientV1Response":{"nbsapdpo":{"echoKey":null,"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO001","version":null},"nbsmsgo3":{"msgEntry":{"msgClass":"CLSMGC01","msgCode":"0593","msgErrInd":"E","msgTxt":"INVALID TELLER NUMBER"},"nbrUserErrs":1,"nbrUserMsgs":1,"sysErrTxt":null,"version":"MSG3001"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CIupdAcctDtlsForClientV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        CIupdAcctDtlsForClientV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(500, responseBean.statusCode); //Invalid teller code

        Test.stopTest();
    }

    private static CIupdAcctDtlsForClientV1_Resp_IB_v1 callHandlerMethod() {
        CIupdAcctDtlsForClientV1_Req_IB_v1 dummyBean = CIupdAcctDtlsForClientV1_Req_IB_v1.createDummyRequest();
        CIupdAcctDtlsForClientV1_Resp_IB_v1 responseBean = CIupdAcctDtlsForClientV1_IH_v1.CIupdAcctDtlsForClientV1(dummyBean);
        return responseBean;
    }
}