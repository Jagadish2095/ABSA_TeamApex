/*
 * Mock ApiRest Bean for NHgetSentProductNotificationV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-05-06
 */

 @ isTest
global class nHgetSentProductNtfV1_Mock_ApiRest implements HttpCalloutMock {

    private String typeTest;

    global nHgetSentProductNtfV1_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {

            response.setBody('{   "NHgetSentProductNotificationV1Response": {     "nbsapdpo": {       "version": null,       "returnCode": "0",       "reasonCode": "0",       "echoKey": "99999999999999999999"     },     "nhs932o": {       "rcde": "0",       "rcdeType": "0",       "rcdeSource": null,       "rcdeReason": "0",       "rdesc": null,       "recipientAddress": null,       "notifMessage": "Absa: Welcome to NotifyMe. You will start receiving notifications within 24hrs. Dial *120*2272# to access your Balance or buy PrePaid airtime. For assistance, p"     }   } }');
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