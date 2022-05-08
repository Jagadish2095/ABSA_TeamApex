/*
 * Mock ApiRest Bean for Prediction Service
 * @author Muvhuso Nekhubvi
 * @created 2020-06-26
 */
@ isTest
global class Prediction_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global Prediction_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{     "data": {         "caseId": "123",         "serviceTypeId": "External",         "status": "Closed",         "confidence": 1.0,         "responseAction": "none" ,  "accountId": "0011X00000eG0a7QAC"   },     "success": true,     "message": "OK",     "errors": [] }');
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