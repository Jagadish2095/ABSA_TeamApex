/**
 * @description  Integration Test Class for dsCheckDigitVerificationV1
 * @author Kami lRega
 * @date    2021-08-18
 */
@istest

public class dsCheckDigitVerificationV1_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_dsCheckDigitVerificationV1';

    //creating test data
    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{
                dsCheckDigitVerificationV1_IH_v1.INTEGRATION_SERVICE_NAME
        });

    }
    @IsTest
    static void testPositive() {
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));
        // Set mock callout class
        Test.startTest();
        dsCheckDigitVerificationV1_Req_IB_v1 dummyBean = dsCheckDigitVerificationV1_Req_IB_v1.createDummyRequest();

        dsCheckDigitVerificationV1_Resp_IB_V1 responseBean = dsCheckDigitVerificationV1_IH_V1.dsCheckDigitVerification(
                dummyBean.accountNumber,
                dummyBean.branchCode,
                dummyBean.accountType,
                dummyBean.transactionType

        );

        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }


}