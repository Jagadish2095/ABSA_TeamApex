/**
* Mock class for Reg Services Involved Parties
* @author  Pitso Sekhu
* @created 2018-11-30
*/

@isTest
global class AddAccountToPortfolio_Mock_ApiRest implements HttpCalloutMock
{

    Private String typeTest;
    
    global AddAccountToPortfolio_Mock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setBody('{"version":"MSG3001","sysErrTxt":"*EXCEPTION* 30/11/2018 16:09:36. EXCP CODE: 0001. IN PGM: NBM102D .   LABEL/SECTION: RZEXPG-H. CALLING PGM: CIP015  .                       PROCESS ID: WSDL STUB -CIP015  -","nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":[{"msgClass":"RZSMGAB","msgCode":"0003","msgErrInd":"E","msgTxt":"A technical/system error has occured."}]}');
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }else if(typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS){
            response.setBody('{}');
            response.setStatusCode(500);
        }
        return response; 
    }
}