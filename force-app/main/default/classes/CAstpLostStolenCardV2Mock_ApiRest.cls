/*
 * Mock ApiRest Bean for CAstpLostStolenCardV2 Service
 * @author Madhava Palla
 * @created 2019-09-17
 */
 @ isTest
global class CAstpLostStolenCardV2Mock_ApiRest implements HttpCalloutMock {
	 Private String typeTest;
    
    global CAstpLostStolenCardV2Mock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setBody('{ "CAstpLostStolenCardV2Response": {"nbsapdpo": {"returnCode": "0",  "reasonCode": "0" }, "can912o": { "returnCd": "1195","returnMsg": "STAT CHNG ITEM NOT FND -106024" }}}');
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response; 
    }
}