/*
 * Integration Handler Test class for CIlinkAccounttoClientV4 Service
 * @author Saurabh
 * @created 2020-06-03 
 */
@isTest
public class CIlinkAccounttoClientV4_IH_V1_Test {
    
    public static final String POSITIVE_RESPONSE_BODY = '{"statusCode":200,"status":"OK","CIlinkAccountToClientV4Response":{"nbsmsgo3":{"version":"MSG3001","nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":[{"msgTxt":"INVALID CLIENT CODE","msgErrInd":"E","msgCode":"0003","msgClass":"CLSMGC01"}]},"nbsapdpo":{"serviceVersion":"BUSO003","returnCode":"0","reasonCode":"0"}}}';
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(CIlinkAccounttoClientV4_IH_V1.INTEGRATION_API_NAME, new List<String>{CIlinkAccounttoClientV4_IH_V1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        CIlinkAccounttoClientV4_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static CIlinkAccounttoClientV4_Resp_IB_v1 callHandlerMethod() {
        CIlinkAccounttoClientV4_Req_IB_v1 dummyBean = CIlinkAccounttoClientV4_Req_IB_v1.createDummyRequest();
        CIlinkAccounttoClientV4_Resp_IB_v1 responseBean = CIlinkAccounttoClientV4_IH_V1.CIlinkAccounttoClientV4(dummyBean);
        return responseBean;
    }

}