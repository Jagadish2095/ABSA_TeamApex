/*
 * Mock ApiRest Bean for cqgetacctholdsmaintv4 service
 * @author Mashudu Raidimi
 * @Date 2020-03-01
 */

@isTest
global class SVupdateAccountHoldsV4_Mock_ApiRest implements HttpCalloutMock {
   
    
    Private String typeTest;
    
    global SVupdateAccountHoldsV4_Mock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
     }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        response.setBody('{"SVupdateAccountHoldsV4Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO004"},"nbsmsgo3":{"version":"MSG3001","nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":{"msgClass":"SVSMGC01","msgCode":"32","msgErrInd":"E","msgTxt":"A technical/system error has occured."}},"svsp42o":{"amountCharged":"0","eventNbr":"0","overrideInd":"0","holdNbr":"NaN"}}}');

        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
                             
    
}