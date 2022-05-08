/**
* Mock class for CASAPrimaryClientScreening
* @author  Himanshu Nimje
* @created 2018-10-08
*/

@isTest
global class CASAPrimaryClientScreeningMock_ApiRest implements HttpCalloutMock {
    Private String typeTest;
    
    global CASAPrimaryClientScreeningMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) { 
        
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"version":"","returnCode":"0","reasonCode":"0","echoKey":"","msgNo":"0","msg":"","refNo":"2036095","status":"P","serviceVersion":""}');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(500);
        }
        return response;    
    }
    
}