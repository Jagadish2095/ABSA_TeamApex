/*
* Mock ApiRest Bean for CASAScreenRelatedParty Service
* @author Pitso Sekhu
* @created 2019-03-13
*/

@isTest
global class CASAScreenRelatedPartyMock_ApiRest_v2 implements HttpCalloutMock
{
    Private String typeTest;
    
    global CASAScreenRelatedPartyMock_ApiRest_v2 (final String typeTest)
    {
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
            response.setBody('{"msgNo":"0","msg":"Success","refNo":"120004946","status":"P"}');     
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