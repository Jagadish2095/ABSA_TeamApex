@isTest
public class ROTDeleteGroupRestriction_IH_v1_Test {
	public static final String POSITIVE_RESPONSE_BODY = '{"DeleteGroupRestrictionResponse":{"DeleteGroupRestrictionResult":{"HasErrors":"true","HasSystemError":"false","HasValidationErrors":"true","SystemErrorMessage":null,"Tag":null,"ValidationErrors":{"ServiceValidationResult":[{"Message":"HSR of key CQTROT-SABS CQGR0002-JUAT may not be deleted; there are HSC nodes in its HS.","MessageCode":"E312"}]},"GroupRestrictionClusterID":"ABS","GroupRestrictionObjectID":"CQGR0002-JUAT","Result":{"Description":null,"EffectiveEndDate":null,"EffectiveStartDate":null,"IsEffectiveEndDateInfinity":null,"ObjectID":null,"EntityType":null,"ParentSchemeNodeID":null,"SchemeNodeID":null}}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDeleteGroupRestriction_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        
        Test.startTest();
        ROTDeleteGroupRestriction_IB_Resp_v1 responseBean = callHandlerMethod();
        //System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }
    
    private static ROTDeleteGroupRestriction_IB_Resp_v1 callHandlerMethod() {
        ROTDeleteGroupRestriction_IB_Req_v1 dummyBean = ROTDeleteGroupRestriction_IB_Req_v1.createDummyRequest();
        ROTDeleteGroupRestriction_IB_Resp_v1 responseBean = ROTDeleteGroupRestriction_IH_v1.DeleteGroupRestriction(dummyBean);
        return responseBean;
    }
}