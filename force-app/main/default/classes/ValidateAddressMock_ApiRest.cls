@isTest
global class ValidateAddressMock_ApiRest implements HttpCalloutMock{

    Private String typeTest;
    
    global ValidateAddressMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setBody('{"nbrUserMsgs": "0","nbrUserErrs": "0","msgEntry": [],"numAddrReturn": "1","addressCollection": [{"addressType": "10","addressLine1": "5 LIBERTAS ROAD","addressLine2": "POSTALADDRESSLINE2","town": "BRYANSTON","postalCode": "2191"}]}');
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response; 
    }
}