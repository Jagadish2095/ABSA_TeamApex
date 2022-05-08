/*
 * Mock ApiRest Bean for abfgetgeneraldetailsv2 service
 * @author Srikanth N
 * @created 2020-05-07
 */

 @ isTest
global class abfgetgeneraldetailsv2_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global  abfgetgeneraldetailsv2_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{"abfgetgeneraldetailsv2Response":{"nbsapdpo":{"version":null,"returnCode": "0","reasonCode":"0","serviceVersion":"BUSO001"},"nbsmsgo": {"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs": "0","nbrUserErrs":"0","msgEntry":{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null }},"ccp303o":{"combiRetrvdInd": "Y","accntLinked":"Y"}}}');
            response.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }
}