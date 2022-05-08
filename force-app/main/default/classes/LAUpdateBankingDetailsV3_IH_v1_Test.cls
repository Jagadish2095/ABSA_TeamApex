/*
 * Test Integration Handler for LAUpdateBankingDetailsV3 Service
 * @author Humbelani Denge
 * @created 2020-10-15
 */
@IsTest
public class LAUpdateBankingDetailsV3_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_LAUpdateBankingDetailsV3_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ LAUpdateBankingDetailsV3_IH_v1.INTEGRATION_SERVICE_NAME });
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        LAUpdateBankingDetailsV3_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static LAUpdateBankingDetailsV3_Resp_IB_v1 callHandlerMethod() {
        LAUpdateBankingDetailsV3_Req_IB_v1 dummyBean = LAUpdateBankingDetailsV3_Req_IB_v1.createDummyRequest();
        LAUpdateBankingDetailsV3_Resp_IB_v1 responseBean = LAUpdateBankingDetailsV3_IH_v1.LAUpdateBankingDetailsV3(
            dummyBean.LAupdateBankingDetailsV3.la950p5i.clientCode,
            dummyBean.LAupdateBankingDetailsV3.la950p5i.policyNumber,
            dummyBean.LAupdateBankingDetailsV3.la950p5i.bankName,
            dummyBean.LAupdateBankingDetailsV3.la950p5i.sourceOfIncome,
            dummyBean.LAupdateBankingDetailsV3.la950p5i.sourceOfFund,
            dummyBean.LAupdateBankingDetailsV3.la950p5i.bankAccountNumber,
            dummyBean.LAupdateBankingDetailsV3.la950p5i.accountholderName,
            dummyBean.LAupdateBankingDetailsV3.la950p5i.premiumCollectionDay,
            dummyBean.LAupdateBankingDetailsV3.la950p5i.paymentFrequency,
            dummyBean.LAupdateBankingDetailsV3.la950p5i.accountType,
            dummyBean.LAupdateBankingDetailsV3.la950p5i.bankBranch,
            dummyBean.LAupdateBankingDetailsV3.la950p5i.amount
        );
        return responseBean;
    }
}