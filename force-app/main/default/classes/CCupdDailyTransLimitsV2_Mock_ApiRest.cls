/*
 * Mock ApiRest Bean for CCupdDailyTransLimitsV2 Service
 * @author Muvhuso Nekhubvi
 * @created 2019-10-10
 */

@ isTest

global class CCupdDailyTransLimitsV2_Mock_ApiRest implements HttpCalloutMock{
    
    private String typeTest;

    global CCupdDailyTransLimitsV2_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{"CCupdDailyTransactionLimitsV2Response": {"nbsapdpo": {"returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001"},"nbsmsgo": {"version": "MSG3001","nbrUserMsgs": "0","nbrUserErrs": "0"},"ccp321o": {"limRec": "Y"}}}');
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