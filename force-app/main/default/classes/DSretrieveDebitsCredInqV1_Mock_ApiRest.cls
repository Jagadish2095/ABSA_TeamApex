/*
 * Mock ApiRest Bean for DSretrieveDebitsCreditsInq Service
 * @author Prasanna Patwardhan
 * @created 2019-10-30
 */

 @ isTest
global class DSretrieveDebitsCredInqV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;
   
    global DSretrieveDebitsCredInqV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "DSretrieveDebitsCreditsInqV1Response": { "nbsapdpo": { "version": "", "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001", "echoKey": "" }, "nbsmsgo3": { "version": "", "sysErrTxt": "", "nbrUserMsgs": "0", "nbrUserErrs": "0", "msgEntry": [] }, "dsp973o": { "respCode": "0", "respDesc": "", "moreRecsInd": "N", "recsReturnCnt": "11", "acno": "09050987409", "acHolderName": "UNKNOWN", "debitCreditList": [ { "trnGrp": "DD", "actionDate": "20190927", "userCode": "0110", "userSeq": "7", "nameOfInst": "RSADLV", "userRef": "TESTDR3", "amount": "47.64", "status": "001", "tieb": "13416CE2081E01A5F107", "typeInd": "Y", "acbRtrnCode": "000", "procbInd": "Y", "ieIndb": "I", "ccpCaseNo": "0020190927" }, { "trnGrp": "DD", "actionDate": "NaN", "userCode": "7011", "userSeq": "1", "nameOfInst": "5RSADLV", "userRef": "TESTDR3", "amount": "3.37", "status": "300", "tieb": "113416CF0C422489DB10", "typeInd": "7", "acbRtrnCode": "Y00", "procbInd": "0", "ieIndb": "Y", "ccpCaseNo": "I002019092" }, { "trnGrp": "7 D", "actionDate": "NaN", "userCode": "3001", "userSeq": "100000", "nameOfInst": "07RSADLV", "userRef": "TESTDR3", "amount": "0.89", "status": "780", "tieb": "0913416CF20815160972", "typeInd": "0", "acbRtrnCode": "7Y0", "procbInd": "3", "ieIndb": "2", "ccpCaseNo": "RI00201909" }, { "trnGrp": "30", "actionDate": "NaN", "userCode": "0010", "userSeq": "110000", "nameOfInst": "007RSADLV", "userRef": "TESTDR3", "amount": "0.02", "status": "259", "tieb": "00913416D2208BF29D34", "typeInd": "6", "acbRtrnCode": "07Y", "procbInd": "0", "ieIndb": "1", "ccpCaseNo": "8RI0020191" }, { "trnGrp": "001", "actionDate": "NaN", "userCode": "1001", "userSeq": "11000", "nameOfInst": "0015RSADLV", "userRef": "TESTDR3", "amount": "0", "status": "724", "tieb": "800913416D2208BF29D3", "typeInd": "4", "acbRtrnCode": "60F", "procbInd": "Y", "ieIndb": "0", "ccpCaseNo": "34RI002019" }, { "trnGrp": "100", "actionDate": "NaN", "userCode": "9100", "userSeq": "801000", "nameOfInst": "00000PAYME", "userRef": "NT TO ACC47876900203", "amount": "6700000000000", "status": "100", "tieb": "000091341720277D8561", "typeInd": "4", "acbRtrnCode": "1F1", "procbInd": "5", "ieIndb": "Y", "ccpCaseNo": "030RI00201" }, { "trnGrp": "910", "actionDate": "NaN", "userCode": "1910", "userSeq": "160110", "nameOfInst": "000003RSAD", "userRef": "LV ABSADR3", "amount": "0", "status": "002", "tieb": "41900913417272081C20", "typeInd": "7", "acbRtrnCode": "C36", "procbInd": "0", "ieIndb": "3", "ccpCaseNo": "Y030RI0020" }, { "trnGrp": "191", "actionDate": "NaN", "userCode": "0191", "userSeq": "22011", "nameOfInst": "0000003RSA", "userRef": "DLV ABSADR3", "amount": "0", "status": "000", "tieb": "8820001134172E0C3CE5", "typeInd": "B", "acbRtrnCode": "419", "procbInd": "6", "ieIndb": "0", "ccpCaseNo": "3Y000YI002" }, { "trnGrp": "019", "actionDate": "NaN", "userCode": "2019", "userSeq": "102301", "nameOfInst": "10000007RS", "userRef": "ADLV ABSADR3", "amount": "0", "status": "000", "tieb": "03221001134172E0C3CE", "typeInd": "5", "acbRtrnCode": "B41", "procbInd": "9", "ieIndb": "6", "ccpCaseNo": "07Y000YI00" }, { "trnGrp": "201", "actionDate": "NaN", "userCode": "201", "userSeq": "910250", "nameOfInst": "110000003R", "userRef": "SADLV ABSADR3", "amount": "0", "status": "000", "tieb": "00713500913417310C41", "typeInd": "8", "acbRtrnCode": "572", "procbInd": "E", "ieIndb": "3", "ccpCaseNo": "103Y022RI0" }, { "trnGrp": "020", "actionDate": "NaN", "userCode": "D 20", "userSeq": "191025", "nameOfInst": "0110000007", "userRef": "RSADLV ABSADR3", "amount": "0", "status": "000", "tieb": "000663400113417310C4", "typeInd": "1", "acbRtrnCode": "857", "procbInd": "2", "ieIndb": "E", "ccpCaseNo": "3107Y000YI" } ] } }}');
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