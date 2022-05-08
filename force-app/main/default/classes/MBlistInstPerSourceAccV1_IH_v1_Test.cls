/**
* @description Test Integration Handler for MBlistInstructionsPerSourceAccV1 Service
* @author Chandra Bhushan
* @created 2020-03-12
*/

@IsTest
public class MBlistInstPerSourceAccV1_IH_v1_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MBlistInstructionsPerSourceAccV1_v1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{MBlistInstPerSourceAccV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @IsTest
    static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE));

        Test.startTest();

        MBlistInstPerSourceAccV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode, 'Successful Status Code not received');

        Test.stopTest();
    }

    private static MBlistInstPerSourceAccV1_Resp_IB_v1 callHandlerMethod() {
        MBlistInstPerSourceAccV1_Req_IB_v1 dummyBean = MBlistInstPerSourceAccV1_Req_IB_v1.createDummyRequest();
        MBlistInstPerSourceAccV1_Resp_IB_v1 responseBean = MBlistInstPerSourceAccV1_IH_v1.MBlistInstructionsPerSourceAccV1(dummyBean.MBS326I.InputCopybook.cifKey,dummyBean.MBS326I.InputCopybook.sourceAccount,dummyBean.MBS326I.InputCopybook.instrType);
        return responseBean;
    }
}