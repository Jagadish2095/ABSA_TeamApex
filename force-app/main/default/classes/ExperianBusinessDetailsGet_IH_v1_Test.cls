/*
 * Test Integration Handler for ExperianBusinessDetailsGet Service
 * @author Prashant Jain
 * @created 2019-12-05
 * @update 2020-09-10 updated to use new integration framework
 */

@isTest
public class ExperianBusinessDetailsGet_IH_v1_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'ExperianBusinessDetailsGet_Mock_Positive_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ExperianBusinessDetailsGet_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();
        ExperianBusinessDetailsGet_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);
        Test.stopTest();
    }

    private static ExperianBusinessDetailsGet_Resp_IB_v1 callHandlerMethod() {
        String registrationNumber = '197101150307';
        ExperianBusinessDetailsGet_Resp_IB_v1 responseBean = ExperianBusinessDetailsGet_IH_v1.ExperianBusinessDetailsGet(registrationNumber);
        return responseBean;
    }
}