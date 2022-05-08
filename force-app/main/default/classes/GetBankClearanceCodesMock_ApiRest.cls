@isTest
global class GetBankClearanceCodesMock_ApiRest implements HttpCalloutMock {
	
    Private String typeTest;
    
    global GetBankClearanceCodesMock_ApiRest (final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"moreInd":"Y","bankBranchList":[{"instNameLst":"ABSA BANK LIMITED","branchNameLst":"COMMISSIONERSTRAAT*","clrCodeLst":"301105","instShrtnamLst":"","telNrLst":"","ssviLst":"","ds1iLst":"","ds2iLst":"","ds5iLst":"","add1Lst":"","add2Lst":"","poboxLst":"","pofficeLst":"","pcodeLst":"0","outCentreLst":"","streamLst":""}]}');
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
}