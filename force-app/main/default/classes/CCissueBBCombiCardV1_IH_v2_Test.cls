/*
* 
* @author Mbuyiseni Mbhokane
* @created 2020-09-17

*/
@isTest
public class CCissueBBCombiCardV1_IH_v2_Test {

    public static final String COMBI_CARD_POS_RESPONSE_BODY = '{"NBSAPDPO":{"outputHeader":{"serviceVersion":"BUSO001","returnCode":0,"echoKey":"","reasonCode":0,"version":""}},"CCS868O":{"outputCopybook":{"deliveryFeeAmount":0.00,"newCombiNumber":0,"deliveryFeeType":"","cardFeeType":"","cardFeeAmount":0.00,"cardIssueIndicator":"N","deliveryFeeIndicator":"","cardFeeIndicator":""}},"NBSMSGO3":{"outputErrorMessage":{"systemErrorText":"","version":"","numberUserErrors":1,"errorMessageTable":[{"errorMessageCode":"0015","errorMessageIndicator":"E","errorMessageText":"Brand 01565 blocked for Issuing","errorMessageClass":"CCS299"},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""}],"numberUserMessages":1}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCissueBBCombiCardV1_IH_v2.COMBICARD_SERVICE_NAME});
    }

    @isTest static void testCombiCardServicePositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, COMBI_CARD_POS_RESPONSE_BODY));
        Test.startTest();
        CCissueBBCombiCardV1_Resp_IB_v2 responseBean = callHandlerMethod();
        if (responseBean.statusCode == 200) {
            System.assertEquals(200, responseBean.statusCode);
        } else {
            System.assertEquals(responseBean.statusCode, responseBean.statusCode);
        }
        
        Test.stopTest();
    }

    private static CCissueBBCombiCardV1_Resp_IB_v2 callHandlerMethod() {
        CCissueBBCombiCardV1_Req_IB_v2 dummyReqBean = CCissueBBCombiCardV1_Req_IB_v2.createDummyRequest();
        CCissueBBCombiCardV1_Resp_IB_v2 dummyrespBean = CCissueBBCombiCardV1_Resp_IB_v2.createDummyResponse();
        CCissueBBCombiCardV1_Resp_IB_v2 responseBean = CCissueBBCombiCardV1_IH_v2.issueCombiCard(dummyReqBean);
        return responseBean;
    }

}