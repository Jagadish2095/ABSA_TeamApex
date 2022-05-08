/*
* Integration Handler Test class for Triad Service
* @author Almas Aleem: Absa
* @created 2020-11-12
*/
@isTest
public class GetNCARetrieve_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"lookup":"ksession-nca","commands":[{"set-global":{"out-identifier":"NcaDecision","object":{"NcaDecision":{}},"identifier":"ncaDecision"},"insert":{"object":{"Client":{"turnOver":40000,"securedByMortgage":false,"assetValue":20000}}}}]}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GetNCARetrieve_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
        GetNCARetrieve_Resp_IB_V1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    private static GetNCARetrieve_Resp_IB_V1 callHandlerMethod() {
        GetNCARetrieve_Req_IB_V1 dummyBean = GetNCARetrieve_Req_IB_V1.createDummyRequest();                    
        GetNCARetrieve_Resp_IB_V1 responseBean = GetNCARetrieve_IH_v1.GetNCAStatus(1000, 5000);
        GetNCARetrieve_Resp_IB_V1 responseBean2 = GetNCARetrieve_IH_v1.GetNCAStatus2(80000,80000,78,50000,'CR', 2,false,false);  
        
        return responseBean;
    }
}