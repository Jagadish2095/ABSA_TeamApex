@isTest
global class CreateTrackerMock_ApiRest implements HttpCalloutMock
{
    Private String typeTest;
    
    global CreateTrackerMock_ApiRest (final String typeTest)
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
            response.setBody('{"channel":"WILLS","application":"WILLS","trace":"Y","willNo":"41000014420","tstatus":"D","date":"20190128","time":"1524","userId":"usr112","sstatus":"ARKCD","statCd":"ARKCDxiqbsMyglenFtph","filLoc":"location","prevId":"usr333","action":"FILED","comments":"testing","branchCd":"3232"}');     
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