/**
* Apex Integration Mock response class for TOM Complaint Integration service
* @author  Anka Ganta : Absa
* @since   2019-08-15
*
**/
@isTest
global class TOMComplaintServiceMock_ApiRest implements HttpCalloutMock{

    Private String typeTest;
    global TOMComplaintServiceMock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }

    global HttpResponse respond(HttpRequest request){
        //Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){
            String sampleResponse = '{"tomCaseNumber":40,"complaintNumber":"C-01275691","status":"Waiting for Data","tomDecision":"","tomReason":""}';
            response.setBody(sampleResponse);
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response;
    }

}