/**
* @description test class for  IPCQChargeEnquirySummary
* @author  Taras Kuliievych
* @since 2021-07-14
**/
@IsTest
public with sharing class IPCQChargeEnquirySummary_Test {
    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IPCQChargeEnquirySummary_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    @isTest
    static void testIPCQChargeEnquirySummary() {
        IPCQChargeEnquirySummary_Req_IB_v1 fakeRequest = IPCQChargeEnquirySummary_Req_IB_v1.createDummyRequest();

        IPCQChargeEnquirySummary_Resp_IB_v1 responseBean = IPCQChargeEnquirySummary_Resp_IB_v1.createDummyResponse();

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, 'test'));

        Test.startTest();

        String testResponseBean = callHandlerMethod();

        System.assertEquals('test', testResponseBean, 'IPCQChargeEnquirySummary_Test');

        Test.stopTest();
    }

    /**
     *
     * @description Calling handler method.
     * @author  Taras Kuliievych
     * @since 2021-07-14
     * @return  `IPCQChargeEnquirySummary_Resp_IB_v1`
     */
    private static String callHandlerMethod() {
        String responseBean = IPCQChargeEnquirySummary_IH_v1.callToIPCQChargeEnquirySummary('00000000000123123123', '20111111', '22221111', '00000000000123123123', '20111111', '22221111');

        return responseBean;
    }

}