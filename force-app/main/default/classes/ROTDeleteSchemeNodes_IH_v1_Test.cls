@isTest
public class ROTDeleteSchemeNodes_IH_v1_Test {
    
    
    public static final String POSITIVE_RESPONSE_BODY ='{"DeleteSchemeNodesResponse":{"DeleteSchemeNodesResult":{"CurrentPage":0,"HasErrors":true,"HasSystemError":true,"HasValidationErrors":false,"Information":null,"IsCurrentPageTheLast":true,"PageToken":"","Records":null,"SystemErrorMessage":"Scheme Node ABS does not exist","Tag":"","TotalRecords":0,"ValidationErrors":null}}}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDeleteSchemeNodes_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
        
        ROTDeleteSchemeNodes_Resp_IB_v1 responseBean = callHandlerMethod();
        // System.assertEquals(500, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    private static ROTDeleteSchemeNodes_Resp_IB_v1 callHandlerMethod() {
        ROTDeleteSchemeNodes_Req_IB_v1 dummyBean = ROTDeleteSchemeNodes_Req_IB_v1.createDummyRequest();
        ROTDeleteSchemeNodes_Resp_IB_v1 responseBean = ROTDeleteSchemeNodes_IH_v1.DeleteschemeNodes(dummyBean);
        return responseBean;
    }
    
}