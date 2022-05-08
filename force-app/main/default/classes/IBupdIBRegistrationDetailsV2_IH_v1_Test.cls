/*
* Test Integration Handler for IBupdIBRegistrationDetailsV2 Service
 ** @author Linda Motaung
 * @created 2020-10-15
*/

@isTest
public class IBupdIBRegistrationDetailsV2_IH_v1_Test 
{

    public static final String POSITIVE_RESPONSE_BODY = '{"IBupdIBRegistrationDetailsV2Response":{"nbsapdpo":{"echoKey":null,"reasonCode":0,"returnCode":0,"serviceVersion":null,"version":null},"nbsmsgo3":{"msgEntry":{"msgClass":"NHSMGC01","msgCode":"0024","msgErrInd":"E","msgTxt":"Debiting of costs not allowed to account (0000009051337380)"},"nbrUserErrs":1,"nbrUserMsgs":1,"sysErrTxt":null,"version":"MSG3001"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{IBupdIBRegistrationDetailsV2_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        IBupdIBRegistrationDetailsV2_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static IBupdIBRegistrationDetailsV2_Resp_IB_v1 callHandlerMethod() {
        IBupdIBRegistrationDetailsV2_Req_IB_v1 dummyBean = IBupdIBRegistrationDetailsV2_Req_IB_v1.createDummyRequest();
        IBupdIBRegistrationDetailsV2_Resp_IB_v1 responseBean = IBupdIBRegistrationDetailsV2_IH_v1.IBupdIBRegistrationDetailsV2(dummyBean);
        return responseBean;
    }
}