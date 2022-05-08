/*
 * Mock ApiRest Bean for MBListSourceInstructionsV1 Service
 * @author Rudolf Niehaus
 * @created 2020-05-12
 */

 @ isTest
global class MBListSourceInstructionsV1_Mock_ApiRest implements HttpCalloutMock {

    private String typeTest;

    global MBListSourceInstructionsV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {

            response.setBody('{ "MBlistSourceInstructionsV1Response": { "nbsapdpo": { "version": null, "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001", "echoKey": null }, "nbsmsgo": { "version": null, "sysErrTxt": null, "nbrUserMsgs": "0", "nbrUserErrs": "0", "msgEntry": { "msgClass": null, "msgCode": null, "msgErrInd": null, "msgTxt": null } }, "mbn305o": { "channel": "INTERNET", "maxRetrieve": "50", "origType": "SO", "origStatus": "CURRENT", "todaysDate": "20200513", "timeNow": "15290927", "respCode": "0", "respOther": "0", "recsReturn": "2", "respDesc": "SUCCESSFUL PROCESS", "altTieb": "0", "accessAcc": "000000000000000000000000", "instruction": [ { "cifKey": "ZUMAD  001", "tieb": "0", "instrType": "SO", "instrNo": "3", "multiNo": "0", "uniqueEft": "8000389D3B", "instrStatus": "CURRENT", "ivrNominate": "0", "intExtBenInd": "E", "actDate": "20200601", "startDate": "20200601", "endDate": "20991231", "freq": "1M", "amount": "200", "instrRefName": "COVID20", "srcAcc": "000000000000004048017641", "srcAccType": "CQ", "srcClrCode": "632005", "srcInstCode": "ABSA BANK", "srcStmtRef": "COVID20", "trgAcc": "000000000000062001847237", "trgAccType": "02", "trgClrCode": "250655", "trgInstCode": "FIRSTRAND", "trgStmtRef": "COVID20", "trgBusinessCode": "0000000", "clientType": "I", "payDay": "2", "doType": null, "freeBankInd": "N", "priNo": "0", "mandNo": "0", "timeRange": "000", "creditTrack": null, "iipAllowInd": null, "lastMaintDate": "20200504", "lastMaintTell": "11332" }, { "cifKey": "ZUMAD  001", "tieb": "0", "instrType": "SO", "instrNo": "4", "multiNo": "0", "uniqueEft": "8000389D3D", "instrStatus": "CURRENT", "ivrNominate": "0", "intExtBenInd": "E", "actDate": "20200601", "startDate": "20200501", "endDate": "20991231", "freq": "1M", "amount": "100", "instrRefName": "TEST Lockdown", "srcAcc": "000000000000004048017641", "srcAccType": "CQ", "srcClrCode": "632005", "srcInstCode": "ABSA BANK", "srcStmtRef": "TEST Lockdown", "trgAcc": "000000000000062001847237", "trgAccType": "02", "trgClrCode": "250655", "trgInstCode": "FIRSTRAND", "trgStmtRef": "TEST Lockdown", "trgBusinessCode": "0000000", "clientType": "I", "payDay": "1", "doType": null, "freeBankInd": "N", "priNo": "0", "mandNo": "0", "timeRange": "000", "creditTrack": null, "iipAllowInd": null, "lastMaintDate": "20200501", "lastMaintTell": "MBM231D" } ] } } }');
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