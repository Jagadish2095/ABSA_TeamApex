/*
 * Test Integration Handler for AvafGetBankDetails Service
 * @author Humbelani Denge
 * @created 2020-11-23
 */

@IsTest
public class AvafGetBankDetails_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AvafGetBankDetails_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ AvafGetBankDetails_IH_v1.INTEGRATION_SERVICE_NAME });
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        AvafGetBankDetails_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static AvafGetBankDetails_Resp_IB_v1 callHandlerMethod() {
        AvafGetBankDetails_Req_IB_v1 dummyBean = AvafGetBankDetails_Req_IB_v1.createDummyRequest();
        AvafGetBankDetails_Resp_IB_v1 responseBean = AvafGetBankDetails_IH_v1.AvafGetBankDetails(dummyBean.BAPI_BUPA_BANKDETAILS_GET.BUSINESSPARTNER);
        return responseBean;
    }
}