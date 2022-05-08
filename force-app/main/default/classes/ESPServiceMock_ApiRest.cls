/**
* Apex Integration Mock response class for ESP Onboarding Integration service
* @author  Manoj Danthala : Absa
* @since   2019-02-28
*
**/
@isTest
global class ESPServiceMock_ApiRest implements HttpCalloutMock{

	Private String typeTest;
	global ESPServiceMock_ApiRest(final String typeTest){
		this.typeTest = typeTest;
	}

	global HttpResponse respond(HttpRequest request){
		//Create a fake response
		HttpResponse response = new HttpResponse();
		response.setHeader('Content-Type', 'application/json');
		if(typeTest == StringConstants.POSITIVE_STRING){
			String sampleResponse = '{"RequesterReference":"Absa2 - 0002158","ProcessReference":"SF 63933902","StatusCode":0,"StatusMessage":null}';
			response.setBody(sampleResponse);
			response.setStatusCode(200);
		}else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
	}

}