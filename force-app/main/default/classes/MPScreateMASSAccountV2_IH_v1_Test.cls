/*
* Test Integration Handler for MPScreateMASSAccountV2 Service
* @author Prashant Jain
* @created 2020-06-08
*/

@isTest
public class MPScreateMASSAccountV2_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"MPScreateMASSAccountV2Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0"},"zbp004o":{"mrchAcctNbr":"1037886","refNum":"GN20202010378","result":"00000 SUCCESS"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{MPScreateMASSAccountV2_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        MPScreateMASSAccountV2_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static MPScreateMASSAccountV2_Resp_IB_v1 callHandlerMethod() {
        MPScreateMASSAccountV2_Req_IB_v1 dummyBean = MPScreateMASSAccountV2_Req_IB_v1.createDummyRequest();
        MPScreateMASSAccountV2_Resp_IB_v1 responseBean = MPScreateMASSAccountV2_IH_v1.MPScreateMASSAccountV2(dummyBean);
        return responseBean;
    }
}