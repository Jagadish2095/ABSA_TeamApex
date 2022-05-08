/*
* Test Integration Handler for BankCodesUpdateCase Service
* @author Thabo K Senkomane
* @created 2020-07-30
*/
@isTest
public class BankCodesUpdateCase_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{ "caseId": "REG-936", "success": true, "status": "UPDATED"}';
   // public static final String POSITIVE_RESPONSE_BODY = ' {"status":"REFERENCE_NOT_FOUND","success":false,"caseId":"REG-936"}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT, new List<String>{BankCodesUpdateCase_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
         
        BankCodesUpdateCase_Resp_IB_v1 responseBean = callHandlerMethod();
           System.assertEquals(200, responseBean.statusCode);
       //  System.assertEquals(true, responseBean.success);
     //  System.assert( responseBean.success);
        Test.stopTest();
    }

    private static BankCodesUpdateCase_Resp_IB_v1 callHandlerMethod() {
        BankCodesUpdateCase_Req_IB_v1 dummyBean = BankCodesUpdateCase_Req_IB_v1.createDummyRequest();
        BankCodesUpdateCase_Resp_IB_v1 dummyresonseBean = BankCodesUpdateCase_Resp_IB_v1.dummyResponse();
        BankCodesUpdateCase_Resp_IB_v1 responseBean = BankCodesUpdateCase_IH_v1.BankCodesUpdateCase(dummyBean);
        return responseBean;
    }
}