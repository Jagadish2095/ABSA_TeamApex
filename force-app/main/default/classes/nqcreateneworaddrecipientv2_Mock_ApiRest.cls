/*
 * Mock ApiRest Bean for ABSAOnlineStatementSearch service
 * @author Srikanth N
 * @created 2020-03-23
 */

 @ isTest
global class nqcreateneworaddrecipientv2_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global  nqcreateneworaddrecipientv2_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{"NQcreateNewOrAddRecipientV2Response": {"nbsapdpo":{ "returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001"},"nbsmsgo": {"version": "MSGO003","nbrUserMsgs": "0","nbrUserErrs": "0","msgEntry": {"msgClass": null,"msgCode": null,"msgErrInd": null, "msgTxt": null }},"nqp906o": {"rcode": "0","pnsRecipientIdO": "1"} }}');
            response.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }
}