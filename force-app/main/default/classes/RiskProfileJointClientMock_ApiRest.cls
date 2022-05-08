@isTest
global class RiskProfileJointClientMock_ApiRest implements HttpCalloutMock{
    
        Private String typeTest;
    
    public RiskProfileJointClientMock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"msgNo":"200","msg":"Risk Profiling Completed Succesfully!! Final Score is $5580.0$","riskRating":"M"}');
        
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
}