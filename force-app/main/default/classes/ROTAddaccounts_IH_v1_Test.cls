@isTest
public class ROTAddaccounts_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"AddAccountsResponse":{"AddAccountsResult":{"AccountActionDataResponse":[{"HasErrors":"true","HasSystemError":"false","HasValidationErrors":"true","SystemErrorMessage":null,"Tag":null,"ValidationErrors":{"ServiceValidationResult":[{"Message":"The effective period of the HSC to be created is invalid; its First Date its Last Date.","MessageCode":"E424"}]},"GroupRestrictionClusterID":"ABS","GroupRestrictionObjectID":"CQGR0029-Test","Result":{"Description":null,"EffectiveEndDate":null,"EffectiveStartDate":null,"IsEffectiveEndDateInfinity":null,"ObjectID":null,"EntityType":null,"ParentSchemeNodeID":null,"SchemeNodeID":null},"AccountNumber":"4047081344","EffectiveStartDate":"2021-02-06T00:00:00"}]}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTAddaccounts_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
        ROTAddaccounts_IB_Resp_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ROTAddaccounts_IB_Resp_v1 callHandlerMethod() {
        ROTAddaccounts_IB_Req_v1 dummyBean = ROTAddaccounts_IB_Req_v1.createDummyRequest();
        ROTAddaccounts_IB_Resp_v1 responseBean = ROTAddaccounts_IH_v1.addaccounts(dummyBean);
        return responseBean;
    }
}