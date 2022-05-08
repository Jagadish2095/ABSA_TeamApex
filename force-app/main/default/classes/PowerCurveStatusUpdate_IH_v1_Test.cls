/*
 * Handler test class for PowerCurveStatusUpdate Service
 * @author Saurabh Pandey
 * @created 2020-11-19
 */
@isTest
public class PowerCurveStatusUpdate_IH_v1_Test {
        public static final String POSITIVE_RESPONSE_BODY = '{ "Response": { "ApplicationDV": { "APPERRMSG": "000" } } }';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{PowerCurveStatusUpdate_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest 
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        PowerCurveStatusUpdate_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }
 
    private static PowerCurveStatusUpdate_Resp_IB_v1 callHandlerMethod() {
        PowerCurveStatusUpdate_Req_IB_v1 dummyBean = PowerCurveStatusUpdate_Req_IB_v1.createDummyRequest();
        PowerCurveStatusUpdate_Resp_IB_v1 responseBean = PowerCurveStatusUpdate_IH_v1.PowerCurveStatusUpdate(dummyBean);
        return responseBean;
    }

    

}