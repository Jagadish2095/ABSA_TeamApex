/**
 * Test class for GBgetCmsCreditGroupsDetV1 Service
 * @author Englarmerdge Mongwe
 * @created 2020-10-13
 */
@IsTest
public class GBgetCmsCreditGroupsDetV1_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GBgetCmsCreditGroupsDetV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        cmsCreditGroupTestMock();

        Test.startTest();

        GBgetCmsCreditGroupsDetV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    public static void cmsCreditGroupTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    private static GBgetCmsCreditGroupsDetV1_Resp_IB_v1 callHandlerMethod() {
        GBgetCmsCreditGroupsDetV1_Req_IB_v1 dummyBeanParent = GBgetCmsCreditGroupsDetV1_Req_IB_v1.createDummyRequest();
        GBgetCmsCreditGroupsDetV1_Req_IB_v1.GSB014I_Z dummyBean = dummyBeanParent.GSB014I;
        GBgetCmsCreditGroupsDetV1_Resp_IB_v1 responseBean = GBgetCmsCreditGroupsDetV1_IH_v1.gbGetCmsCreditGroupsDetV1(dummyBean.GSB014I.GSB014I_CLIENT_CODE);
        return responseBean;
    }
}