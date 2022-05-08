/*
* Test Integration Handler for IBgetClientDetailsV1 Service
* @author Khaliq A
* @created 2020-10-01
*/
@isTest
public class IBgetClientDetailsV1_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"IBgetClientDetailsV1_Resp_IB_v1":{"outTransferred": 2,"msgNo": 200,"msg":"Succesfully got Client Details"}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IBgetClientDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        IBgetClientDetailsV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static IBgetClientDetailsV1_Resp_IB_v1 callHandlerMethod() {
        
        IBgetClientDetailsV1_Req_IB_v1 dummyBean = IBgetClientDetailsV1_Req_IB_v1.createDummyRequest();        
        IBgetClientDetailsV1_Resp_IB_v1 dummyResponseBean =  IBgetClientDetailsV1_Resp_IB_v1.dummyResponse();       
        
        IBgetClientDetailsV1_Resp_IB_v1 responseBean = IBgetClientDetailsV1_IH_v1.IBgetClientDetails(dummyBean);
        return responseBean;
    }

}