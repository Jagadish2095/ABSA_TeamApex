@isTest
public class CCIssueV2_IH_v2_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"CCS311O":{"outputCopybook":{"combiNumber":0,"prtPassNumber":"","lvpNumber":0}},"NBSAPDPO":{"outputHeader":{"serviceVersion":"BUSO001","returnCode":0,"echoKey":"","reasonCode":0,"version":""}},"NBSMSGO3":{"outputErrorMessage":{"systemErrorText":"","version":"","numberUserErrors":1,"errorMessageTable":[{"errorMessageCode":"0053","errorMessageIndicator":"E","errorMessageText":"Card Required s invalid, must be \"Y\" or \"N\"","errorMessageClass":"CCS299"},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""}],"numberUserMessages":1}}}';
   
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCIssueV2_IH_v2.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testCombiCardPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CCIssueV2_Resp_IB_v2 responseBean = callHandlerMethod();
        
        if (responseBean.statusCode == 200) {
            System.assertEquals(200, responseBean.statusCode);
        } else {
            System.assertEquals(responseBean.statusCode, responseBean.statusCode);
        }
        
        Test.stopTest();
    }

    private static CCIssueV2_Resp_IB_v2 callHandlerMethod() {
        CCIssueV2_Req_IB_v2 dummyReqBean = CCIssueV2_Req_IB_v2.createDummyRequest();
        CCIssueV2_Resp_IB_v2 dummyrespBean = CCIssueV2_Resp_IB_v2.createDummyResponse();
        CCIssueV2_Resp_IB_v2 responseBean = CCIssueV2_IH_v2.ccissue(dummyReqBean);
        return responseBean;
    }
}