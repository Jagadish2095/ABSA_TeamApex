/*
* Request Bean class for Wqgetanalystcommentsv7
* @author Anka Ganta
* @created 2019-07-05
*/

@isTest
global class Wqgetanalystcommentsv7_ApiRest implements HttpCalloutMock{
  Private String typeTest;
    
    //@param typeTest: positive or negative response
    global Wqgetanalystcommentsv7_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) { 
        
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"WQgetAnalystCommentsV7Response": { "name": "DEREK AUSTIN TOD","surname": "DEREK AUSTIN TOD","idType": "3","idReg": "5603275077085","dob": "19560327","sbu": "H","statusCode": "200","results": { "seqNo": "1","commentCode": "24","commentDesc": "Send customer DOB to ROAebox@absa.co.za" }}}');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(500);
        }
        return response;
    }
}