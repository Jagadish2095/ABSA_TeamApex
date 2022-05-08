@isTest
public class ROTAddAccount_IH_v1_Test {
    
      public static final String POSITIVE_RESPONSE_BODY = '{ "AddAccountResponse": { "AddAccountResult": {"HasErrors": "false", "HasSystemError": "false", "HasValidationErrors": "false", "Information": { "ServiceInformationResult": [ { "Message": "HSC of HS Id CQTROT-S/ABS/CQGR0002-JUAT, NUID 0, and First Date 2021-06-16 created successfully. It must be CONFIRMED before it becomes effective. Keep record of its NUID.",  "MessageCode": "M102" } ] }, "SystemErrorMessage": null,"Tag": "278305", "GroupRestrictionClusterID": "ABS", "GroupRestrictionObjectID": "CQGR0002-JUAT","Result": {"Description": "JB Pillar", "EffectiveEndDate": "2021-06-26T00:00:00", "EffectiveStartDate": "2021-06-16T00:00:00", "IsEffectiveEndDateInfinity": "false", "ObjectID": "4048017641",  "EntityType": "Account", "ParentSchemeNodeID": "240745", "SchemeNodeID": "278305"  }, "AccountNumber": "4048017641", "EffectiveStartDate": "2021-06-16T00:00:00"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTAddAccount_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
        ROTAddAccount_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ROTAddAccount_Resp_IB_v1 callHandlerMethod() {
        ROTAddAccount_Req_IB_v1 dummyBean = ROTAddAccount_Req_IB_v1.createDummyRequest();
        ROTAddAccount_Resp_IB_v1 responseBean = ROTAddAccount_IH_v1.AddAccount(dummyBean);
        return responseBean;
    }
    
    

}