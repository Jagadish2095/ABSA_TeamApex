@isTest
public class ROTAddExcludedAccounts_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{ "AddExcludedAccountsResponse": {"AddExcludedAccountsResult": {"ExcludedAccountActionDataResponse": [{"HasErrors": "true","HasSystemError": "false","HasValidationErrors": "true", "SystemErrorMessage": null, "Tag": null, "ValidationErrors": { "ServiceValidationResult": [{ "Message": "The period of the HSC to be created, (2021-02-26, 2021-02-26), overlaps the period of an already-recorded, twin HSC: (2021-02-26, 2021-02-26).", "MessageCode": "E417" } ]}, "GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT", "Result": { "Description": null,  "EffectiveEndDate": null, "EffectiveStartDate": null, "IsEffectiveEndDateInfinity": null, "ObjectID": null, "EntityType": null, "ParentSchemeNodeID": null, "SchemeNodeID": null }, "AccountNumber": "4048430986","EffectiveStartDate": "2021-02-26T00:00:00" }, { "HasErrors": "true","HasSystemError": "false", "HasValidationErrors": "true", "SystemErrorMessage": null, "Tag": null, "ValidationErrors": { "ServiceValidationResult": [ { "Message": "Invalid account number - account does not exist.", "MessageCode": null }] }, "GroupRestrictionClusterID": "ABS", "GroupRestrictionObjectID": "CQGR0002-JUAT", "Result": { "Description": null, "EffectiveEndDate": null, "EffectiveStartDate": null,"IsEffectiveEndDateInfinity": null,"ObjectID": null, "EntityType": null, "ParentSchemeNodeID": null,"SchemeNodeID": null},"AccountNumber": "4048430987","EffectiveStartDate": "2021-02-11T00:00:00"}]}}}';

    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTAddExcludedAccounts_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
        ROTAddExcludedAccounts_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ROTAddExcludedAccounts_Resp_IB_v1 callHandlerMethod() {
        ROTAddExcludedAccounts_Req_IB_v1 dummyBean = ROTAddExcludedAccounts_Req_IB_v1.createDummyRequest();
        ROTAddExcludedAccounts_Resp_IB_v1 responseBean = ROTAddExcludedAccounts_IH_v1.addExcludedAccounts(dummyBean);
        return responseBean;
    }
    
}