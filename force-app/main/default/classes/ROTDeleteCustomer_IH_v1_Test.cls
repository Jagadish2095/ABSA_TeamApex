@isTest
public class ROTDeleteCustomer_IH_v1_Test {
     
    public static final String POSITIVE_RESPONSE_BODY = '{"DeleteCustomerResponse":{"DeleteCustomerResult":{"HasErrors":true,"HasSystemError":false,"HasValidationErrors":true,"Information":null,"SystemErrorMessage":{"nil":true},"Tag":{"nil":true},"ValidationErrors":{"ServiceValidationResult":{"MemberNames":{"nil":true},"Message":"HSC of key ABSA its effective period must be in the future.","MessageCode":"E604"}},"CustomerKey":"CTMETRO001","EffectiveStartDate":"2021-01-07T00:00:00","GroupRestrictionClusterID":"ABS","GroupRestrictionObjectID":"CQGR0002-JUAT","Result":{"nil":true}}}}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDeleteCustomer_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        ROTDeleteCustomer_Resp_IB_v1 responseBean = callHandlerMethod();
       // System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }
    
     private static ROTDeleteCustomer_Resp_IB_v1 callHandlerMethod() {
        ROTDeleteCustomer_Req_IB_v1 dummyBean = ROTDeleteCustomer_Req_IB_v1.createDummyRequest();
        ROTDeleteCustomer_Resp_IB_v1 responseBean = ROTDeleteCustomer_IH_v1.DeleteCustomer(dummyBean);
        return responseBean;
         
    }
    


}