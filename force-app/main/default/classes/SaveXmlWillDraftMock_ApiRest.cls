@isTest
global class SaveXmlWillDraftMock_ApiRest implements HttpCalloutMock
{
    Private String typeTest;
    
    global SaveXmlWillDraftMock_ApiRest (final String typeTest)
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
            response.setBody('{"RC":0,"RCMessage":"Transaction Successful","WillNo":41005576899}');     
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