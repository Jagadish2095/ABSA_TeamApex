/*
 * Mock ApiRest Bean for NHupdatePauseCardV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-05-23
 */

@ isTest
global class nHupdatePauseCardV1_Mock_ApiRest implements HttpCalloutMock {
	private String typeTest;

    global nHupdatePauseCardV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {

            response.setBody('{   "NHupdatePauseCardV1Response": {     "nbsapdpo": {       "returnCode": "8",       "reasonCode": "1",       "serviceVersion": "BUSO001",       "echoKey": "DP78004354163541615"     },     "nhs141o": {       "pauseUpdated": null,       "rcde": "415",       "rcdeType": "0",       "rcdeSource": null,       "rcdeReason": "0",       "rdesc": "TRANSACTIONS NOT UPDATED"     }   } }');
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