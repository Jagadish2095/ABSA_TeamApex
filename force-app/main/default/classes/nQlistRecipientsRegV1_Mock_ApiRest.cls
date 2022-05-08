/*
 * Mock ApiRest Bean for NQlistRecipientsRegisteredForCustV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-05-18
 */
@ isTest
global class nQlistRecipientsRegV1_Mock_ApiRest implements HttpCalloutMock {
	private String typeTest;

    global nQlistRecipientsRegV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{   "NQlistRecipientsRegisteredForCustV1Response": {     "nbsapdpo": {       "returnCode": "0",       "reasonCode": "0",       "serviceVersion": "BUSO001"     },     "nbsmsgo": {       "version": "MSGO003",       "nbrUserMsgs": "0",       "nbrUserErrs": "0"     },     "nqp904o": {       "sbuCd": "F",       "dets": {         "pnsRecipientId": "1",         "recipNm": "Sizwe",         "contactPref": "S",         "lngPref": "E",         "cellPhone": "0797530041"       }     }   } }');
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