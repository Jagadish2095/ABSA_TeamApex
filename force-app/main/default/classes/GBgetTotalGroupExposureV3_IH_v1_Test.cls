/**
 * Test Class for GBgetTotalGroupExposureV3_IH_v1
 * @author Englarmerdge Mongwe
 * @created 2020/12/29
 */
@IsTest
public class GBgetTotalGroupExposureV3_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"GSB002O":{"GSB002O":{"GSB002O_WORST_ARMS_RISK":"INS","GSB002O_TOT_AVAF_EXP":0,"GSB002O_WORST_ARMS_HOLD":"BDH","GSB002O_TGOE":12184400,"GSB002O_TGE":12184400,"GSB002O_TGAE":0,"GSB002O_TGBE":12184400}},"NBSAPDPO":{"NBSAPLO":{"NBNAPLO_REASON_CODE":0,"NBNAPLO_RETURN_CODE":0,"NBNAPLO_SERVICE_VERSION":"BUSO003"}},"NBSMSGO3":{"NBSMSGO3":{"NBNMSGO3_NBR_USER_ERRS":0,"NBNMSGO3_SYS_ERR_TXT":"","NBNMSGO3_NBR_USER_MSGS":0}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GBgetTotalGroupExposureV3_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        totalGroupTestMock();

        Test.startTest();
        GBgetTotalGroupExposureV3_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    public static void totalGroupTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    private static GBgetTotalGroupExposureV3_Resp_IB_v1 callHandlerMethod() {
        GBgetTotalGroupExposureV3_Req_IB_v1 requestBean = GBgetTotalGroupExposureV3_Req_IB_v1.createDummyRequest();
        GBgetTotalGroupExposureV3_Resp_IB_v1 responseBean = GBgetTotalGroupExposureV3_IH_v1.GBgetTotalGroupExposureV3(requestBean.GSB002I.GSB002I.GSB002I_CLIENT_CODE);
        return responseBean;
    }
}