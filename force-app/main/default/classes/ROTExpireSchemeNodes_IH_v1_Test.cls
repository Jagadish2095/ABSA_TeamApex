/**
* Descripton: Test class for ROTExpireSchemeNodes_IH_v1,ROTExpireSchemeNodes_Req_IB_v1.
* Class Name: ROTExpireSchemeNodes_IH_v1_Test
* @author  	: Manish
* @since   	: 2021-1-19
**/
@isTest
public class ROTExpireSchemeNodes_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"ExpireSchemeNodesResponse":{"ExpireSchemeNodesResult":{"HasErrors": "false", "HasSystemError": "false", "HasValidationErrors": "false","SystemErrorMessage": null,"Tag": null,"CurrentPage": "0","IsCurrentPageTheLast": "true","PageToken": null,"Records": {"SchemeNodeOperationResult":[{"Abandoned": "false","EffectiveStartDate": "2019-06-26T00:00:00","EntityType": "Account","ErrorMessage": null,"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","ObjectID": "4047081344","SchemeNodeID": "240756", "Success": "true" }]},"TotalRecords": "1"}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTExpireSchemeNodes_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
		ROTExpireSchemeNodes_Resp_IB_v1 responseBean = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTExpireSchemeNodes_Resp_IB_v1 callHandlerMethod() {
        ROTExpireSchemeNodes_Req_IB_v1 dummyBean = ROTExpireSchemeNodes_Req_IB_v1.createDummyRequest();
        ROTExpireSchemeNodes_Resp_IB_v1 responseBean = ROTExpireSchemeNodes_IH_v1.getExpireSchemeNodes(dummyBean);
        return responseBean;
    }
}