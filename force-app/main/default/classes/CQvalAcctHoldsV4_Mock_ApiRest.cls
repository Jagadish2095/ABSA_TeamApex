/*
 * Mock ApiRest Bean for cqgetacctholdsmaintv4 service
 * @author Mashudu Raidimi
 * @Date 2020-03-01
 */

@isTest
global class CQvalAcctHoldsV4_Mock_ApiRest implements HttpCalloutMock {
   
    
    Private String typeTest;
    
    global CQvalAcctHoldsV4_Mock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
     }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        response.setBody('{"CQvalAcctHoldsV4Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO004"},"nbsmsgo3":{"version":"MSG3001","nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}}}}');
                         

        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
                             
    

}