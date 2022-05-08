/*
* Test Integration Handler for NQlistRecipientsRegForCustV1 Service
* @author Khaliq Abdul
* @created 2020-11-20
*/
@isTest
public class NQlistRecipientsRegForCustV1_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"NQlistRecipientsRegForCustV1_Resp_IB_v1":{"outTransferred": 2,"msgNo": 200,"msg":"Succesfully got Client Reg Details"}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{NQlistRecipientsRegForCustV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        NQlistRecipientsRegForCustV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static NQlistRecipientsRegForCustV1_Resp_IB_v1 callHandlerMethod() {        
        NQlistRecipientsRegForCustV1_Req_IB_v1 dummyBean = NQlistRecipientsRegForCustV1_Req_IB_v1.createDummyRequest();        
        NQlistRecipientsRegForCustV1_Resp_IB_v1 responseBean = NQlistRecipientsRegForCustV1_IH_v1.NQlistRecipientsRegForCustV1(dummyBean);
        return responseBean;
    }
}