/*
 * Mock ApiRest Bean for ABSAOnlineStatementSearch service
 * @author Srikanth N
 * @created 2020-03-4
 */

 @ isTest
global class    dSaddStopPaymentV2_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global  dSaddStopPaymentV2_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{"account": {"accountType": "Current","number": "4047715862","cifKey": "AAASHSA004"},"documentWorkingDate": "20190730","name": "4047715862    0055","documentKey": null}');
            response.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }
}