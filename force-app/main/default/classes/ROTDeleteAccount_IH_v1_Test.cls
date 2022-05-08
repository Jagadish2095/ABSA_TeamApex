@isTest
public class ROTDeleteAccount_IH_v1_Test {
	public static final String POSITIVE_RESPONSE_BODY = '{"DeleteAccountResponse":{"DeleteAccountResult":{"HasErrors":"true","HasSystemError":"false","HasValidationErrors":"true","SystemErrorMessage":null,"Tag":null,"ValidationErrors":{"ServiceValidationResult":[{"Message":"HSC of key ABSA RSA CQTROT-S ABS CQGR0002-JUAT 42 2021-01-10 may not be deleted; its effective period must be in the future.","MessageCode":"E604"}]},"GroupRestrictionClusterID":"ABS","GroupRestrictionObjectID":"CQGR0002-JUAT","Result":{"Description":null,"EffectiveEndDate":null,"EffectiveStartDate":null,"IsEffectiveEndDateInfinity":null,"ObjectID":null,"EntityType":null,"ParentSchemeNodeID":null,"SchemeNodeID":null},"AccountNumber":"4048430986","EffectiveStartDate":"2021-01-10T00:00:00"}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDeleteAccount_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
		ROTDeleteAccount_IB_Resp_v1 responseBean = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTDeleteAccount_IB_Resp_v1 callHandlerMethod() {
        ROTDeleteAccount_IB_Req_v1 dummyBean = ROTDeleteAccount_IB_Req_v1.createDummyRequest();
        ROTDeleteAccount_IB_Resp_v1 responseBean = ROTDeleteAccount_IH_v1.DeleteAccount(dummyBean);
        return responseBean;
    }
}