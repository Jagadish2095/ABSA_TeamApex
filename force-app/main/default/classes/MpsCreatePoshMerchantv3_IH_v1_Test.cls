/*
* Test Integration Handler for MpsCreatePoshMerchantv3 Service
* @author Prashant Jain
* @created 2020-06-08
*/

@isTest
public class MpsCreatePoshMerchantv3_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"MPScreatePOSHMerchantV3Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0"},"zbp006o":{"mrchAcctNbr":"00000000000000000000000","refNum":"GN20202010378","result":"00000 SUCCESS"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{MpsCreatePoshMerchantv3_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        MpsCreatePoshMerchantv3_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static MpsCreatePoshMerchantv3_Resp_IB_v1 callHandlerMethod() {
        MpsCreatePoshMerchantv3_Req_IB_v1 dummyBean = MpsCreatePoshMerchantv3_Req_IB_v1.createDummyRequest();
        MpsCreatePoshMerchantv3_Resp_IB_v1 responseBean = MpsCreatePoshMerchantv3_IH_v1.MpsCreatePoshMerchantv3(dummyBean);
        return responseBean;
    }
}