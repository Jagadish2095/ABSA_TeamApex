/*
* Test Integration Handler Bean for CCIssueCombiCardV1 Service
 * @author André Pietersen
 * @created 2020-11-15
*/
@isTest
public class CCIssueCombiCardV1_IH_v2_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"CCS311O":{"outputCopybook":{"combiNumber":0,"prtPassNumber":"","lvpNumber":0}},"NBSAPDPO":{"outputHeader":{"serviceVersion":"BUSO001","returnCode":0,"echoKey":"","reasonCode":0,"version":""}},"NBSMSGO3":{"outputErrorMessage":{"systemErrorText":"","version":"","numberUserErrors":1,"errorMessageTable":[{"errorMessageCode":"0073","errorMessageIndicator":"E","errorMessageText":"Client WALINM 001 has an active Savings Account , must be  nominated","errorMessageClass":"CCS299"},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""}],"numberUserMessages":1}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.API_MANAGER, new List<String>{CCIssueCombiCardV1_IH_v2.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CCissueCombiCardV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static CCissueCombiCardV1_Resp_IB_v1 callHandlerMethod() {
        CCissueCombiCardV1_Req_IB_v1 CCissueCombiCardV1_Req_IB_v1 = new CCissueCombiCardV1_Req_IB_v1();
        CCissueCombiCardV1_Req_IB_v1 dummyBean = CCissueCombiCardV1_Req_IB_v1.createDummyRequest();
        CCissueCombiCardV1_Resp_IB_v1 responseBean = CCIssueCombiCardV1_IH_v2.CCIssueCombiCardV1(dummyBean);
        return responseBean;
    }
}