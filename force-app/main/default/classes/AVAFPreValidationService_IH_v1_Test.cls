/*
 * AVAFPreValidationService_IH_v1_Test class for AVAFPreValidationService_IH_v1
 * 
 * @author  Chandra Bhushan Singh : Absa
 * @version v2.0
 * @since   2020-11-04
 */
@IsTest
public class AVAFPreValidationService_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AVAFPreValidationService_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AVAFPreValidationService_IH_v1.INTEGRATION_SERVICE_NAME }
        );
    }

    @IsTest
    static void testPositive() {
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Test.startTest();

        AVAFPreValidationService_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static AVAFPreValidationService_Resp_IB_v1 callHandlerMethod() {
        AVAFPreValidationService_Req_IB_v1 dummyBean = AVAFPreValidationService_Req_IB_v1.createDummyRequest();
        AVAFPreValidationService_Resp_IB_v1 responseBean = AVAFPreValidationService_IH_v1.preValidationService(dummyBean.accountNumber);
        return responseBean;
    }
}