/**
* @description Test class for OnceOffPaymentHistoryApex
* @author Danie Booysen
* @created 2021-03-29
*/

@IsTest
public class OnceOffPaymentHistoryApexTest {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = MBlistInstPerSourceAccV1_IH_v1_Test.STATIC_RESOURCE_NAME_MOCK_POSITIVE;

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{MBlistInstPerSourceAccV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testOOPTransactionHistory(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        MBlistInstPerSourceAccV1_Resp_IB_v1 testResponse = OnceOffPaymentHistoryApex.OOPTransactionHistory('00000004048154875');
        Test.stopTest();
        System.assertEquals(200, testResponse.statusCode, 'Assert Failed');
    }
}