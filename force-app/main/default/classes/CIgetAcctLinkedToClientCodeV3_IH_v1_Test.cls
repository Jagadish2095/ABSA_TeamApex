/*
* Test Integration Handler for CIgetAcctLinkedToClientCodeV3 Service
* @author Khaliq A
* @created 2021-02-27
*/
@isTest
public class CIgetAcctLinkedToClientCodeV3_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"CIgetAcctLinkedToClientCodeV3_Resp_IB_v1":{"outTransferred": 2,"msgNo": 200,"msg":"Succesfully got Client Details"}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CIgetAcctLinkedToClientCodeV3_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
        
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        
        Test.stopTest();
    }
    
    private static CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 callHandlerMethod() {
        
        CIgetAcctLinkedToClientCodeV3_Req_IB_v1 dummyBean = CIgetAcctLinkedToClientCodeV3_Req_IB_v1.createDummyRequest();        
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 dummyResponseBean =  CIgetAcctLinkedToClientCodeV3_Resp_IB_v1.dummyResponse();       
        
        CIgetAcctLinkedToClientCodeV3_Resp_IB_v1 responseBean = CIgetAcctLinkedToClientCodeV3_IH_v1.CIgetAcctLinkedToClientCode(dummyBean);
        return responseBean;
    }
    
}