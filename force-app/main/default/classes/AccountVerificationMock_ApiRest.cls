@isTest
global class AccountVerificationMock_ApiRest implements HttpCalloutMock {
    
    Private String typeTest;
    
    public AccountVerificationMock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"avsruser": "AVSR020000","reference": "17492342CF","reqDate": "20180807","reqTime": "10430101","respDate": "20190117","respTime": "0","respCount": "0","respCode": "0","respDesc": "","receiveBank": "16","receiveBranch": "632005","receiveAccno": "000000000000009050999852","accType": "1","idno": "8008310491084","initials": "PF","name": "PUMEZA","accDebits": "Y","accCredits": "Y","accLength": "Y","emailAddress": "","cellNo": "","accFound": "Y","accOpen": "Y","accTypeMatch": "N","idMatch": "N","initMatch": "N","nameMatch": "N","accAcptDebits": "Y","accAcptCredit": "Y","accLngthMatch": "Y","emailAdresMatch": "U","cellNoMatch": "U"}');
        
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
}