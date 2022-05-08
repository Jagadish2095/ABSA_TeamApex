@isTest
public class ROTCreateGroupRestriction_IH_v1_Test {
	 public static final String POSITIVE_RESPONSE_BODY = '{"CreateGroupRestrictionResponse":{"CreateGroupRestrictionResult":{"HasErrors":"false","HasSystemError":"false","HasValidationErrors":"false","SystemErrorMessage":null,"Tag":null,"GroupRestrictionClusterID":"ABS","GroupRestrictionObjectID":"CQGR0001-TSS","Result":{"Description":"JB Pillar","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"0001-01-01T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"CQGR0001-TSS","EntityType":"GroupRestriction","ParentSchemeNodeID":null,"SchemeNodeID":"278356"}}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTCreateGroupRestriction_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
		ROTCreateGroupRestriction_Resp_IB_v1 responseBean = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTCreateGroupRestriction_Resp_IB_v1 callHandlerMethod() {
        ROTCreateGroupRestriction_Req_IB_v1 dummyBean = ROTCreateGroupRestriction_Req_IB_v1.createDummyRequest();
        ROTCreateGroupRestriction_Resp_IB_v1 responseBean = ROTCreateGroupRestriction_IH_v1.CreateGroupRestriction(dummyBean);
         
        return responseBean;
    }
}