@isTest
global class SMSGatewayMock_APIRest implements HttpCalloutMock {
    
    Private String typeTest;
    Private String status;
    
    global SMSGatewayMock_APIRest (final String typeTest, final String status){
        this.typeTest = typeTest;
        this.status = status;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        //Set the response status code
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        //Set the response body
        if(status == 'Success'){
            response.setBody('Success&MessageReference=400370015550332008&PhoneNumber=+27714622380&Credits=493');
        }else if(status == 'Error'){
            response.setBody('Error&ErrorCode=3&ErrorDescription=Technical error');
        }
        
        return response; 
    }
}