/*
* Test Integration Handler for SVcreateLinkSavingsAccount_IH_v1_Test Service
* @author Khaliq A
* @created 2021-10-27
*/

@isTest
public class SVcreateLinkSavingsAccount_IH_v1_Test {

     public static final String POSITIVE_RESPONSE_BODY = '{"SVcreateLinkSavingsAccount_Resp_IB_v1":{"outTransferred": 2,"msgNo": 200,"msg":"Succesfully got Client Details"}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{SVcreateLinkSavingsAccount_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        SVcreateLinkSavingsAccount_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static SVcreateLinkSavingsAccount_Resp_IB_v1 callHandlerMethod() {
        
        SVcreateLinkSavingsAccount_Req_IB_v1 dummyBean = SVcreateLinkSavingsAccount_Req_IB_v1.createDummyRequest();        
        SVcreateLinkSavingsAccount_Resp_IB_v1 dummyResponseBean =  SVcreateLinkSavingsAccount_Resp_IB_v1.dummyResponse();       
        
        SVcreateLinkSavingsAccount_Resp_IB_v1 responseBean = SVcreateLinkSavingsAccount_IH_v1.SVcreateLinkSavingsAccount(dummyBean);
        return responseBean;
    }
}