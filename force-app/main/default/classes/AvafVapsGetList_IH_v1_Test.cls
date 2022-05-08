/*
 * Test Integration Handler for SAPGetList Service
 * @author Jason Quevauvilliers
 * @created 2020-11-05
 */

@IsTest
public class AvafVapsGetList_IH_v1_Test {
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_AvafVapsGetList_v1';

    @TestSetup
    static void makeData() {
        IntegrationTestDataFactory.insertIntegrationSettings(
            StringConstants.JITTERBIT2,
            new List<String>{ AvafVapsGetList_IH_v1.INTEGRATION_SERVICE_NAME }
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

        AvafVapsGetList_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static AvafVapsGetList_Resp_IB_v1 callHandlerMethod() {
        AvafVapsGetList_Req_IB_v1 requestBean = AvafVapsGetList_Req_IB_v1.createDummyRequest();
        AvafVapsGetList_Resp_IB_v1 responseBean = AvafVapsGetList_IH_v1.getVAPSList(requestBean.BAPI_SF_VAPS_LIST[0].I_Account);
        return responseBean;
    }
}