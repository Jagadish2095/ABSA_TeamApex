@isTest
global class UpdateJntPartByClientCodeMock_ApiRest implements HttpCalloutMock {
    
    Private String typeTest;
    
    public UpdateJntPartByClientCodeMock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"CIupdJointParticipantsByClientCodeV7Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO006"},"nbsmsgo3":{"version":"MSG3001","nbrUserMsgs":"0","nbrUserErrs":"0"},"cib033o":{"errorTable":[{"errorCode":"2","errorMessage":"CLIENT NOT FOUND"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"}]}}}');        
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
}