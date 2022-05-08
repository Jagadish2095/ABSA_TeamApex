/*
 * Mock ApiRest Bean for cqgetacctholdsmaintv4 service
 * @author Mashudu Raidimi
 * @Date 2020-03-01
 */

@isTest
global class CQupdAcctHoldsV4_Mock_Api implements HttpCalloutMock {
   
    
    Private String typeTest;
    
    global CQupdAcctHoldsV4_Mock_Api(final String typeTest){
        this.typeTest = typeTest;
     }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        response.setBody('{"CQupdAcctHoldsV4Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO004"},"nbsmsgo3":{"version":"MSG3001","nbrUserMsgs":"1","nbrUserErrs":"1","msgEntry":{"msgClass":"CQSMGC01","msgCode":"154","msgErrInd":"E","msgTxt":"Closed account, transaction not allowed."}},"cqh525o":{"accountNbrOut":"0","confirmationDetails":[{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null},{"details":null}]}}}');
                         

        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }

}