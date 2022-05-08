@isTest
public class ROTDeleteExcludedAccount_IH_v1_Test {
    
         public static final String POSITIVE_RESPONSE_BODY = '{"DeleteExcludedAccountResponse":{"DeleteExcludedAccountResult":{"HasErrors":true,"HasSystemError":false,"HasValidationErrors":true,"Information":null,"SystemErrorMessage":{"nil":true},"Tag":{"nil":true},"ValidationErrors":{"ServiceValidationResult":{"MemberNames":{"nil":true},"Message":"HSC of key ABSA may not be deleted; its effective period must be in the future.","MessageCode":"E604"}},"AccountNumber":4048430986,"EffectiveStartDate":"2021-01-08T00:00:00","GroupRestrictionClusterID":"ABS","GroupRestrictionObjectID":"CQGR0002-JUAT","Result":{"nil":true}}}}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDeleteExcludedAccount_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        ROTDeleteExcludedAccount_Resp_IB_v1 responseBean = callHandlerMethod();
       // System.assertEquals(500, responseBean.statusCode);

        Test.stopTest();
    }
    
     private static ROTDeleteExcludedAccount_Resp_IB_v1 callHandlerMethod() {
        ROTDeleteExcludedAccount_Req_IB_v1 dummyBean = ROTDeleteExcludedAccount_Req_IB_v1.createDummyRequest();
        ROTDeleteExcludedAccount_Resp_IB_v1 responseBean = ROTDeleteExcludedAccount_IH_v1.ExcludeAccount(dummyBean);
        return responseBean;
    }
    

}