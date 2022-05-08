@isTest
global class UpdateComplaintPartyMock implements HttpCalloutMock
{
    Private String typeTest;
    
    global UpdateComplaintPartyMock (final String typeTest)
    {
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        system.debug('****request***'+request);
        system.debug('****requestgetEndpoint()***'+request.getEndpoint());
        if(request.getEndpoint().contains('updateComplaint/v01')){
            if(typeTest == StringConstants.POSITIVE_STRING)
            {
                system.debug('POSITIVE_STRING');
                response.setBody('{\"statusCode\":200,\"status\":\"200 OK\",\"description\":\"successfully updated tom Feedback to case\",\"caseId\":\"5006E00000DoNCJQA3\"}');
                response.setStatusCode(200);
            }
            else if(typeTest == StringConstants.NEGATIVE_STRING)
            {
                system.debug('NEGATIVE_STRING');
                response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
                response.setStatusCode(400);
            }
            else if(typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS)
            {
                system.debug('UNHANDLED_EXCEPTION_STATUS');
                response.setBody('{}');
                response.setStatusCode(500);
            }
        }
        
        else if(request.getEndpoint().contains('updateComplaint/v01')){
            if(typeTest == StringConstants.POSITIVE_STRING){
            	response.setBody('{\"statusCode\":200,\"status\":\"200 OK\",\"description\":\"successfully updated tom Feedback to case\",\"caseId\":\"5006E00000DoNCJQA3\"}');
            	response.setStatusCode(200);
        	}else if(typeTest == StringConstants.NEGATIVE_STRING){
            	response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            	response.setStatusCode(400);
        	}else if(typeTest == StringConstants.UNHANDLED_EXCEPTION_STATUS){
            	response.setBody('{}');
            	response.setStatusCode(200);
        	}
        }
        return response; 
    }
}