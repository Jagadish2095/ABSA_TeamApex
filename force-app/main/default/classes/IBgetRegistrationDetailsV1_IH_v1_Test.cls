/*
* Test Integration Handler Class for IBgetRegistrationDetailsV1 Service
* @author Srinivas
* @created 2020-10-07
*/
@isTest
public class IBgetRegistrationDetailsV1_IH_v1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"Envelope":{"Body":{"IBgetRegistrationDetailsV1Response": {"nbsapdpo": {"echoKey": null,"reasonCode": 0,"returnCode": 0,"serviceVersion": "BUSO001","version": null},"nbsmsgo3": {"nbrUserErrs": 0,"nbrUserMsgs": 0,"sysErrTxt": null,"version": "MSG3001"},"nhp292o": {"clientName": "O   UOISU","clientType": "I","feeStructure": "02","pinValidationRequired": "Y"}}}}}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IBgetRegistrationDetailsV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }
    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        IBgetRegistrationDetailsV1_Resp_v1 responseBean = callHandlerMethod();
        System.debug(responseBean);
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }
    
     private static IBgetRegistrationDetailsV1_Resp_v1 callHandlerMethod() {
        IBgetRegistrationDetailsV1_Req_v1 dummyBean = IBgetRegistrationDetailsV1_Req_v1.createDummyBean();
        IBgetRegistrationDetailsV1_Resp_v1 responseBean = IBgetRegistrationDetailsV1_IH_v1.IBgetRegistrationDetailsV1(dummyBean);
        return responseBean;
    }
    
}