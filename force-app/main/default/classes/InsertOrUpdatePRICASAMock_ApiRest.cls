/**
* Mock class for Insert Or Update PRI CASA
* @author  Jason Quevauvilliers
* @created 2018-07-30
*/
@isTest
global class InsertOrUpdatePRICASAMock_ApiRest implements HttpCalloutMock{

    Private String typeTest;
    
    global InsertOrUpdatePRICASAMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"PRINumber": "900028001550"}');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(500);
        }
        return response; 
    }
}