@isTest
public class ROTDateAdjustSchemeNodes_IH_v1_Test {
    
        public static final String POSITIVE_RESPONSE_BODY = '{"DateAdjustSchemeNodesResponse":{"DateAdjustSchemeNodesResult":{"CurrentPage":0,"HasErrors":true,"HasSystemError":true,"HasValidationErrors":false,"Information":null,"IsCurrentPageTheLast":true,"PageToken":{"nil":true},"Records":null,"SystemErrorMessage":"Scheme Node CAsH Deposit does not exist","Tag":{"nil":true},"TotalRecords":0,"ValidationErrors":null}}}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDateAdjustSchemeNodes_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        ROTDateAdjustSchemeNodes_Resp_IB_v1 responseBean = callHandlerMethod();
       // System.assertEquals(500, responseBean.statusCode);

        Test.stopTest();
    }
    
     private static ROTDateAdjustSchemeNodes_Resp_IB_v1 callHandlerMethod() {
        ROTDateAdjustSchemeNodes_Req_IB_v1 dummyBean = ROTDateAdjustSchemeNodes_Req_IB_v1.createDummyRequest();
        ROTDateAdjustSchemeNodes_Resp_IB_v1 responseBean = ROTDateAdjustSchemeNodes_IH_v1.AdjustSchemeNodes(dummyBean);
        return responseBean;
    }
    


}