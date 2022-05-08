/*
 * Test Integration Handler for AVAF SAP Statement Request Service
 * @author Danie Booysen
 * @created 2020-11-16
 */
@IsTest
public class AVAFStatementRequest_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AVAFStatementRequest_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AVAFStatementRequest_IH_v1.INTEGRATION_SERVICE_NAME }
        );
    }

    @isTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Test.startTest();
        AVAFStatementRequest_Resp_IB_v1 respBean = callHandlerMethod();
        System.assertEquals(200, respBean.statusCode);
        Test.stopTest();
    }

    private static AVAFStatementRequest_Resp_IB_v1 callHandlerMethod() {
        AVAFStatementRequest_Req_IB_v1 req = AVAFStatementRequest_Req_IB_v1.createDummyRequest();

        AVAFStatementRequest_Resp_IB_v1 respBean = AVAFStatementRequest_IH_v1.AVAFStatementRequest(
            req.BAPI_SF_STMT_REQ.I_ACCOUNT,
            req.BAPI_SF_STMT_REQ.I_EMAIL_ADDRESS1,
            req.BAPI_SF_STMT_REQ.I_PERIOD_ENDING,
            req.BAPI_SF_STMT_REQ.I_STMT_TYPE
        );
        return respBean;
    }
}