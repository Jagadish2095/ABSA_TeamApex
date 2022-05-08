@isTest
public class ROTAddTransactionTypes_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"AddTransactionTypesResponse": {"AddTransactionTypesResult":{"TransactionTypeActionDataResponse":{"HasErrors": "true","HasSystemError": "false","HasValidationErrors": "true","SystemErrorMessage": null,"Tag": null,"ValidationErrors":{"ServiceValidationResult":[{"Message": "The period of the HSC to be created, (2021-05-24, 2021-05-28), overlaps the period of an already-recorded, twin HSC: (2021-05-24, 2021-05-28).","MessageCode": "E417"}]},"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result":{"Description": null,"EffectiveEndDate": null,"EffectiveStartDate": null,"IsEffectiveEndDateInfinity": null,"ObjectID": null,"EntityType": null, "ParentSchemeNodeID": null,"SchemeNodeID": null}, "Code": "FN71 CWT","EffectiveStartDate": "2021-05-24T00:00:00"}}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTAddTransactionTypes_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ROTAddTransactionTypes_Resp_IB_v1 response  = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTAddTransactionTypes_Resp_IB_v1 callHandlerMethod() {
        ROTAddTransactionTypes_Req_IB_v1 dummyBean = ROTAddTransactionTypes_Req_IB_v1.createDummyRequest();
        ROTAddTransactionTypes_Resp_IB_v1 responseBean = ROTAddTransactionTypes_IH_v1.addTransactionTypes(dummyBean);
        return responseBean;
    }
}