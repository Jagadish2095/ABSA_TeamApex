@isTest
public class ROTDeleteTransactionType_IH_v1_Test {

    
    public static final String POSITIVE_RESPONSE_BODY = '{"DeleteTransactionTypeResponse":{"DeleteTransactionTypeResult":{"HasErrors": false,"HasSystemError": false,"HasValidationErrors": false,"Information": null,"SystemErrorMessage":{"nil":true},"Tag":{"nil": true},"ValidationErrors": null,"Code": "FN71 FIA","EffectiveStartDate": "2021-02-10T00:00:00","GroupRestrictionClusterID": "ABS","GroupRestrictionObjectID": "CQGR0002-JUAT","Result":{"nil": true}}}}';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ROTDeleteTransactionType_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        ROTDeleteTransactionType_Resp_IB_v1 responseBean = callHandlerMethod();
        Test.stopTest();
    }
    
     private static ROTDeleteTransactionType_Resp_IB_v1 callHandlerMethod() {
        ROTDeleteTransactionType_Req_IB_v1 dummyBean = ROTDeleteTransactionType_Req_IB_v1.createDummyRequest();
        ROTDeleteTransactionType_Resp_IB_v1 responseBean = ROTDeleteTransactionType_IH_v1.deleteTransactionType(dummyBean);
        return responseBean;
    }
    
}