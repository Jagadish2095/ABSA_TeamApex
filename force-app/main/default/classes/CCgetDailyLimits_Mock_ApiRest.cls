/*
 * Mock ApiRest Bean for CCgetDailyLimits Service
 * @author Prashant Jain
 * @created 2019-09-11
 */

 @ isTest
global class CCgetDailyLimits_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global CCgetDailyLimits_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001"},"nbsmsgo":{"version":"MSG3001","nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":{"msgClass":"CCS299","msgCode":"0025","msgErrInd":"E","msgTxt":"Combi card number 0000000000000001 does not exist"}},"ccp312o":{"cardCshLim":"0","cardTrfLim":"0","cardPosLim":"0","cardCntLim":"0","cheqNomAcc":"0","cheqApplNo":"0","cheqCshLim":"0","cheqTrfLim":"0","cheqPosLim":"0","savsNomAcc":"0","savsApplNo":"0","savsCshLim":"0","savsTrfLim":"0","savsPosLim":"0","cardCshMax":"0","cardTrfMax":"0","cardPosMax":"0","cardCntMax":"0"}}');
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