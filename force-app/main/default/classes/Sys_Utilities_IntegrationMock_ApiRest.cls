@isTest
global class Sys_Utilities_IntegrationMock_ApiRest implements HttpCalloutMock{

    Private String typeTest;
    
    global Sys_Utilities_IntegrationMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){            
            response.setBody('{}');
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(500);
        }else if(typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS){
            response.setBody('{}');
            response.setStatusCode(500);
        }
        return response; 
    }
}