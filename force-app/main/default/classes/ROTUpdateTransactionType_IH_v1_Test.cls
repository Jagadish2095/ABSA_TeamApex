@isTest
public class ROTUpdateTransactionType_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{ "UpdateTransactionTypeResponse": { "UpdateTransactionTypeResult": { "HasErrors": "false", "HasSystemError": "false","HasValidationErrors": "false", "SystemErrorMessage": null, "Tag": null, "ValidationErrors": {"ServiceValidationResult": [{ "Message": "", "MessageCode": "" }]}, "GroupRestrictionClusterID": "ABS", "GroupRestrictionObjectID": "CQGR0002-JUAT", "Result": { "Description": null, "EffectiveEndDate":" 2021-01-07T00:00:00", "EffectiveStartDate": "2021-01-07T00:00:00", "IsEffectiveEndDateInfinity": "false", "ObjectID": 1234", "EntityType": "Transaction Types", "ParentSchemeNodeID": "1234", "SchemeNodeID": "1234" }, "Code": "FN71 FIA", "EffectiveStartDate": "2021-01-07T00:00:00"}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTUpdateTransactionType_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ROTUpdateTransactionType_Resp_IB_v1 responseBean = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTUpdateTransactionType_Resp_IB_v1 callHandlerMethod() {
        ROTUpdateTransactionType_Req_IB_v1 dummyBean = ROTUpdateTransactionType_Req_IB_v1.createDummyRequest();
        ROTUpdateTransactionType_Resp_IB_v1 responseBean = ROTUpdateTransactionType_IH_v1.UpdateTransactionType(dummyBean);
        return responseBean;
    }
    
    
}