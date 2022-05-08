@isTest
public class ROTUpdateAccount_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"UpdateAccountResponse":{"UpdateAccountResult":{"HasErrors": "true","HasSystemError": "false","HasValidationErrors": "true","SystemErrorMessage": null,"Tag": null,"ValidationErrors":{"ServiceValidationResult":[{"Message": "HSC of HS Id CQTROT-S/ABS/CQGR0002-JUAT, NUID 42, and First Date 2021-01-10 may not be updated; it is already effective.","MessageCode": "E405"}]},"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result":{"Description": null,"EffectiveEndDate": null,"EffectiveStartDate": null,"IsEffectiveEndDateInfinity": null,"ObjectID": null, "EntityType": null,"ParentSchemeNodeID": null,"SchemeNodeID": null},"AccountNumber": "4048430986","EffectiveStartDate": "2021-01-10T00:00:00"}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTUpdateAccount_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
		ROTUpdateAccount_Resp_IB_v1 responseBean = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTUpdateAccount_Resp_IB_v1 callHandlerMethod() {
        ROTUpdateAccount_Req_IB_v1 dummyBean = ROTUpdateAccount_Req_IB_v1.createDummyRequest();
        ROTUpdateAccount_Resp_IB_v1 responseBean = ROTUpdateAccount_IH_v1.UpdateAccount(dummyBean);
        return responseBean;
    }
    
}