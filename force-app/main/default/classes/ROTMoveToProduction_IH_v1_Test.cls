@isTest
public class ROTMoveToProduction_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTMoveToProduction_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        callHandlerMethod();
        Test.stopTest();
    }
    
     private static void callHandlerMethod() {
        ROTMoveToProduction_Req_IB_V1 dummyBean = ROTMoveToProduction_Req_IB_V1.createDummyRequest();
        ROTMoveToProduction_IH_v1.moveToProduction(dummyBean);
        //ROTMoveToProduction_Resp_IB_V1 responseBean = ROTMoveToProduction_IH_v1.moveToProduction(dummyBean);
        //return responseBean;
    }
}