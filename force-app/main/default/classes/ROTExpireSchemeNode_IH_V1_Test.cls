@isTest
public class ROTExpireSchemeNode_IH_V1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"ExpireSchemeNodeResponse": {"ExpireSchemeNodeResult": {"HasErrors": "true", "HasSystemError": "false","HasValidationErrors": "true","SystemErrorMessage": null,"Tag": null, "ValidationErrors": {"ServiceValidationResult": [ {"Message": "The Split Date for HSC of HS Id CQTROT-S/ABS/{Object ID}, NUID 12, and First Date 2019-06-26 is beyond the last date of the HSC (2021-03-06).","MessageCode": "E411"}]},"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","EffectiveEndDate": null,"EffectiveStartDate": "2019-06-26T00:00:00","EntityType": "Account","ObjectID": "4047081344"}}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTExpireSchemeNode_IH_V1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ROTExpireSchemeNode_Resp_IB_V1 responseBean = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTExpireSchemeNode_Resp_IB_V1 callHandlerMethod() {
        ROTExpireSchemeNode_Req_IB_V1 dummyBean = ROTExpireSchemeNode_Req_IB_V1.createDummyRequest();
        ROTExpireSchemeNode_Resp_IB_V1 responseBean = ROTExpireSchemeNode_IH_V1.getExpireSchemeNode(dummyBean);
        return responseBean;
    }
    
}