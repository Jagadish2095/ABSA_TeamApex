/**
* Descripton: Test class for ROTUpdateCustomer_IH_v1,ROTUpdateCustomer_Req_IB_v1.
* Class Name: ROTUpdateCustomer_IH_v1_Test
* @author  	: Manish
**/
@isTest
public class ROTUpdateCustomer_IH_v1_Test {

     public static final String POSITIVE_RESPONSE_BODY = '{"UpdateCustomerResponse":{"UpdateCustomerResult":{"HasErrors": "true","HasSystemError": "false","HasValidationErrors": "true","SystemErrorMessage": null,"Tag": null,"ValidationErrors": {"ServiceValidationResult":[{"Message": "HSC of HS Id CQTROT-S/ABS/CQGR0002-JUAT, NUID 26, and First Date 2021-01-07 may not be updated; it is already effective.","MessageCode": "E405"}]},"GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result":{"Description": null,"EffectiveEndDate": null,"EffectiveStartDate": null,"IsEffectiveEndDateInfinity": null,"ObjectID": null,"EntityType": null,"ParentSchemeNodeID":null,"SchemeNodeID": null},"CustomerKey":"CTMETRO001","EffectiveStartDate":"2021-01-07T00:00:00"}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTUpdateCustomer_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ROTUpdateCustomer_Resp_IB_v1 responseBean = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTUpdateCustomer_Resp_IB_v1 callHandlerMethod() {
        ROTUpdateCustomer_Req_IB_v1 dummyBean = ROTUpdateCustomer_Req_IB_v1.createDummyRequest();
        ROTUpdateCustomer_Resp_IB_v1 responseBean = ROTUpdateCustomer_IH_v1.updateCustomer(dummyBean);
        return responseBean;
    }
}