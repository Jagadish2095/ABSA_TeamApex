/*
 * Test Integration Handler for ABSAOnlineStatementDownload Service
 * @author Prashant Jain
 * @created 2020-09-30
 */

@IsTest
public class ABSAOnlineStatementDownload_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ABSAOnlineStatementDownload_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ ABSAOnlineStatementDownload_IH_v1.INTEGRATION_SERVICE_NAME }
        );
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Test.startTest();

        ABSAOnlineStatementDownload_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static ABSAOnlineStatementDownload_Resp_IB_v1 callHandlerMethod() {
        ABSAOnlineStatementDownload_Req_IB_v1 dummyBean = ABSAOnlineStatementDownload_Req_IB_v1.createDummyRequest();
        ABSAOnlineStatementDownload_Resp_IB_v1 responseBean = ABSAOnlineStatementDownload_IH_v1.ABSAOnlineStatementDownload(
            dummyBean.accountNumber,
            dummyBean.accountType,
            dummyBean.cifKey,
            dummyBean.encoding,
            dummyBean.listRef,
            dummyBean.statementDate,
            dummyBean.password
        );
        return responseBean;
    }
}