@isTest
global class CCissueCombiCard_Mock_ApiRest implements HttpCalloutMock {
   
    
    Private String typeTest;
    
    global CCissueCombiCard_Mock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
     }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        response.setBody('{"CCissueCombiCardV1Response":{"nbsapdpo":{"version":"","returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001","echoKey":""},"nbsmsgo3":{"version":"","sysErrTxt":"","nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":[{"msgClass":"","msgCode":"","msgErrInd":"","msgTxt":""},{"msgClass":"","msgCode":"","msgErrInd":"","msgTxt":""},{"msgClass":"","msgCode":"","msgErrInd":"","msgTxt":""},{"msgClass":"","msgCode":"","msgErrInd":"","msgTxt":""},{"msgClass":"","msgCode":"","msgErrInd":"","msgTxt":""}]},"ccp348o":{"cardIssueInd":"Y","newCombiNbr":"04938050012744748","lvpApplNbr":"00000000000000000","cardFeeInd":"N","cardFeeType":"","cardFeeAmnt":"0","delvFeeInd":"N","delvFeeType":"","delvFeeAmnt":"0"}}}');
                         

        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }

}