/*
* Test Integration Handler for vBlistusersv1 service
* @author Mashudu Raidimi
* @created 2020-07-26
*/
@isTest
public class vBlistusersv1_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"VBlistUsersV1Response":{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":null},"nbsmsgo":{"sysErrTxt":null,"nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}},"vbp451o":{"cifKey":"PIERIDO001","segCode":"B","custId":"000000000365365","custName":"P   ABSA TEST","iplmMax":"4999999","oplmMax":"4999999","ablmMax":"4999999","fdlmMax":"4999999","moreUsers":"Y","numberOcc":"10","users":[{"userNo":"001","userName":null,"userType":"P","userId":null,"userFica":"Y"},{"userNo":"002","userName":null,"userType":"S","userId":null,"userFica":null},{"userNo":"003","userName":"ARNAUD","userType":"S","userId":"1506240039082","userFica":"Y"},{"userNo":"004","userName":"PIETERTJIE","userType":"D","userId":"1506240039082","userFica":"Y"},{"userNo":"005","userName":"DALENE","userType":"M","userId":"1506240039082","userFica":"Y"},{"userNo":"006","userName":"HERBIE","userType":"S","userId":"1506240039082","userFica":"Y"},{"userNo":"008","userName":"ALLAN","userType":"S","userId":"1506240039082","userFica":"Y"},{"userNo":"009","userName":"RICHARD SORRY","userType":"M","userId":"1506240039082","userFica":"Y"},{"userNo":"010","userName":"SHAUN","userType":"S","userId":"1506240039082","userFica":"Y"},{"userNo":"011","userName":"FREDDY","userType":"S","userId":"1506240039082","userFica":"Y"}]}}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(vBlistusersv1_IH_v1.INTEGRATION_API_NAME, new List<String>{vBlistusersv1_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();

        vBlistusersv1_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    private static vBlistusersv1_Resp_IB_v1 callHandlerMethod() {
        vBlistusersv1_Req_IB_v1 dummyBean = vBlistusersv1_Req_IB_v1.createDummyRequest();
        vBlistusersv1_Resp_IB_v1 responseBean = vBlistusersv1_IH_v1.vBlistusersv1(dummyBean.VBlistUsersV1.vbp451i.accNo,dummyBean.VBlistUsersV1.vbp451i.userNo,dummyBean.VBlistUsersV1.vbp451i.cifKey);
        return responseBean;
    }

}