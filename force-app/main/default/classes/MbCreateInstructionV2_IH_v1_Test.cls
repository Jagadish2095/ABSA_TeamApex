/**
 * Integration Handler for MbCreateInstructionV2 Service
 * @author Englarmerdge Mongwe
 * @created 2020-12-07
 */

@isTest
public class MbCreateInstructionV2_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{"nbsapdpo":{"version":null,"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":null},"nbsmsgo":{"version":"MSG3041","sysErrTxt":"*EXCEPTION* 07/12/2020 11:15:17. EXCP CODE: 0001. IN PGM: NBM102D .   LABEL/SECTION: RZEXPG-H. CALLING PGM: MBP304  .                       PROCESS ID: WSDL STUB -MBP304  -","nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":[{"msgClass":"RZSMGAB","msgCode":"0003","msgErrInd":"E","msgTxt":"A technical/system error has occured."}]},"mbp304o":{"todaysDate":"20201207","timeNow":"11151723","respCode":"219","respOther":"0","recsReturn":"0","respDesc":"NO PARAMETER FOUND - PARM 08","instrTypeDrcr":null,"instrTypeDuepe":null,"instrTypeAccs":null,"fwWarnInd":null,"instrNo":"0","multiNo":"0","intExtBenInd":null,"actDate":"0","trigDate":"0","srcAcc":"000000000000000000000000","srcAccType":null,"srcClrCode":"0","srcInstCode":null,"trgAcc":"000000000000000000000000","trgAccType":null,"trgClrCode":"0","trgInstCode":null,"corpCode":null,"sbu":null,"clientType":null,"iipAllowInd":null,"lastChangeNo":"0","lastMaintFunc":null,"changeNo":"0","changeSet":"0","changeDate":"0","changeTime":"0","changeFunc":null,"changeBranch":"0","changeTeller":"0","changeOverride":null}}';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{MbCreateInstructionV2_IH_V1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        mbCreateInstTestMock();

        Test.startTest();

        MbCreateInstructionV2_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    public static void mbCreateInstTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    private static MbCreateInstructionV2_Resp_IB_v1 callHandlerMethod() {
        MbCreateInstructionV2_Req_IB_v1 dummyBean = MbCreateInstructionV2_Req_IB_v1.createDummyRequest();
        MbCreateInstructionV2_Resp_IB_v1 responseBean = MbCreateInstructionV2_IH_v1.MbCreateInstructionV2(dummyBean);
        return responseBean;
    }
}