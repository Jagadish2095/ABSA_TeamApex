/*
* Test Integration Handler for IBgetClientDetailsV1 Service
* @author Khaliq Abdul
* @created 2020-10-30
*/
@isTest
public class CAactionQuotationV4_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"CAactionQuotationV4_Resp_IB_v1":{"outTransferred": 2,"msgNo": 200,"msg":"Succesfully got Quotation Details"}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CAactionQuotationV4_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        CAactionQuotationV4_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static CAactionQuotationV4_Resp_IB_v1 callHandlerMethod() {
        
        CAactionQuotationV4_Req_IB_v1 dummyBean = CAactionQuotationV4_Req_IB_v1.createDummyRequest();        
        CAactionQuotationV4_Resp_IB_v1 dummyResponseBean =  CAactionQuotationV4_Resp_IB_v1.dummyResponse();
        CAactionQuotationV4_Resp_IB_v1 responseBean = CAactionQuotationV4_IH_v1.CAactionQuotation(dummyBean);
        return responseBean;
    }
}