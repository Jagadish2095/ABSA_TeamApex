/*
 * Test class for the AVAFAuditCertificateController
 * @author Bhanumurty Rayala
 * @created 2021-06-29
 */
@isTest
public class AVAFAuditCertificateControllerTest {
     @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AVAFStatementRequest_IH_v1.INTEGRATION_SERVICE_NAME }
        );
    }

    @IsTest
    static void testAuditCertificateRequest() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(
                StringConstants.POSITIVE_STRING,
                AVAFStatementRequest_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE
            )
        );

        Test.startTest();
        AVAFStatementRequest_Resp_IB_v1 respBean = AVAFAuditCertificateController.auditCertificateRequest(
            '00075666239',
            'test@testmail.com',
            '202009'
        );
        Test.stopTest();
        System.assertEquals(200, respBean.statusCode, 'Assert Failed');
    }
}