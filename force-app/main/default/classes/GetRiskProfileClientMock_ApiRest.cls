@isTest
global class GetRiskProfileClientMock_ApiRest implements HttpCalloutMock{
    
    Private String typeTest;
    
    global GetRiskProfileClientMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setBody('{"WQriskProfileClientV7Response": {"msgNo": "200","msg": "Risk Profiling Completed Succesfully!! Score is $4460.0$","riskRating": "M"}}');
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setBody(StringConstants.ERROR_MSG_READ_TIMED_OUT);
            response.setStatusCode(400);
        }
        return response; 
    }
}