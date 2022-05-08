/*
 * Mock ApiRest Bean for CCGetPortfolioDetailV1 Service
 * @author Prashant Jain
 * @created 2020-03-16
 */

 @ isTest
global class CCGetPortfolioDetailV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global CCGetPortfolioDetailV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "CCgetPortfolioDetailV1Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "nbsmsgo": { "version": "MSG3001", "sysErrTxt": null, "nbrUserMsgs": "1", "nbrUserErrs": "0", "msgEntry": { "msgClass": "CCS299", "msgCode": "283", "msgErrInd": "I", "msgTxt": "No Secondary Cheque Application found for Chip card" } }, "ccp301o": { "combiRetrvdInd": "Y", "prevNbr": "181246980", "nextNbr": "0", "prtPassNbr": "0", "clientCode": "ZUMAD 001", "clientName": "D ZUMA", "idPspNbr": "0", "persName": "MR D ZUMA", "langCode": "E", "ncssRefno": "0", "ncssStat": null, "brandNbr": "2812", "prodCode": "11048", "segmCode": "G", "sbuSiteCode": "0", "issueBranch": "8198", "createDate": "20190215", "activateDate": "0", "holdDate": "0", "closeDate": "0", "inactDate": "0", "ncssDate": "0", "transferDate": "0", "mthLastUse": "202003", "exprDate": "0", "nbrHolds": "0", "holds": [ {"holdCode": "0"}, {"holdCode": "0"}, {"holdCode": "0"} ], "reasCode": null, "sreasCode": null, "retnDate": "0", "retnBrch": "0", "cardReqd": "Y", "autoLink": "N", "bankInter": "Y", "bankLink": "N", "bankTel": "N", "pinReqd": "N", "blindInd": null, "scrdInd": "N", "cpresInd": "N", "inactInd": "N", "thrdParty": null, "cardRepl": "2", "cardFeeInd": "N", "cardFeeDate": "0", "lostFeeInd": "Y", "lostFeeDate": "0", "mthFeeInd": "N", "nomCheq": "-246949655", "nomSavs": "0", "nomCred": "0", "lvpAppl": "0", "frdAccNbr": "0", "cardCshLim": "2000", "cardPosLim": "2000", "cardTrfLim": "2000", "cardCntLim": "999999999", "cardCntAvl": "0", "cntLimDate": "0", "cardLimit": "4000", "totalLimit": "0", "nbrChipAppl": "0", "reisCntrCde": null, "nonReisRsn": null, "lstReisDate": "0", "brandCode": "VASA", "dstBrchCode": "0", "dstCode": null, "reisTrgDate": "0" } } }');
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