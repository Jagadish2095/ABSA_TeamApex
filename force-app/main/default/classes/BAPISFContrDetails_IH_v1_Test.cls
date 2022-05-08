/*
 * Integration Handler Test class for BAPISFContrDetails Service
 * @author Humbelani Denge
 * @created 2021-01-27
 */
@isTest
public class BAPISFContrDetails_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_BAPISFContrDetails_v1';

    
    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ BAPISFContrDetails_IH_v1.INTEGRATION_SERVICE_NAME });
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Test.startTest();

        BAPISFContrDetails_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static BAPISFContrDetails_Resp_IB_v1 callHandlerMethod() {
        BAPISFContrDetails_Req_IB_v1 dummyBean = BAPISFContrDetails_Req_IB_v1.createDummyRequest();
        BAPISFContrDetails_Resp_IB_v1 responseBean = BAPISFContrDetails_IH_v1.BAPISFContrDetails(
            dummyBean.BAPI_SF_CONTR_DETAILS.I_ACCOUNT,
            dummyBean.BAPI_SF_CONTR_DETAILS.I_USER
        );
        return responseBean;
    }
}