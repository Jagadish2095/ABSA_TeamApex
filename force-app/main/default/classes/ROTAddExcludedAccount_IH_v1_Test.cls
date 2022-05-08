@isTest
public class ROTAddExcludedAccount_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY ='{"AddExcludedAccountResponse": {"AddExcludedAccountResult": {"HasErrors": "false","HasSystemError": "false", "HasValidationErrors": "false","Information": {"ServiceInformationResult": [{"Message": "HSC of HS Id CQTROT-S/ABS/CQGR0002-JUAT, NUID 0, and First Date 2029-02-05 created successfully. It must be CONFIRMED before it becomes effective. Keep record of its NUID.","MessageCode": "M102"} ] }, "SystemErrorMessage": null,"Tag": "278627","GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result": {"Description": "JB Pillar","EffectiveEndDate": "2029-02-06T00:00:00","EffectiveStartDate": "2029-02-05T00:00:00","IsEffectiveEndDateInfinity": "false","ObjectID": "4048154875","EntityType": "ExcludedAccount","ParentSchemeNodeID": "240745","SchemeNodeID": "278627"},"AccountNumber": "4048154875","EffectiveStartDate": "2029-02-05T00:00:00"}}}';
        
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTAddExcludedAccount_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
        ROTAddExcludedAccount_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ROTAddExcludedAccount_Resp_IB_v1 callHandlerMethod() {
        ROTAddExcludedAccount_Req_IB_v1 dummyBean = ROTAddExcludedAccount_Req_IB_v1.createDummyRequest();
        ROTAddExcludedAccount_Resp_IB_v1 responseBean = ROTAddExcludedAccount_IH_v1.AddExcludedAccount(dummyBean);
        return responseBean;
    }
    
    
}