/**
* Mock class for Post callout to update Siebel
* @author  Kyle Alexander
* @created 2018-07-30
*/

@isTest
global class UpdateLeadStatusSiebelMock_ApiRest implements HttpCalloutMock {
    
    Private String typeTest;
    
    global UpdateLeadStatusSiebelMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"salesStage":"Closed","salesMethod":"Estate Provider Plan","reasonWonLost":"Successful Sale","id":"1-BSGP6F"}');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
}