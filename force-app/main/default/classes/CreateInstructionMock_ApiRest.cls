@isTest
global class CreateInstructionMock_ApiRest implements HttpCalloutMock {
    
    Private String typeTest;
    
    public CreateInstructionMock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"todaysDate": "20190117","timeNow": "15030706","respCode": "0","respOther": "0","recsReturn": "0","respDesc": "SUCCESSFUL PROCESS","instrTypeDrcr": "D","instrTypeDuepe": "P","instrTypeAccs": "Y","fwWarnInd": "","instrNo": "0","multiNo": "0","intExtBenInd": "E","actDate": "20181120","trigDate": "0","srcAcc": "000000000000004047698294","srcAccType": "CQ","srcClrCode": "632005","srcInstCode": "ABSA BANK","trgAcc": "000000000000062161856087","trgAccType": "01","trgClrCode": "251445","trgInstCode": "FIRSTRAND","corpCode": "Z","sbu": "F","clientType": "I","iipAllowInd": "","lastChangeNo": "0","lastMaintFunc": "","changeNo": "0","changeSet": "0","changeDate": "0","changeTime": "0","changeFunc": "","changeBranch": "0","changeTeller": "0","changeOverride": ""}');
        
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
}