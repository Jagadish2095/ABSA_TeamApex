/**
* @description Test Integration Handler for policyLoadByRefNo Service
* @author  Chandra Bhushan Singh : ABSA
* @version v1.0
* @since   2021-02-04
* @W-007776
*/

@IsTest
public class PolicyLoadByRefNo_IH_v1_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_PolicyLoadByRefNo_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{PolicyLoadByRefNo_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    
    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        PolicyLoadByRefNo_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Successful Status Code not received');

        Test.stopTest();
    }

    private static PolicyLoadByRefNo_Resp_IB_v1 callHandlerMethod() {
        PolicyLoadByRefNo_Req_IB_v1 dummyBean = PolicyLoadByRefNo_Req_IB_v1.createDummyRequest();
        PolicyLoadByRefNo_Resp_IB_v1 responseBean = PolicyLoadByRefNo_IH_v1.policyLoadByRefNo(dummyBean.Policy_LoadByRefNo.pstrRefNo);
        return responseBean;
    }
}