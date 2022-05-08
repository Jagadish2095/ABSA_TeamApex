/*
 * Test Integration Handler for ABSAOnlineStatementSearch Service
 * @author Prashant Jain
 * @created 2020-09-30
 */

@IsTest
public class ABSAOnlineStatementSearch_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ABSAOnlineStatementSearch_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ ABSAOnlineStatementSearch_IH_v1.INTEGRATION_SERVICE_NAME }
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

        ABSAOnlineStatementSearch_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static ABSAOnlineStatementSearch_Resp_IB_v1 callHandlerMethod() {
        ABSAOnlineStatementSearch_Req_IB_v1 dummyBean = ABSAOnlineStatementSearch_Req_IB_v1.createDummyRequest();
        ABSAOnlineStatementSearch_Resp_IB_v1 responseBean = ABSAOnlineStatementSearch_IH_v1.ABSAOnlineStatementSearch(
            dummyBean.accountNumber,
            dummyBean.accountType,
            dummyBean.cifKey,
            dummyBean.statementDateRange
        );
        return responseBean;
    }
}