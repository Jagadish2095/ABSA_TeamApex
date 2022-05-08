@istest
public class ROTAddCustomer_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY =  '{"AddCustomerResponse": {"AddCustomerResult": { "HasErrors": "true","HasSystemError": "false", "HasValidationErrors": "true", "SystemErrorMessage": null,"Tag": null, "ValidationErrors": {  "ServiceValidationResult": [ { "Message": "The period of the HSC to be created, (2024-01-21, 2024-02-06), overlaps the period of an already-recorded, twin HSC: (2022-01-28, 9999-12-31).",  "MessageCode": "E417" } ]}, "GroupRestrictionClusterID": "ABS", "GroupRestrictionObjectID": "CQGR0002-JUAT", "Result": { "Description": null, "EffectiveEndDate": null, "EffectiveStartDate": null,"IsEffectiveEndDateInfinity": null,"ObjectID": null,"EntityType": null,"ParentSchemeNodeID": null, "SchemeNodeID": null },"CustomerKey": "CTMETRO001","EffectiveStartDate": "2024-01-21T00:00:00"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTAddCustomer_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        ROTAddCustomer_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }
    
     private static ROTAddCustomer_Resp_IB_v1 callHandlerMethod() {
        ROTAddCustomer_Req_IB_v1 dummyBean = ROTAddCustomer_Req_IB_v1.createDummyRequest();
        ROTAddCustomer_Resp_IB_v1 responseBean = ROTAddCustomer_IH_v1.AddCustomer(dummyBean);
        return responseBean;
    }
    

}