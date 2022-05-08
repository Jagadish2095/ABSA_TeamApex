/*
* Test Integration Handler Bean for CCUpdDailyTansactionLimitsV2 Service
 * @author Willy Zuvana
 * @created 2020-11-11
*/
@isTest
public class CCUpdDailyTansactionLimitsV2_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"CCupdDailyTransactionLimitsV2Response":{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":null},"nbsmsgo":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}},"ccp321o":{"limRec":"Y"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCUpdDailyTansactionLimitsV2_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CCUpdDailyTansactionLimitsV2_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static CCUpdDailyTansactionLimitsV2_Resp_IB_v1 callHandlerMethod() {
        
        CCUpdDailyTansactionLimitsV2_Req_IB_v1 dummyBean = CCUpdDailyTansactionLimitsV2_Req_IB_v1.createDummyRequest();
        CCUpdDailyTansactionLimitsV2_Resp_IB_v1 responseBean = CCUpdDailyTansactionLimitsV2_IH_v1.CCUpdDailyTansactionLimitsV2(dummyBean);
        return responseBean;
    }
}