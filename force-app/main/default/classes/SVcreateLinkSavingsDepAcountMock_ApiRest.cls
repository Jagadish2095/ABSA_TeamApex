/*
 * Mock ApiRest Bean for SVcreateLinkSavingsDepAccount service
 * @author Srikanth N
 * @created 2020-02-26
 */

@isTest
global class SVcreateLinkSavingsDepAcountMock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global SVcreateLinkSavingsDepAcountMock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody(
                '{"SVcreateLinkSavingsNoticeDepAccountV6Response": {"nbsapdpo": {"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO006"},"svpp15o": { "accountNumber": "123456789" },"nbsmsgo3": {"nbrUserMsgs": "1","nbrUserErrs": "1","msgEntry": {"msgClass": "SVSMGC01","msgCode": "0125","msgErrInd": "E","msgTxt": "Client code  is invalid."}}}}'
            );
            response.setStatusCode(200);
        } else if (typeTest == StringConstants.NEGATIVE_STRING) {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }
}