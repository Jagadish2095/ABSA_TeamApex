/*
 * Test Integration Handler for AvafSettlementQuote Service
 * @author Chandra Bhushan Singh : Absa
 * @created 2020-09-30
 */

@IsTest
public class AvafSettlementQuote_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AvafSettlementQuote_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AvafSettlementQuote_IH_v1.INTEGRATION_SERVICE_NAME }
        );
    }

    @IsTest
    static void testPositive() {
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Test.startTest();

        AvafSettlementQuote_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static AvafSettlementQuote_Resp_IB_v1 callHandlerMethod() {
        AvafSettlementQuote_Req_IB_v1 dummyBean = AvafSettlementQuote_Req_IB_v1.createDummyRequest();
        AvafSettlementQuote_Resp_IB_v1 responseBean = AvafSettlementQuote_IH_v1.settlementQuoteRequest(
            dummyBean.userIdNumber,
            dummyBean.userEmail,
            dummyBean.userName,
            dummyBean.accountNumber,
            dummyBean.userSurname
        );
        return responseBean;
    }
}