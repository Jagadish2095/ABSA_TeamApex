/*
 * Mock ApiRest Bean for ABSAOnlineStatementSearch service
 * @author Srikanth N
 * @created 2020-03-4
 */

 @ isTest
global class    dSretrieveDebitsInqV2_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global  dSretrieveDebitsInqV2_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{"DSretrieveDebitsCreditsInqV2Response": {"nbsapdpo": {"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001"},"nbsmsgo3": {"nbrUserMsgs": "0","nbrUserErrs": "0","msgEntry": {"msgClass": null,"msgCode": null,"msgErrInd": null,"msgTxt": null}},"dsp973o": {"respCode": "0","moreRecsInd": "Y","recsReturnCnt": "50","acno": "-247533897","acHolderName": "UNKNOWN","debitCreditList": [{"trnGrp": "DD","actionDate": "20200128","userCode": "110","userSeq": "7279","nameOfInst": "ABSA CARD","userRef": "FEES/FOOIE 01033844","amount": "196.65","status": "9","tieb": "1343AC025F6F111DBB19","typeInd": "Y","acbRtrnCode": "30","procbInd": "R","ieIndb": "I","effFrmDate": "20200128"},{"trnGrp": "DD","actionDate": "20200226","userCode": "110","userSeq": "7375","nameOfInst": "ABSA CARD","userRef": "FEES/FOOIE 01026343","amount": "393.3","status": "1","tieb": "1343B222A37E4B2A7C2E","typeInd": "Y","acbRtrnCode": "0","procbInd": "Y","ieIndb": "I","effFrmDate": "20200226"}]}}}');
            response.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }
}