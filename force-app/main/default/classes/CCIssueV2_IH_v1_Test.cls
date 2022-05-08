/*
* Test Integration Handler for CCIssueV2 Service
* @author Mbuyiseni Mbhokane
* @created 2020-07-27
*/
@isTest  
public class CCIssueV2_IH_v1_Test {
       
    public static final String POSITIVE_RESPONSE_BODY = '{"CCIssueV2Response": {"nbsapdpo": {"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001"},"nbsmsgo": {"version": "MSG3001","nbrUserMsgs": "0","nbrUserErrs": "0"},"ccp311o": {"combiNbr": "1558481219","lvpNbr": "0"}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCIssueV2_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testCombiCardPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CCIssueV2_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static CCIssueV2_Resp_IB_v1 callHandlerMethod() {
        CCIssueV2_Req_IB_v1 dummyReqBean = CCIssueV2_Req_IB_v1.createDummyRequest();
        CCIssueV2_Resp_IB_v1 dummyrespBean = CCIssueV2_Resp_IB_v1.createDummyResponse();
        CCIssueV2_Resp_IB_v1 responseBean = CCIssueV2_IH_v1.ccissue(dummyReqBean);
        return responseBean;
    }

}