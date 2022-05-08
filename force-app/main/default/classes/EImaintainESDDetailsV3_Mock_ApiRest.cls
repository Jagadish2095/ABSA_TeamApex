/*
 * Mock ApiRest Bean for EImaintainESDDetailsV3 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-04-07
 */
@ isTest
global class EImaintainESDDetailsV3_Mock_ApiRest implements HttpCalloutMock {
    private String typeTest;

    global EImaintainESDDetailsV3_Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if (typeTest == StringConstants.POSITIVE_STRING) {
            response.setBody('{   "EImaintainESDDetailsV3Response": {     "nbsapdpo": {       "version": null,       "returnCode": "0",       "reasonCode": "0",       "serviceVersion": "BUSO002"     },     "nbsmsgo": {       "version": "MSG3001",       "nbrUserMsgs": "0",       "nbrUserErrs": "0"     },     "eip103o": {       "request": "E",       "channel": "I",       "site": "3043",       "teller": "11332",       "acn": "-243755294",       "product": "CQ",       "prodCode": "0",       "jvCode": "1",       "date": "20200218",       "time": "22235255",       "eCount": "1",       "lDate": "20200312",       "lTime": "13241853",       "lChannel": "B",       "lSite": "8913",       "lTeller": "8913",       "status": "D",       "marketerCodeInit": "0",       "marketerCodeAmend": "0",       "entry": [         {           "wm": "N",           "eLngth": "15",           "email": "test@gmail.com;"         }       ]     }   } }');
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