/*
 * Mock ApiRest Bean for NhlistAcctTransactionHIstoryv5 service
 * @author Mashudu Raidimi
 * @Date 2020-03-01
 */

@isTest
global class NhlistAcctTransHIstoryv5_Mock_ApiRest implements HttpCalloutMock {
   
    
    Private String typeTest;
    
    global NhlistAcctTransHIstoryv5_Mock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
     }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        response.setBody('{"NHlistAcctTransactionHistoryV5Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO004","echoKey":"DP78001832331702911"},"nhp021o":{"rcde":"0","rcdeType":"0","rcdeSource":null,"rcdeReason":"0","rdesc":null,"moreToCome":"N","currentBal":"+008140512748300.98","availableBal":"+008140512748250.98","unclearedAmt":"+000000000000000.00","unclearedEffects":null,"pagingKey":"00000{0000{0000B 0000000{00000000{0000000{0000000000{00{00{","count":"2","statementDetails":[{"processingDate":"20200228","effectiveDate":"20200227","description1":"INETBNK PAY DEBIT","description2":"CORPORATE Ndalo","description3":null,"tranAmount":"-000000000000140.00","tranCost":"0","balAfterTran":"+008070678325778.28","tranType":null,"eventNum":"0","lineNum":"1","tranCat":"4"},{"processingDate":"20200228","effectiveDate":"20200227","description1":"INETBNK PAY DEBIT","description2":"CORPORATE Ndaloenhle","description3":null,"tranAmount":"-000000000000140.00","tranCost":"0","balAfterTran":"+008070678325638.28","tranType":null,"eventNum":"0","lineNum":"2","tranCat":"4"}]}}}') ;

        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
                             
    }