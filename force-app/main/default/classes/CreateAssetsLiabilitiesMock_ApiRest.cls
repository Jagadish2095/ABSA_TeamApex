@isTest
global class CreateAssetsLiabilitiesMock_ApiRest implements HttpCalloutMock
{
 	Private String typeTest;
    
    global CreateAssetsLiabilitiesMock_ApiRest (final String typeTest)
    {
        this.typeTest = typeTest;
    }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
      
        if(typeTest == StringConstants.POSITIVE_STRING)
        {
            response.setBody('{"RC":0,"RCMessage":"AWM150S ASSETS AND LIABILITIES UPDATED","WillNo":41000003908,"Assets":"Y","FarmingTestator":250,"FarmingTestatrix":250,"FixedPropTestator":180,"FixedPropTestatrix":180,"MineralTestator":300,"MineralTestatrix":300,"MovAssetsTestator":275,"MovAssetsTestatrix":275,"BusIntTestator":170,"BusIntTestatrix":170,"LiquidAssTestator":170,"LiquidAssTestatrix":170,"AssetsPayTestator":299,"AssetsPayTestatrix":299,"OtherAssTestator":160,"OtherAssTestatrix":160,"Liabilities":"","MortgaugeTestator":100,"MortgaugeTestatrix":100,"OverDraftTestator":200,"OverDraftTestatrix":200,"CreditTestator":100,"CreditTestatrix":100,"TaxTestator":0,"TaxTestatrix":0,"SuretyTestator":100,"SuretyTestatrix":100,"LoanLTestator":100,"LoanLTestatrix":100,"OtherLTestator":100,"OtherLTestatrix":100,"Assurance":"","MortgageAssTestator":0,"MortgageAssTestatrix":238,"OutCededAssTestator":100,"OutCededAssTestatrix":150,"AssetAmt":3374,"LiabilAmt":1910,"FeeCode":"19","FeeDescription":"DISCOVERY/MOMENTUM CONSULT (EXTR EXEC)","FeeAmount":1725.00}');     
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