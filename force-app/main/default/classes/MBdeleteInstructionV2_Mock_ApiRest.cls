/*
 * Mock ApiRest Bean for MBdeleteInstructionV2 Service
 * @author Rudolf Niehaus
 * @created 2020-03-21
 */

 @ isTest
global class MBdeleteInstructionV2_Mock_ApiRest implements HttpCalloutMock {

    private String typeTest;

    global MBdeleteInstructionV2_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {

            response.setBody('{ "MBdeleteInstructionV2Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "nbsmsgo": { "version": "MSGO003", "sysErrTxt": "", "nbrUserMsgs": "0", "nbrUserErrs": "0", "msgEntry": { "msgClass": "", "msgCode": "", "msgErrInd": "", "msgTxt": "" } }, "mbp306o": { "channel": "INTERNET", "todaysDate": "20200321", "timeNow": "14231483", "respCode": "0", "respDesc": "SUCCESSFUL PROCESS", "cifKey": "ZUMAD  001", "tieb": "0", "instrType": "VP", "instrNo": "54", "multiNo": "0", "uniqueEft": "8000375712", "ivrNominate": "0", "intExtBenInd": "E", "actDate": "0", "trigDate": "0", "startDate": "20200319", "endDate": "20991231", "freq": "VP", "amount": "0", "instrRefName": "Nyandane", "srcAcc": "000000000000000000000000", "srcAccType": "", "srcClrCode": "0", "srcInstCode": "ABSA BANK", "srcStmtRef": "0", "trgAcc": "000000000000062001847237", "trgAccType": "02", "trgClrCode": "250655", "trgInstCode": "FIRSTRAND", "trgStmtRef": "Nyandane", "trgBusinessCode": "0000000", "corpCode": "Z", "sbu": "G", "clientType": "I", "prelBypass": "", "minPayAmnt": "0", "maxPayAmnt": "9999999999999.99", "payDay": "0", "doType": "", "chqFlag": "", "freeBankInd": "N", "priNo": "0", "mandNo": "0", "pinAuth": "N", "retryDate": "0", "retryAmount": "0", "retryCount": "0", "timeRange": "000", "verifTemplate": "", "creditTrack": "", "notifInd": "", "srcFaxCode": "", "srcFaxNo": "", "srcFaxText": "", "srcCellCode": "", "srcCellNo": "", "srcCellText": "", "srcEmailAddr": "", "srcEmailText": "", "srcNotifMed": "NNN", "trgFaxCode": "", "trgFaxNo": "", "trgFaxText": "", "trgCellCode": "", "trgCellNo": "", "trgCellText": "", "trgEmailAddr": "", "trgEmailText": "", "trgNotifMed": "NNN", "iipAllowInd": "Y", "lastChangeNo": "21", "lastMaintFunc": "DELT", "lastMaintDate": "20200321", "lastMaintTime": "14231483", "lastMaintBrnch": "8089", "lastMaintTell": "11332", "lastMaintOvrId": "" } } }');
            response.setStatusCode(200);
            
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {

            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);

        } else if (typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS) {

            response.setBody('{}');
            response.setStatusCode(500);
        }
        return response;
    }
}