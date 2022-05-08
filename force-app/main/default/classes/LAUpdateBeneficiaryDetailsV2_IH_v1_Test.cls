/*
* Test Integration Handler for LAUpdateBeneficiaryDetailsV2 Service
*
* @author  Chandra Bhushan Singh : ABSA
* @version v1.0
* @since   2020-07-21
* @W-006280,W-006906,W-006901,W-006929
*/

@IsTest
public class LAUpdateBeneficiaryDetailsV2_IH_v1_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_LAUpdateBeneficiaryDetailsV2_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{LAUpdateBeneficiaryDetailsV2_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        LAUpdateBeneficiaryDetailsV2_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static LAUpdateBeneficiaryDetailsV2_Resp_IB_v1 callHandlerMethod() {
        LAUpdateBeneficiaryDetailsV2_Req_IB_v1 dummyBean = LAUpdateBeneficiaryDetailsV2_Req_IB_v1.createDummyRequest();
        LAUpdateBeneficiaryDetailsV2_Resp_IB_v1 responseBean = LAUpdateBeneficiaryDetailsV2_IH_v1.LAUpdateBeneficiaryDetailsV2(dummyBean);
        return responseBean;
    }
}