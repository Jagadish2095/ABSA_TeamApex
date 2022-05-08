/*
 * Mock ApiRest Bean for ABSAOnlineStatementSearch service
 * @author Srikanth N
 * @created 2020-05-07
 */

 @ isTest
global class    ccdelinkaccountsv1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global  ccdelinkaccountsv1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{"CCdelinkAccountsV1Response": {"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001"},"nbsmsgo":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"1","nbrUserErrs":"0","msgEntry":[{"msgClass":"CCS299","msgCode":"0169","msgErrInd": "I","msgTxt":"WARNING - Internet / Banktel Services will also be closed, cancel to stop transaction"}]},"ccp309o":{"combiRetrvdInd":"Y","lstAccntNbr":"4048276744"}}}');
            response.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }
}