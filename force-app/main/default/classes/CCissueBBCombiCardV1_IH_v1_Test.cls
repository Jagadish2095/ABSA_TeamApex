/*
* Test Integration Handler for CCissueBBCombiCardV1 Service
* @author Mbuyiseni Mbhokane
* @created 2020-07-27
*/
@isTest
public class CCissueBBCombiCardV1_IH_v1_Test {
    
    public static final String COMBI_CARD_POSITIVE_RESPONSE_BODY = '{"CCissueBBCombiCardV1Response": {"nbsapdpo": {"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001"},"nbsmsgo3": {"nbrUserMsgs": "1","nbrUserErrs": "1","msgEntry": {"msgClass": "CCS299","msgCode": "0014","msgErrInd": "E","msgTxt": "Brand 00231 does not exist on table"}},"ccp868o": {"cardIssueInd": "N","newCombiNbr": "00000000000000000","cardFeeInd": null,"cardFeeType": null,"cardFeeAmnt": "0","delvFeeInd": null,"delvFeeAmnt": "0"}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCissueBBCombiCardV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testCombiCardPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, COMBI_CARD_POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CCissueBBCombiCardV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static CCissueBBCombiCardV1_Resp_IB_v1 callHandlerMethod() {
        CCissueBBCombiCardV1_Req_IB_v1 dummyReqBean = CCissueBBCombiCardV1_Req_IB_v1.createDummyRequest();
        //CCissueBBCombiCardV1_Req_IB_v1 reqBean = CCissueBBCombiCardV1_IU_v1.mapRequestFields();
        CCissueBBCombiCardV1_Resp_IB_v1 dummyrespBean = CCissueBBCombiCardV1_Resp_IB_v1.createDummyResponse();
        CCissueBBCombiCardV1_Resp_IB_v1 responseBean = CCissueBBCombiCardV1_IH_v1.ccissueBBCombiCard(dummyReqBean);
        return responseBean;
    }

}