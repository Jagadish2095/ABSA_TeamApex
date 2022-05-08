/**
 * @description Test class for EBSBeneficiaries Service
 * @author Koketso Mpshane
 * @created 2021-07-19
 */
@isTest
public class EBSBeneficiaries_IH_v1_Test {
    
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_EBSBeneficiaries_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{EBSBeneficiaries_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        EBSBeneficiaries_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

        Test.stopTest();
    }

    private static EBSBeneficiaries_Resp_IB_v1 callHandlerMethod() {
        EBSBeneficiaries_Req_IB_v1 dummyBean = EBSBeneficiaries_Req_IB_v1.createDummyRequest();
        EBSBeneficiaries_Resp_IB_v1 responseBean = EBSBeneficiaries_IH_v1.EBSBeneficiaries(dummyBean.cifKey, dummyBean.sourceAccount);
        return responseBean;
    }

}