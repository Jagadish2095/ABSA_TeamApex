@isTest
global class GetAccountDetailsViaRefMock_ApiRest implements HttpCalloutMock
{
    Private String typeTest;
    
    global GetAccountDetailsViaRefMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
		// Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
              
        if(typeTest == StringConstants.POSITIVE_STRING)
        {
            response.setBody('{"version":"","returnCode":"0","reasonCode":"0","serviceVersion":"BUSO002","echoKey":"","avsruser":"AVSR004000","reference":"1749288A5B","reqDate":"20170411","reqTime":"15150000","respDate":"20190308","respTime":"11581399","respCount":"0","respCode":"0","respDesc":"PROCESSED","receiveBank":"16","receiveBranch":"632005","receiveAccno":"000000000000009050333830","accType":"2","idno":"D123456345634","initials":"RM","name":"RAYN","accDebits":"Y","accCredits":"Y","accLength":"Y","emailAddress":"","cellNo":"","accFound":"Y","accOpen":"N","accTypeMatch":"Y","idMatch":"N","initMatch":"N","nameMatch":"N","accAcptDebits":"N","accAcptCredit":"N","accLngthMatch":"N","emailAdresMatch":"U","cellNoMatch":"U"}');     
            response.setStatusCode(200);
        }
        else if(typeTest == StringConstants.NEGATIVE_STRING)
        {
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        else if(typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS)
        {
            response.setBody('{}');
            response.setStatusCode(500);
        }
        return response; 
    }
    
}