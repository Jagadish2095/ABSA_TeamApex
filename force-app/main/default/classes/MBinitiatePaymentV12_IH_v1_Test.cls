/**
 * Integration Handler Test for MBinitiatePaymentV12 Service
 * @author Almas Aleem
 * @created 2020-12-15
 */

@isTest
public class MBinitiatePaymentV12_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '{     "nbsapdpo": {         "version": null,         "returnCode": "0",         "reasonCode": "0",         "serviceVersion": null,         "echoKey": null     },     "nbsmsgo3": {         "version": null,         "sysErrTxt": null,         "nbrUserMsgs": "1",         "nbrUserErrs": "0",         "msgEntry": [             {                 "msgClass": "MBSMGC01",                 "msgCode": "0900",                 "msgErrInd": "I",                 "msgTxt": "DATE IN PAST NOT ALLOWED"             }         ]     },     "mbp301o": {         "todaysDate": "20201215",         "timeNow": "14401657",         "respCode": "725",         "respOther": "0",         "recsReturn": "1",         "respDesc": "DATE IN PAST NOT ALLOWED",         "instrTypeDrcr": "D",         "instrTypeDuepe": "P",         "instrTypeAccs": "Y",         "keyFormat": null,         "fwWarnInd": null,         "uniqueEft": "80004A69F4",         "intExtBenInd": "I",         "actDate": "20201204",         "trigDate": "0",         "startDate": "20201215",         "endDate": "20991231",         "freq": "OOP",         "srcAccType": "SA",         "srcClrCode": "632005",         "srcInstCode": "ABSA BANK",         "trgAcc": "000000000000004047373006",         "trgAccType": "CQ",         "trgClrCode": "632005",         "trgInstCode": "ABSA BANK",         "corpCode": "Z",         "sbu": "E",         "clientType": "I",         "minPayAmnt": "0",         "maxPayAmnt": "9999999999999.99",         "iipAllowInd": null,         "lastChangeNo": "1",         "lastMaintFunc": "ADD",         "lastMaintDate": "20201215",         "lastMaintTime": "14401657",         "lastMaintBrnch": "00008089",         "lastMaintTell": "00011012",         "lastMaintOvrId": "00000000",         "paymNo": "1",         "paymBusRef": null,         "lastMaintOvr2Id": "00000000",         "lastPaymDate": "0",         "lastPaymAmnt": "0",         "lastPaymErr": null,         "abal": "0",         "avbl": "0",         "statusCde": "0",         "statusIndx": "0",         "statusDesc": null,         "primEvno": "0",         "secEvno": "0",         "emvscScriptDataLgth": "0",         "emvscScriptData": null,         "productsSpa": "0",         "initpaymOverride": null,         "benGender": null,         "benNonResStat": null,         "exref": null     } }';
    
    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{MBinitiatePaymentV12_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));

        Test.startTest();
        MBinitiatePaymentV12_Resp_IB_v1 responseBean = callHandlerMethod();
        Test.stopTest();
    }

    private static MBinitiatePaymentV12_Resp_IB_v1 callHandlerMethod() {
        MBinitiatePaymentV12_Req_IB_v1 dummyBean = MBinitiatePaymentV12_Req_IB_v1.createDummyRequest();
        MBinitiatePaymentV12_Resp_IB_v1 responseBean = MBinitiatePaymentV12_IH_v1.mbInitiatePaymentV12(dummyBean);
            
        return responseBean;
    }
}