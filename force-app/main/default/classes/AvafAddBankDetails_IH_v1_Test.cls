/*
 * Test Integration Handler for AvafAddBankDetails Service
 * @author Humbelani Denge
 * @created 2020-11-23
 */
@IsTest
public class AvafAddBankDetails_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AvafAddBankDetails_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ AvafAddBankDetails_IH_v1.INTEGRATION_SERVICE_NAME });
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        AvafAddBankDetails_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static AvafAddBankDetails_Resp_IB_v1 callHandlerMethod() {
        AvafAddBankDetails_Req_IB_v1 dummyBean = AvafAddBankDetails_Req_IB_v1.createDummyRequest();
        AvafAddBankDetails_Resp_IB_v1 responseBean = AvafAddBankDetails_IH_v1.AvafAddBankDetails(
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BUSINESSPARTNER,
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANKACCOUNTNAME,
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.ACCOUNTHOLDER,
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_REF,
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANKDETAILID,
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_ACCT,
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.CTRL_KEY,
            dummyBean.BAPI_SF_DO_BUPA_BANKDETAIL_ADD.BANK_KEY
        );
        return responseBean;
    }
}