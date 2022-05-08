@isTest
public class ROTUpdateExcludedAccount_IH_V1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"UpdateExcludedAccountResponse": {"UpdateExcludedAccountResult":{"HasErrors": "true","HasSystemError": "false","HasValidationErrors": "true","SystemErrorMessage": null,"Tag": null,"ValidationErrors": {"ServiceValidationResult": [{"Message": "HSC of HS Id CQTROT-S/ABS/CQGR0002-JUAT, NUID 58, and First Date 2021-01-20 may not be updated; it is already effective.","MessageCode": "E405"}]},"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result": {"Description": null,"EffectiveEndDate": null,"EffectiveStartDate": null,"IsEffectiveEndDateInfinity": null,"ObjectID": null,"EntityType": null,"ParentSchemeNodeID": null,"SchemeNodeID": null},"AccountNumber": "4048017641", "EffectiveStartDate": "2021-01-20T00:00:00"}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTUpdateExcludedAccount_IH_V1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ROTUpdateExcludedAccount_Resp_IB_V1 responseBean = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTUpdateExcludedAccount_Resp_IB_V1 callHandlerMethod() {
        ROTUpdateExcludedAccount_Req_IB_V1 dummyBean = ROTUpdateExcludedAccount_Req_IB_V1.createDummyRequest();
        ROTUpdateExcludedAccount_Resp_IB_V1 responseBean = ROTUpdateExcludedAccount_IH_V1.updateExcludedAccount(dummyBean);
        return responseBean;
    }
    
}