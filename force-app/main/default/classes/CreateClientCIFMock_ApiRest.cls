@isTest
global class CreateClientCIFMock_ApiRest implements HttpCalloutMock{
    
    Private String cvsValidate;
    Private String validateAddress;
    Private String createClient;
    Private String updateJoint;
    
    global CreateClientCIFMock_ApiRest (final String cvsValidate, final String validateAddress, final String createClient, final String updateJoint){
        this.cvsValidate = cvsValidate;
        this.validateAddress = validateAddress;
        this.createClient = createClient;
        this.updateJoint = updateJoint;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
     
        if(request.getEndpoint().contains('Validate Client Details CIF')){//validateData
           
            if(cvsValidate == StringConstants.POSITIVE_STRING){
                 system.debug('request if'+request);
                response.setBody('{"statusCode":"0"}');
                response.setStatusCode(200);
            }else{
                 system.debug('request else'+request);
                //response.setBody('{"statusCode": "1","statusMessage": {"error": {"reason": "ID type / ID number already exists"}}}');//,"error": [{"reason": "ID type / ID number already exists"}]
                //response.setBody('{"statusCode":"1","statusMessage":{"error":{"reason":"ID type / ID number already exists"}}}');
                //response.setBody('{"statusCode":"1","statusMessage":{"error":[{"reason":"ID type mandatory"},{"reason":["Correspondence language mandatory"]},{"reason":"Invalid Preferred communication channel"},{"reason":"ID type / ID number already exists"}]}}');
                response.setBody('{"statusCode":"1","statusMessage":{"error":[{"reason":"ID type mandatory"},{"reason":["Correspondence language mandatory"]}],"error":{"reason":"ID type mandatory"}}}');
                response.setStatusCode(400);
            }
            
        }else if(request.getEndpoint().contains('Validate Address')){//validate/collection
             system.debug('requestelse if'+request);
            if(validateAddress == StringConstants.POSITIVE_STRING){
                response.setBody('{"nbrUserMsgs": "0","nbrUserErrs": "0","msgEntry": [],"numAddrReturn": "1","addressCollection": [{"addressType": "10","addressLine1": "5 LIBERTAS ROAD","addressLine2": "POSTALADDRESSLINE2","town": "BRYANSTON","postalCode": "2191"}]}');
                response.setStatusCode(200);
            }else{
                 system.debug('request else else'+request);
                response.setBody('{}');
                response.setStatusCode(400);
            } 
            
        }else if(request.getEndpoint().contains('Create Client CIF')){//CIFcreateClient
             
            if(createClient == StringConstants.POSITIVE_STRING){
                system.debug('request cif'+request);
                response.setBody('{"CIcreateClientV12Response": {"nbsapdpo": {"version": null,"returnCode": 0,"reasonCode": 0,"serviceVersion": "BUSO009","echoKey": null},"nbsmsgo3": {"version": "MSG3001","sysErrTxt": null,"nbrUserMsgs": 0,"nbrUserErrs": 0},"cib003o": {"outputCkey": "TESTPT 036"}}}');
                response.setStatusCode(200);
            }else{
                system.debug('request cifelse'+request);
                response.setBody('{ "CIcreateClientV12Response": {"nbsapdpo": {"version": null,"returnCode": 0,"reasonCode": 0,"serviceVersion": "BUSO009","echoKey": null},"nbsmsgo3": {"version": "MSG3001","sysErrTxt": null,"nbrUserMsgs": 1,"nbrUserErrs": 0,"msgEntry": {"msgClass": "CLSMGC01","msgCode": "0657","msgErrInd": "E","msgTxt": "INVALID INPUT COMBINATION"}},"cib003o": {"outputCkey": null}}}');
                response.setStatusCode(400);
            }
            
        }else if(request.getEndpoint().contains('Update Joint Participant By Client Code')){
            if(updateJoint == StringConstants.POSITIVE_STRING){
                response.setBody('{"CIupdJointParticipantsByClientCodeV7Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO006"},"nbsmsgo3":{"version":"MSG3001","nbrUserMsgs":"0","nbrUserErrs":"0"},"cib033o":{"errorTable":[{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"},{"errorCode":"0"}]}}}');
                response.setStatusCode(200);
            }else{
                response.setBody('{}');
                response.setStatusCode(400);
            } 
        }
        system.debug('response'+response);
        return response; 
    }
    
}