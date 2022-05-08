/*
 * Mock ApiRest Bean for CQGetPaymentDue Service
 * @author Haritha Police
 * @created 2019-09-14
 */

global class CQgetPaymentDueMock_ApiRest implements HttpCalloutMock {
    Private String typeTest;
    
    global CQgetPaymentDueMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setBody('{"nbsapdpo": {"version": "","returnCode": "0","reasonCode": "0","serviceVersion": "BUSO001","echoKey": ""},"nbsmsgo3": {"version": "MSG3001","sysErrTxt": "","nbrUserMsgs": "0","nbrUserErrs": "0"},"cqh844o": {"accountName": "","accountNbr": "00000000000000000", "dateLastPayment": "0","amountDue": "+000000000000000.00","arrearsAmount": "+000000000000000.00"}}');
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response; 
    }

}