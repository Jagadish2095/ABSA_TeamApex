/*
 * Mock ApiRest Bean for HanisValidate Service
 * @author Prashant Jain
 * @created 2020-02-12
 */

@isTest
global class HanisValidate_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global HanisValidate_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{ "transactionID":"6557fd4a-57ee-40b9-9503-9ca65ebc2683", "idNumber":"7707077777087", "name":"", "surname":"", "hasSmartCard":false, "dateIssued":"", "idSequenceNo":0, "deadIndicator":false, "idBlocked":false, "dateOfDeath":"", "maritalStatus":"", "dateOfMarriage":"", "image":"", "onHanis":false, "onNpr":false, "birthPlaceCountryCode":"", "errorCode":800, "CertError":"HBC20001: Certificate could not be generated", "sessionID":"a025d84e-6a7e-47f6-b542-3437a6751dd7" }');
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