/*
* Test Integration Handler for getTbUserBasicLimits service
* @author Mashudu Raidimi
* @created 2020-07-26
*/
@isTest
public class getTbUserBasicLimits_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"getUserLimitResp":{"intAccXfer":"10000","intAccXferUsed":"0","ownDefPaym":"10000","ownDefPaymUsed":"0","billPaym":"10000","billPaymUsed":"0","futDtePaym":"10000","errorCode":"NA","errorMessage":"NA"},"error":false,"errorList":[],"additionalInfo":null}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(getTbUserBasicLimits_IH_v1.INTEGRATION_API_NAME, new List<String>{getTbUserBasicLimits_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        getTbUserBasicLimits_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static getTbUserBasicLimits_Resp_IB_v1 callHandlerMethod() {
        
        getTbUserBasicLimits_Req_IB_v1 dummyBean = getTbUserBasicLimits_Req_IB_v1.dummyRequest();
        getTbUserBasicLimits_Resp_IB_v1 responseBean = getTbUserBasicLimits_IH_v1.getTbUserBasicLimits(dummyBean.customerCifKey,dummyBean.userNumber);
        return responseBean;
    }

}