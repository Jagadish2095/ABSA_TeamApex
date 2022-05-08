/*
 * Mock ApiRest Bean for NHenquiryPauseCardV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-05-23
 */

 @ isTest
global  class nHenquiryPauseCardV1_Mock_ApiRest	implements HttpCalloutMock  {
	private String typeTest;

    global nHenquiryPauseCardV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {

            response.setBody('{   "NHenquiryPauseCardV1Response": {     "nbsapdpo": {       "returnCode": "8",       "reasonCode": "1",       "serviceVersion": "BUSO001",       "echoKey": "DP78001832416752463"     },     "nhs142o": {       "tellerCode": "0",       "workStation": null,       "supervisor": "0",       "branchCode": "0",       "pauseHold": null,       "iatmHold": null,       "iposHold": null,       "latmHold": null,       "lposHold": null,       "cnpHold": null,       "digwHold": null,       "pauseDate": "0",       "rcde": "415",       "rcdeType": "0",       "rcdeSource": null,       "rcdeReason": "0",       "rdesc": "TRANSACTIONS NOT UPDATED"     }   } }');
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