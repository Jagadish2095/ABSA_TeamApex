/*
 * Mock ApiRest Bean for cqgetacctholdsmaintv4 service
 * @author Mashudu Raidimi
 * @Date 2020-03-01
 */

@isTest
global class SVgetAccountHoldsDetailV4_MockApiRest implements HttpCalloutMock {
   
    
    Private String typeTest;
    
    global SVgetAccountHoldsDetailV4_MockApiRest(final String typeTest){
        this.typeTest = typeTest;
     }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        response.setBody('{"SVgetAccountHoldsDetailV4Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO004"},"nbsmsgo3":{"version":"MSG3001","sysErrTxt":null,"nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}},"svsp40o":{"frozenInd":"N","frozenPrt":"N","stoppedInd":"N","stoppedPrt":"N","dormantInd":"N","dormantPrt":"N","semiDormantInd":"N","semiDormantPrt":"Y","exclEstateInd":"N","exclEstatePrt":"N","exclInslvntInd":"N","exclInslvntPrt":"N","courtOrderInd":"N","courtOrderPrt":"N","signingAuthInd":"N","signingAuthPrt":"N","monitorActivityInd":"N","monitorActivityPrt":"N","badDebtInd":"Y","badDebtPrt":"N","potBadDebtInd":"N","potBadDebtPrt":"N","legalActionInd":"N","legalActionPrt":"N","nonResidentInd":"N","nonResidentPrt":"N","lostBookInd":"N","lostBookPrt":"Y","blockedInd":"N","blockedPrt":"N","offlineEnqInd":"N","offlineEnqPrt":"N","offlEnqFrDate":"0","offlEnqFrDtPrt":"N","securityMessageInd":"N","securityMessagePrt":"N","securityNbr":"0","securityNbrPrt":"N","exceedMaxBalInd":"N","exceedMaxBalPrt":"N","restricHoldInd":"N","restricHoldPrt":"Y","wtiCountry":null,"wtiCountryPrt":"Y","rbaEddHold":"N","rbaEddHoldPrt":"Y"}}}');

        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
                             
    
}