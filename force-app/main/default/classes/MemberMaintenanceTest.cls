/*
 * Test Class for MemberMaintenance
 * @author Danie Booysen & Jason Quevauvilliers
 * @created 2020-10-15
 */
@IsTest
public class MemberMaintenanceTest {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_LAListPolicyDetailsByPolicyV7_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{LAListPolicyDetailsByPolicyV7_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        //Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        LAListPolicyDetailsByPolicyV7_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static LAListPolicyDetailsByPolicyV7_Resp_IB_v1 callHandlerMethod() {
        LAListPolicyDetailsByPolicyV7_Req_IB_v1 dummyBean = LAListPolicyDetailsByPolicyV7_Req_IB_v1.createDummyRequest();
        LAListPolicyDetailsByPolicyV7_Resp_IB_v1 responseBean = MemberMaintenance.getPolicyDetailsByPolicyWithBenefits(dummyBean.LAlistPolicyDetailsbyPolicyNumberV7.La950p3i.policyNumber);
        return responseBean;
    }
}