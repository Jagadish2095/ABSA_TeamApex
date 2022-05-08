/*
 * Integration Handler Test Bean for CCApplicationService cancel
 * @author Prudence Shirindzi
 * @created 2020-10-20
 */

@isTest
public class CCApplicationService_cancel_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{ "cancelApplicationResponse": { "return": { "responseCommons": { "messageTimeStamp": "2020-10-20T15:24:27.078+02:00", "success": "TRUE" } } } }';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CCApplicationService_cancel_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CCApplicationService_cancel_Resp_IB_v1 responseBean = callHandlerMethod();
        //System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static CCApplicationService_cancel_Resp_IB_v1 callHandlerMethod() {
        
        CCApplicationService_cancel_Req_IB_v1 dummyBean = CCApplicationService_cancel_Req_IB_v1.createDummyRequest();
        CCApplicationService_cancel_Resp_IB_v1 responseBean = CCApplicationService_cancel_IH_v1.CCApplicationServiceCancel(dummyBean);

        return responseBean;
    }


}