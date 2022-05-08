/*
 * Mock ApiRest Bean for CIgetSpecialPowerOfAttorneyV4 service
 * @author Srikanth N
 * @created 2020-05-07
 */

 @ isTest
global class CIgetSpecialPowerOfAttorney_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global  CIgetSpecialPowerOfAttorney_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{"CIgetSpecialPowerOfAttorneyV4Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO003"},"nbsmsgo3":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":{"msgClass":"CLSMGC01","msgCode":"328","msgErrInd":"E","msgTxt":"SPECIAL POWER OF ATTORNEY DOES NOT EXIST"}},"cip080do":{"clientCode":null,"nbrSignRetrieved":"0","restartKeyOutput":null,"outputTable":{"idType":"Passport"}}}}');
            response.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }
}