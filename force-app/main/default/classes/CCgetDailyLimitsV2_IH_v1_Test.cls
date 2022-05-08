/*
* Test Integration Handler Bean for CCgetDailyLimitsV2 Service
 * @author Willy Zuvana
 * @created 2020-10-15
*/
@isTest
public class CCgetDailyLimitsV2_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"CCgetDailyLimitsV2Response":{"ccp312o":{"cardCntLim":999999999,"cardCntMax":999999999,"cardCshLim":10,"cardCshMax":10000,"cardPosLim":10,"cardPosMax":500000,"cardTrfLim":110,"cardTrfMax":5000,"cheqApplNo":0,"cheqCshLim":0,"cheqNomAcc":0,"cheqPosLim":0,"cheqTrfLim":0,"limInd":"Y","savsApplNo":4483850000353637,"savsCshLim":10,"savsNomAcc":9050423693,"savsPosLim":10,"savsTrfLim":110},"nbsapdpo":{"reasonCode":0,"returnCode":0,"serviceVersion":"BUSO001"},"nbsmsgo":{"nbrUserErrs":0,"nbrUserMsgs":0,"version":"MSG3001"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCgetDailyLimitsV2_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CCgetDailyLimitsV2_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static CCgetDailyLimitsV2_Resp_IB_v1 callHandlerMethod() {
        
        CCgetDailyLimitsV2_Req_IB_v1 dummyBean = CCgetDailyLimitsV2_Req_IB_v1.createDummyRequest();
        CCgetDailyLimitsV2_Resp_IB_v1 responseBean = CCgetDailyLimitsV2_IH_v1.CCgetDailyLimitsV2(dummyBean);
        return responseBean;
    }
}