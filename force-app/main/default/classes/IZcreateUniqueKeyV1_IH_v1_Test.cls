/**
* Get cheque value bundle options response object integration service class test
*  @author Satya Boyenepalli
* @since  10/11/2020
**/
@isTest
public class IZcreateUniqueKeyV1_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"IZBKEYO":{"outputDetails":{"uniqueKey":201110143258849020}},"NBSAPDPO":{"outputHeaders":{"serviceVersion":"BUSO001","returnCode":0,"echoKey":"","reasonCode":0,"version":""}},"NBSMSGO3":{"outputErrorMessages":{"systemErrorText":"","messageEntryTable":[{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""},{"errorMessageCode":"","errorMessageIndicator":"","errorMessageText":"","errorMessageClass":""}],"messageVersion":"","numberUserErrors":0,"numberUserMessages":0}}}';
    
    
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IZcreateUniqueKeyV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive_IZcreateUniqueKeyV1() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        IZcreateUniqueKeyV1_Resp_IB_v1 responseBean = callHandlerMethod();
       /*  System.Debug('response:'+responseBean); */
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static IZcreateUniqueKeyV1_Resp_IB_v1 callHandlerMethod() {
        IZcreateUniqueKeyV1_Req_IB_v1 dummyBean = IZcreateUniqueKeyV1_Req_IB_v1.CreateDummyRequest();
        IZcreateUniqueKeyV1_Resp_IB_v1 responseBean = IZcreateUniqueKeyV1_IH_v1.IZcreateUniqueKey(dummyBean);
        return responseBean;
    }    
    
}