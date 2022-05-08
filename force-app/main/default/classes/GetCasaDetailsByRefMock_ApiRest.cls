/*
* Request Bean class for GetCasaDetailsByRef
* @author Danie Booysen & Jason Quevauvilliers
* @created 2019-07-05
*/

@isTest
global class GetCasaDetailsByRefMock_ApiRest implements HttpCalloutMock{
    
    Private String typeTest;
    
    //@param typeTest: positive or negative response
    global GetCasaDetailsByRefMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) { 
        
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"msgNo": "0","msg": "","firstName": "MAYA ","surnameComp": "BOOTH ","idType": "1","idRegNo": "8805240649081","clientTypeGrp": "I","dob": "19880524","nationality": "GAM01",'+
                         '"cntryOfRes": "SO003","status": "I","approvedSts": "","documentSts": "P","pepSts": "","sbu": "61 ","riskRequired": "Y","primaryClient": "0","noParticipants": "0","dateTime": "","countryOfBirth": ""}');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(500);
        }
        return response;
    }
    
}