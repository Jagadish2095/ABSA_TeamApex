/**
* @description test class for  IPCBPTariffEnquiry
* @author  Taras Kuliievych
* @since 2021-07-14
* Modifications Log
* Ver   Date         Author                          Modification
* 1.1   2021-09-13   André Pietersen (IQ Business)   Resp class Change
**/
@IsTest
public with sharing class IPCBPTariffEnquiry_Test {
    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IPCBPTariffEnquiry_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    @isTest
    static void testIPCBPTariffEnquiryAccountNumber() {
        IPCBPTariffEnquiry_Req_IB_v1 fakeRequest = IPCBPTariffEnquiry_Req_IB_v1.createDummyRequest();
        IPCBPTariffEnquiry_Resp_IB_v1 fakeResponse = IPCBPTariffEnquiry_Resp_IB_v1.createDummyResponse();

        String responseBean = 'test';

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, JSON.serialize(responseBean)));

        Test.startTest();

        String testResponseBean = callHandlerMethodAccountNumber();

        System.assertEquals('"test"', testResponseBean, 'IPCBPTariffEnquiry_Test');

        Test.stopTest();
    }

    /**
     *
     * @description  Calling handler method.
     * @author  Taras Kuliievych
     * @since 2021-07-14
     * @return  `String`
     */
    private static String callHandlerMethodAccountNumber() {
        String responseBean = IPCBPTariffEnquiry_IH_v1.callToIPCBPTariffEnquiryAccountNumber('test', 'test', 'test', 'test');

        return responseBean;
    }

    /**
    * @description
    * @author  Taras Kuliievych
    * @since 2021-07-14
    **/
    @isTest
    static void testIPCBPTariffEnquiryPricingScheme() {
        IPCBPTariffEnquiry_Req_IB_v1 fakeRequest = IPCBPTariffEnquiry_Req_IB_v1.createDummyRequest();
        IPCBPTariffEnquiry_Resp_IB_v1 fakeResponse = IPCBPTariffEnquiry_Resp_IB_v1.createDummyResponse();

        String responseBean = 'test';

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, JSON.serialize(responseBean)));

        Test.startTest();

        String testResponseBean = callHandlerMethodPricingScheme();

        System.assertEquals('"test"', testResponseBean, 'IPCBPTariffEnquiry_Test');

        Test.stopTest();
    }

    /**
     *
     * @description  Calling handler method.
     * @author  Taras Kuliievych
     * @since 2021-07-14
     * @return  `String`
     */
    private static String callHandlerMethodPricingScheme() {
        String responseBean = IPCBPTariffEnquiry_IH_v1.callToIPCBPTariffEnquiryPricingScheme('test', 'test', 'test', 'test');

        return responseBean;
    }

}