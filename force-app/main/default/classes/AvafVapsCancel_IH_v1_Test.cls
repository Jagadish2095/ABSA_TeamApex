/**
 * @description Test Integration Handler for SAPCancel Service
 * @author Jason Quevauvilliers
 * @created 2020-11-05
 * @modified 202104-19 by Jason Quevauvilliers (W-011270)
 */

@IsTest
public class AvafVapsCancel_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AvafVapsCancel_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AvafVapsCancel_IH_v1.INTEGRATION_SERVICE_NAME }
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

        AvafVapsCancel_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static AvafVapsCancel_Resp_IB_v1 callHandlerMethod() {
        AvafVapsCancel_Req_IB_v1 requestBean = AvafVapsCancel_Req_IB_v1.createDummyRequest();
        String selectedVAPS = JSON.serialize(requestBean.BAPI_SF_VAPS_CANCEL[0]);
        AvafVapsCancel_Resp_IB_v1 responseBean = AvafVapsCancel_IH_v1.cancelInsurance(selectedVAPS, true);
        return responseBean;
    }
}