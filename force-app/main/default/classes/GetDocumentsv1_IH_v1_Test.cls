/*
* Test Integration Handler for GetDocumentsv1 Service
* @author Anka Ganta
* @created 2020-07-21
*/

@isTest
public class GetDocumentsv1_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"GenerateDocument": {"ResponseHeader": {"code": "Success","description": "Records have not been quality assured yet"},"ResponseMessage": {"WQacknowledgeDocumentsV1Response": {"nbsapdpo": {"version": "APLO003","returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001"},"wqp132o": {"msgNo": "58","msg": "Records have not been quality assured yet"}}}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GetDocumentsv1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        GetDocumentsv1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static GetDocumentsv1_Resp_IB_v1 callHandlerMethod() {
        GetDocumentsv1_Req_IB_v1 dummyBean = GetDocumentsv1_Req_IB_v1.createDummyRequest();
        GetDocumentsv1_Resp_IB_v1 dummyrespBean = GetDocumentsv1_Resp_IB_v1.createDummyResponse();
        GetDocumentsv1_Resp_IB_v1 responseBean = GetDocumentsv1_IH_v1.getDocuments(dummyBean);
        return responseBean;
    }
}