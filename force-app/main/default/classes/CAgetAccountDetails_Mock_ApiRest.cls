/*
 * Mock ApiRest Bean for CAgetAccountDetails Service
 * @author Prashant Jain
 * @created 2019-09-27
 */

 @ isTest
global class CAgetAccountDetails_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global CAgetAccountDetails_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{     "CAgetAccountDetailsV2Response": {         "nbsapdpo": {             "version": "",             "returnCode": "8",             "reasonCode": "1",             "serviceVersion": "BUSO001",             "echoKey": "DP7800435655010497"         },         "cas095o": {             "kbAcctNbr": "4550270023487023",             "kbDualAcctNbr": "9550270023487000",             "kbSubprod": "DUL",             "kbAcctTypCd": "PKG",             "kbCurrStatCd": "AAA",             "ccLstStmtDt": "1191024",             "ccBllngCyc": "0",             "kbTotTns": "1",             "kbCrdsOutstg": "2",             "ccCrLfInsCd": "001",             "ccLstCrLnChngDt": "0",             "kbExpDt": "1221130",             "kbOpenDt": "1070521",             "kbClsDt": "0",             "dqDelqEffDt": "0",             "kbLang": "A",             "jlSex": "",             "raAcctNbr": "",             "kb1stActyDt": "1070521",             "jlFicaInd": "",             "kbMailCd": "NOR",             "kbLcpInd": "Y",             "kbCoffXfrEffDt": "0",             "kbInColInd": "",             "kbNbrPlasWCmnts": "0",             "kbCrdsActivePrim": "1",             "kbCrdsActiveSec": "1",             "kbNxtLcpAnnivDt": "0",             "kbLstMfChrgDt": "0",             "kbCurrTcEffDt": "1190925",             "acctPlasNumbers": [                 {                     "pdPlasNbr": "4550270023487015",                     "tdEmbNmLn1": "MNR/T/STOLTZ",                     "pdCurrStatCd": "L0P"                 },                 {                     "pdPlasNbr": "4550270023487023",                     "tdEmbNmLn1": "MNR/T/STOLTZ",                     "pdCurrStatCd": "AAA"                 }             ],             "ccCurrCrLn": "1000",             "uaBudgetLimit": "0",             "jlCurrBal": "0000000280.00",             "jlAvailCrLn": "720",             "jlEcCurrBal": "0000000000.00",             "kbOutstgEcAuthAmt": "0000000000.00",             "jlAvailBudgetLimit": "0000000000.00",             "jlOutstgAuthCnt": "0",             "jlOutstgAuthAmt": "0000000000.00",             "jlOutstgNormAuAmt": "0000000000.00",             "jlOutstgEcAAmt": "0000000000.00",             "ccLstStmtBal": "0000000000.00",             "ccLstPymtAmt": "0000000000.00",             "ccLstPymtDt": "0",             "ccPymtDueDt": "0",             "btBlldReqdPymt": "0000000000000",             "ccAmtOvln": "0000000000.00",             "dqAmtCurrDelq": "0000000000.00",             "kbTotUnresDsptAmt": "0000000000.00",             "txnLn": [                 {                     "dt1TxnCatg": "1227",                     "dt1TxnDt": "1191031",                     "dt1OrigPstgDt": "1191031",                     "dt1MicflmMsgRef": "00000000000000000000000",                     "dt1TxnDesc": "STELSEL VERLOREKAART ADMINISTRASIE FOOI",                     "dt1TxnAmt": "0000000140.00"                 },                 {                     "dt1TxnCatg": "1227",                     "dt1TxnDt": "1191031",                     "dt1OrigPstgDt": "1191031",                     "dt1MicflmMsgRef": "00000000000000000000000",                     "dt1TxnDesc": "STELSEL VERLOREKAART ADMINISTRASIE FOOI",                     "dt1TxnAmt": "0000000140.00"                 }             ],             "kbLstUpdtDt": "1191031",             "kbLstUpdtTm": "134517",             "kbLstUpdtOper": "BRANCH",             "kbLstUpdtTerm": "DP689050"         }     } }');        
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