/**
* Mock class for Post callout to check digit verification from Siebel
* @author  Danie Booysen
* @created 2018-09-11
*/

@isTest
global class CheckDigitVerificationMock_ApiRest implements HttpCalloutMock {
    
    Private String typeTest;
    
    global CheckDigitVerificationMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"rc": "0","branchName": "ABSA ELECTRONIC SETTLEMENT CNT","accountHost": "O","accountExceptionInd": "0","bankCode": "8","aedossIss": "Y","aedossAcq": "Y","naedossIss": "Y","naedossAcq": "Y"}');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
}