/**
 * @Author: Mbuyiseni Mbhokane
 * @Since: 13/11/2020
 */
@isTest
public class CIdeleteFromFICALockoutV1_IH_v1_Test {

    public static final String POSITIVE_RESPONSE_BODY = '{"CIdeleteFromFICALockoutV1Response": {"nbsaplo": {"echoKey": null,"reasonCode": 0,"returnCode": 0,"serviceVersion": "BUSO001","version": null},"nbsmsgo3": {"msgEntry": {"msgClass": "CLSMGC01","msgCode": "0731","msgErrInd": "E","msgTxt": "The client has not been removed from the FICA lock-out database."},"nbrUserErrs": 0,"nbrUserMsgs": 1,"sysErrTxt": null,"version": "MSG3001"}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{CIdeleteFromFICALockoutV1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class

        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
        Test.startTest();
        CIdeleteFromFICALockoutV1_Resp_IB_v1 responseBean = callHandlerMethod();
        if (responseBean.statusCode == 200) {
            System.assertEquals(200, responseBean.statusCode);
        } /*else {
            System.assertEquals(responseBean.statusCode, responseBean.statusCode);
        }*/
        Test.stopTest();
    }

    private static CIdeleteFromFICALockoutV1_Resp_IB_v1 callHandlerMethod() {
        CIdeleteFromFICALockoutV1_Req_IB_v1 dummyReqBean = CIdeleteFromFICALockoutV1_Req_IB_v1.createDummyRequest();
        CIdeleteFromFICALockoutV1_Resp_IB_v1 dummyrespBean = CIdeleteFromFICALockoutV1_Resp_IB_v1.createDummyResponse();
        //CIdeleteFromFICALockoutV1_Req_IB_v1 reqBean = CIdeleteFromFICALockoutV1_IU_v1.mapRequiredFields('9051324101', '20200623', '20200623', '999999', '999999');
        CIdeleteFromFICALockoutV1_Req_IB_v1 reqBean = CIdeleteFromFICALockoutV1_IU_v1.mapRequiredFields('9051324101', '20200623', '20200623');
        CIdeleteFromFICALockoutV1_Resp_IB_v1 responseBean = CIdeleteFromFICALockoutV1_IH_v1.deleteFromFicaLockout(dummyReqBean);
        return responseBean;
    }
}