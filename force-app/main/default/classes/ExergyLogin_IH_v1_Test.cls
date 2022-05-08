/*
* Test Integration Handler for exergyLogin Service
*
* @author  Chandra Bhushan Singh : ABSA
* @version v1.0
* @since   2021-02-04
* @W-007772,007776,007778,007777,007783
*/

@IsTest
public class ExergyLogin_IH_v1_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ExergyLogin_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ExergyLogin_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        ExergyLogin_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Successful Status Code not received');

        Test.stopTest();
    }

    private static ExergyLogin_Resp_IB_v1 callHandlerMethod() {
        ExergyLogin_Req_IB_v1 dummyBean = ExergyLogin_Req_IB_v1.createDummyRequest();
        ExergyLogin_Resp_IB_v1 responseBean = ExergyLogin_IH_v1.ExergyLogin(dummyBean.Login.PobjUser.SessionID);
        return responseBean;
    }
}