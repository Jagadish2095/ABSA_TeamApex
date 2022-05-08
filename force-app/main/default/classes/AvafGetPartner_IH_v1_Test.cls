/*
 * Test Integration Handler for AVAF Get Partner Service
 * @author Danie Booysen
 * @created 2020-11-18
 */
@IsTest
public class AvafGetPartner_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AvafGetPartner_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ AvafGetPartner_IH_v1.INTEGRATION_SERVICE_NAME });
    }

    @isTest
    static void testAvafGetPartner() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Test.startTest();
        AvafGetPartner_Resp_IB_v1 respBean = callHandlerMethod();
        System.assertEquals(200, respBean.statusCode);
        Test.stopTest();
    }

    private static AvafGetPartner_Resp_IB_v1 callHandlerMethod() {
        AvafGetPartner_Req_IB_v1 req = AvafGetPartner_Req_IB_v1.createDummyRequest();
        AvafGetPartner_Resp_IB_v1 respBean = AvafGetPartner_IH_v1.AvafGetPartner(req.BAPI_SF_PARTNER_GET.I_ACCOUNT);
        return respBean;
    }
}