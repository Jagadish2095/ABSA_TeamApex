/*
 * Test class for the AVAFSendStatementController
 * @author Danie Booysen
 * @created 2020-11-16
 */
@isTest
public class AVAFSendStatementControllerTest {
    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AVAFStatementRequest_IH_v1.INTEGRATION_SERVICE_NAME }
        );
    }

    @IsTest
    static void testStatementRequest() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                AVAFStatementRequest_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );
        AVAFStatementRequest_Req_IB_v1 req = AVAFStatementRequest_Req_IB_v1.createDummyRequest();

        Test.startTest();
        AVAFStatementRequest_Resp_IB_v1 respBean = AVAFSendStatementController.statementRequest(
            req.BAPI_SF_STMT_REQ.I_ACCOUNT,
            req.BAPI_SF_STMT_REQ.I_EMAIL_ADDRESS1,
            req.BAPI_SF_STMT_REQ.I_STMT_TYPE
        );
        Test.stopTest();

        System.assertEquals(200, respBean.statusCode);
    }
}