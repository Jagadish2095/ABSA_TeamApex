/*
 * Mock ApiRest Bean for GBcreateCmsContOffLinkV1 Service
 * @author Diksha Wasekar
 * @created 2020-04-03
 */

 @ isTest
global class GBcreateCmsContOffLinkV1_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global GBcreateCmsContOffLinkV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "GBcreateCmsContOffLinkV1Response": { "nbsapdpo": { "returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001" }, "nbsmsgo3": { "nbrUserMsgs": "0", "nbrUserErrs": "0", "msgEntry": { "msgClass": "GBSMGC01", "msgCode": "1", "msgErrInd": "E", "msgTxt": "Client Code is not populated"} }, "gsp020o": { "confirmation": "CAPTURED" } } }');
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