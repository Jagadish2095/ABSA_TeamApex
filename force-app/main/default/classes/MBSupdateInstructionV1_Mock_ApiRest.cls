/*
 * Mock ApiRest Bean for MBupdateInstructionV1 Service
 * @author Rudolf Niehaus
 * @created 2020-05-16
 */

 @ isTest
global class MBSupdateInstructionV1_Mock_ApiRest implements HttpCalloutMock {

    private String typeTest;

    global MBSupdateInstructionV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {

            response.setBody('{ "MBupdateInstructionV1Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "nbsmsgo": { "version": "MSG3001", "nbrUserMsgs": "0", "nbrUserErrs": "0", "msgEntry": { "msgClass": null, "msgCode": null, "msgErrInd": null, "msgTxt": null } }, "mbp300o": { "channel": "SALESFOR", "maxRetrieve": "1", "origType": "SO", "origStatus": "CURRENT", "todaysDate": "20200529", "timeNow": "20060465", "respCode": "0", "respOther": "0", "recsReturn": "1", "respDesc": "SUCCESSFUL PROCESS", "fwWarnInd": null, "accessAcc": "000000000000000000000000", "cifKey": "ZUMAD  001", "tieb": "0", "instrType": "SO", "instrNo": "3", "multiNo": "0", "uniqueEft": "8000389D3B", "instrStatus": "CURRENT", "ivrNominate": "0", "intExtBenInd": "E", "actDate": "20200601", "trigDate": "20200601", "startDate": "20200601", "endDate": "20200706", "freq": "1Y", "amount": "199", "instrRefName": "2021", "srcAcc": "000000000000004048017641", "srcAccType": "CQ", "srcClrCode": "632005", "srcInstCode": "ABSA BANK", "srcStmtRef": "2021", "trgAcc": "000000000000062001847237", "trgAccType": "02", "trgClrCode": "250655", "trgInstCode": "FIRSTRAND", "trgStmtRef": "2021", "trgBusinessCode": "0000000", "corpCode": "Z", "sbu": "G", "clientType": "I", "prelBypass": null, "minPayAmnt": "0", "maxPayAmnt": "9999999999999.99", "payDay": "1", "doType": null, "chqFlag": null, "freeBankInd": "N", "priNo": "0", "mandNo": "0", "pinAuth": "N", "retryDate": "0", "retryAmount": "0", "retryCount": "0", "timeRange": "000", "verifTemplate": null, "cardAuth": null, "acbUserCode": null, "acbUcIndex": "0", "creditTrack": null, "notifInd": null, "srcFaxCode": null, "srcFaxNo": null, "srcFaxText": null, "srcCellCode": null, "srcCellNo": null, "srcCellText": null, "srcEmailAddr": null, "srcEmailText": null, "srcNotifMed": "NNN", "trgFaxCode": null, "trgFaxNo": null, "trgFaxText": null, "trgCellCode": null, "trgCellNo": null, "trgCellText": null, "trgEmailAddr": null, "trgEmailText": null, "trgNotifMed": "NNN", "iipAllowInd": null, "lastChangeNo": "15", "lastMaintFunc": "CHNG", "lastMaintDate": "20200529", "lastMaintTime": "20060465", "lastMaintBrnch": "8089", "lastMaintTell": "11332", "lastMaintOvrId": null, "lastMaintOvr2Id": null, "lastPaymDate": "0", "lastPaymAmnt": "0", "lastPaymErr": null, "userNumber": null, "firstName": null, "surname": null, "streetAddress": null, "city": null, "state": null, "country": null } } }');
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