@isTest
global class WillBankingDetailsMock_ApiRest implements HttpCalloutMock {
    
    Private String typeTest;
    
    public WillBankingDetailsMock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"RCMessage": "","WillNo": 41002347654,"BranchCode": 632008,"BankName": "ABSA","SiteCode": 8145,"BranchName": "ABSA CENTURION MALL","AccountType": "SAVINGS","AccountNumber": 9573338765,"ClientName": "MRS GINA XABA","EffectiveDate": 20190130}');
        
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
}