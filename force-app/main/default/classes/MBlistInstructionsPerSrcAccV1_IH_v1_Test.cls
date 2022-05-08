/*
* Test Integration Handler for MBlistInstructionsPerSourceAccV1 service
* @author Mashudu Raidimi
* @created 2020-08-11
*/
@isTest
public class MBlistInstructionsPerSrcAccV1_IH_v1_Test {

    public static final String STATIC_RESOURCE_NAME_MOCK_POSITIVE = 'Mock_Positive_MBlistInstructionsPerSrcAccV1';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(MBlistInstructionsPerSrcAccV1_IH_v1.INTEGRATION_API_NAME, new List<String>{MBlistInstructionsPerSrcAccV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(
            HttpCalloutMock.class,
            Sys_Utilities_Integration_Mock_ApiRest.getStaticResourceCalloutMock(StringConstants.POSITIVE_STRING, STATIC_RESOURCE_NAME_MOCK_POSITIVE)
        );

        Test.startTest();

        MBlistInstructionsPerSrcAccV1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static MBlistInstructionsPerSrcAccV1_Resp_IB_v1 callHandlerMethod() {

        MBlistInstructionsPerSrcAccV1_Req_IB_v1 dummyBean = MBlistInstructionsPerSrcAccV1_Req_IB_v1.dummyRequest();
        MBlistInstructionsPerSrcAccV1_Resp_IB_v1 responseBean = MBlistInstructionsPerSrcAccV1_IH_v1.mblistinstrpersourceaccv1(dummyBean.MBlistInstructionsPerSourceAccV1.mbs326i.cifKey,dummyBean.MBlistInstructionsPerSourceAccV1.mbs326i.srcAcc);
        return responseBean;
    }

}