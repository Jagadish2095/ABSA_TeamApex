/**
* @description       : Document Classification Test Class mock response
* @author            : Sandeep
* @return            : Response
**/

@isTest
global class documentClassificationMock_ApiRest implements HttpCalloutMock
{
    Private String typeTest;
    /***
* @comment : MockRestAPI
* @description method to get the MockResponse
* @param typeTest
* **/
    global documentClassificationMock_ApiRest (final String typeTest)
    {
        this.typeTest = typeTest;
    }

    // Implement this interface method
    /***
* @comment : MockRestAPI
* @description method to get the MockResponse
* @param	 request
* @return	 response
* **/
    global HTTPResponse respond(HTTPRequest request)
    {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if(typeTest == StringConstants.POSITIVE_STRING)
        {
            response.setBody('{"RequestUUID": "bbdc964a-2cb6-4f58-9d3c-d260e5f4c271","FileName": "Test","DocumentType": "driverslicense","Results": {"Status": "OK", "Details": ""},"ResponseFields": {"ItemType": "Ent_ProofOfId"}}');
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