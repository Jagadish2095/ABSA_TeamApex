/*
* Test Integration Handler for EImaintainESDDetailsV3 Service
* @author Khaliq A
* @created 2020-12-03
*/
@isTest
public class EImaintainESDDetailsV3_IH_v2_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"EImaintainESDDetailsV3_Resp_IB_v1":{"outTransferred": 2,"msgNo": 200,"msg":"Succesfully got Client Details"}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{EImaintainESDDetailsV3_IH_v2.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        EImaintainESDDetailsV3_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static EImaintainESDDetailsV3_Resp_IB_v1 callHandlerMethod() {
        
        EImaintainESDDetailsV3_Req_IB_v1 dummyBean = EImaintainESDDetailsV3_Req_IB_v1.createDummyRequest();        
        EImaintainESDDetailsV3_Resp_IB_v1 dummyResponseBean =  EImaintainESDDetailsV3_Resp_IB_v1.dummyResponse();       
        
        EImaintainESDDetailsV3_Resp_IB_v1 responseBean = EImaintainESDDetailsV3_IH_v2.EImaintainESDDetails(dummyBean);
        return responseBean;
    }

}