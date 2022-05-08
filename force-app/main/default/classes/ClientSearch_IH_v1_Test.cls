/**
 * @description Test class for ClientSearch Service
 * @author Koketso Mpshane
 * @created 2021-08-17
 */
@isTest
public class ClientSearch_IH_v1_Test {
    
    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_ClientSearch_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{ClientSearch_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        ClientSearch_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Assert Failed');

        Test.stopTest();
    }

    private static ClientSearch_Resp_IB_v1 callHandlerMethod() {
        ClientSearch_Req_IB_v1 dummyBean = ClientSearch_Req_IB_v1.createDummyRequest();
        ClientSearch_Resp_IB_v1 responseBean = ClientSearch_IH_v1.ClientSearch(dummyBean.Client_Search.pobjSearchClient.IdentifierTypeID, dummyBean.Client_Search.pobjSearchClient.IdentifierDescription);
        return responseBean;
    }

}