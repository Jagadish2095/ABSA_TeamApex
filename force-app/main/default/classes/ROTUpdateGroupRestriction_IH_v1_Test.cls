@isTest
public class ROTUpdateGroupRestriction_IH_v1_Test {
	public static final String POSITIVE_RESPONSE_BODY = '{"UpdateGroupRestrictionResponse":{"UpdateGroupRestrictionResult":{"HasErrors":"false","HasSystemError":"false","HasValidationErrors":"false","Information":{"ServiceInformationResult":[{"Message":"HSR of key CQTROT-S ABS CQGR0001-test updated successfully. It must be CONFIRMED before it becomes effective.","MessageCode":"M012"}]},"SystemErrorMessage":null,"Tag":null,"GroupRestrictionClusterID":"ABS","GroupRestrictionObjectID":"CQGR0001-test","Result":{"Description":"JB Pillar Muvhuso 1","EffectiveEndDate":"9999-12-31T00:00:00","EffectiveStartDate":"0001-01-01T00:00:00","IsEffectiveEndDateInfinity":"true","ObjectID":"CQGR0001-test","EntityType":"GroupRestriction","ParentSchemeNodeID":null,"SchemeNodeID":"243383"}}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTUpdateGroupRestriction_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
		ROTUpdateGroupRestriction_IB_Resp_v1 responseBean = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTUpdateGroupRestriction_IB_Resp_v1 callHandlerMethod() {
        ROTUpdateGroupRestriction_IB_Req_v1 dummyBean = ROTUpdateGroupRestriction_IB_Req_v1.createDummyRequest();
        ROTUpdateGroupRestriction_IB_Resp_v1 responseBean = ROTUpdateGroupRestriction_IH_v1.UpdateGroupRestriction(dummyBean);
        return responseBean;
    }
}