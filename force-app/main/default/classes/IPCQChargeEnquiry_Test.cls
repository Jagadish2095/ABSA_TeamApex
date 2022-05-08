/**
* @description test class for  IPCQChargeEnquiry
* @author  Taras Kuliievych
* @since 2021-07-14
**/
@IsTest
public with sharing class IPCQChargeEnquiry_Test {
    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IPCQChargeEnquiry_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    @isTest
    static void testIPCQChargeEnquiry() {
        IPCQChargeEnquiry_Req_IB_v1 fakeRequest = IPCQChargeEnquiry_Req_IB_v1.createDummyRequest();

        IPCQChargeEnquiry_Resp_IB_v1 responseBean = IPCQChargeEnquiry_Resp_IB_v1.createDummyResponse();

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, 'test'));

        Test.startTest();

        String testResponseBean = callHandlerMethod();

        System.assertEquals('test', testResponseBean, 'IPCQChargeEnquiry_Test');

        Test.stopTest();
    }

    /**
     *
     * @description  Calling handler method.
     * @author  Taras Kuliievych
     * @since 2021-07-14
     * @return  `IPCQChargeEnquiry_Resp_IB_v1`
     */
    private static String callHandlerMethod() {
        String responseBean = IPCQChargeEnquiry_IH_v1.callToIPCQChargeEnquiry('00000000000123123123', '20111111', '22221111', '00000000000123123123', '20111111', '22221111', '22221111');

        return responseBean;
    }

}