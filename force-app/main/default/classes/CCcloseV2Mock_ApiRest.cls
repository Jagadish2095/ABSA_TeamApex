/*
* Mock ApiRest Bean for MBcomplEpSpaymentV4 Service
* @author Lulu Rankwe
* @created 2020-03-19
*/
@isTest
global class CCcloseV2Mock_ApiRest implements HttpCalloutMock{
    
    Private String typeTest;
    
    global  CCcloseV2Mock_ApiRest(final String typeTest) {
        this.typeTest = typeTest;
    }
    
    global HTTPResponse respond(HTTPRequest request) 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        
        if(typeTest == StringConstants.POSITIVE_STRING)
        {
            
            response.setBody('{"CCcloseV2Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO001"},"nbsmsgo":{"version":"MSG3001","nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":[{"msgClass":"CCS299","msgCode":"0033","msgErrInd":"E","msgTxt":"Combi 4451430000040415 card is already closed"}]}}}');

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