/**
 * Integration Handler Test class  for Cqupdautooverdraftloadv2_IH_v1 Service
 * @author Gulafsha
 * @created 2021-03-14
 */

@isTest
public class Cqupdautooverdraftloadv2_IH_v1_Test {
public static final String POSITIVE_RESPONSE_BODY ='{"statusCode" : 200,"status" : "OK","message" : null,"Fault" : null,"NBSMSGO3" : {"errorMessagesOutput" : {"versionNumber" : "","systemErrorText" : "","numberUserMessages" : 0,"numberUserErrors" : 0,"messageEntryTable" : [ {"messageErrorIndicator" : "","messageCode" : "","messageClass" : "","errorMessageText" : ""}, {"messageErrorIndicator" : "","messageCode" : "","messageClass" : "","errorMessageText" : ""}, {"messageErrorIndicator" : "","messageCode" : "","messageClass" : "","errorMessageText" : ""}, {"messageErrorIndicator" : "","messageCode" : "","messageClass" : "","errorMessageText" : ""}, {"messageErrorIndicator" : "","messageCode" : "","messageClass" : "","errorMessageText" : ""} ]}},"NBSAPDPO" : {"outputHeaders" : {"version" : "","serviceVersion" : "BUSO002","returnCode" : 0,"reasonCode" : 0,"echoKey" : ""}},"CQS573O" : {"outputArea" : {"outputReturnCode" : 0,"outputErrorDescription" : "SUCCESSFUL"}}}';
@TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{Cqupdautooverdraftloadv2_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
     @isTest static void testPositive() {
        // Set mock callout class
        mbCreateInstTestMock();

        Test.startTest();

        Cqupdautooverdraftloadv2_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    public static void mbCreateInstTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    private static Cqupdautooverdraftloadv2_Resp_IB_v1 callHandlerMethod() {
        Cqupdautooverdraftloadv2_Req_IB_v1 dummyBean = Cqupdautooverdraftloadv2_Req_IB_v1.createDummyRequest();
        Cqupdautooverdraftloadv2_Resp_IB_v1 responseBean = Cqupdautooverdraftloadv2_IH_v1.executeService(dummyBean);
        return responseBean;
    }

}