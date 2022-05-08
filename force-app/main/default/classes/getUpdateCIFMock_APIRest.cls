@isTest
global class getUpdateCIFMock_APIRest implements HttpCalloutMock
{
    Private String typeTest;
	/***
    * @method : getUpdateCIFMock_APIRest
    * @description getUpdateCIFMock_APIRest
    * @param typeTest 
    **/ 
    global getUpdateCIFMock_APIRest (final String typeTest)
    {
        this.typeTest = typeTest;
    }
    
    /***
    * @method : respond
    * @description Implement this interface method
    * @param request  
    * @return HTTPResponse
    **/
    global HTTPResponse respond(HTTPRequest request)
    {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');

        if(typeTest == StringConstants.POSITIVE_STRING)
        {
            response.setBody('{"outputHeaders":{"outputPayloadHeaders":{"returnCode":0,"outputServiceVersion":"BUSO020","reasonCode":0,"version":""}},"outputErrorMessage":{"errorMessageParameters":{"systemErrorText":"","messageEntryTable":[{"messageText":"","messageErrorInd":"","messageClass":"","messageCode":""},{"messageText":"","messageErrorInd":"","messageClass":"","messageCode":""},{"messageText":"","messageErrorInd":"","messageClass":"","messageCode":""},{"messageText":"","messageErrorInd":"","messageClass":"","messageCode":""},{"messageText":"","messageErrorInd":"","messageClass":"","messageCode":""}],"version":"","numberUserErrors":0,"numberUserMessages":0}},"CIupdClientAttestationV20Response":{"outputArea":{"returnCode":0,"clientCode":"KANDAK 001","message":"Attestation Successful"}}}');
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