/*
 * Mock ApiRest Bean for cqgetacctholdsmaintv4 service
 * @author Mashudu Raidimi
 * @Date 2020-03-01
 */

@isTest
global class CQgetAcctHoldsMaintV4_Mock_ApiRest implements HttpCalloutMock {
   
    
    Private String typeTest;
    
    global CQgetAcctHoldsMaintV4_Mock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
     }
    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) 
    {
        HttpResponse response = new HttpResponse();
        response.setHeader(StringConstants.CONTENT_TYPE_STRING, 'application/json');
        response.setBody('{"CQgetAcctHoldsMaintV4Response":{"nbsapdpo":{"returnCode":"0","reasonCode":"0","serviceVersion":"BUSO003"},"nbsmsgo3":{"version":"MSG3001","nbrUserMsgs":"0","nbrUserErrs":"0","msgEntry":{"msgClass":null,"msgCode":null,"msgErrInd":null,"msgTxt":null}},"cqh503o":{"accountNbrOut":"-246949655","clientName":"MR D ZUMA","blocked":"N","courtOrder":"N","mandateRequired":"N","dormant":"N","semiDormant":"N","confiscated":"N","externalTransfer":"N","staffA":"N","staff":"N","creditAccount":"N","excludeFromEstate":"N","excludeFromEstateA":"Y","blockAdhocDbt":"N","blockAdhocDbtA":"Y","blockAdhocCrd":"N","blockAdhocCrdA":"Y","specialRqpRedirect":"N","commercialPropFin":"N","misHold":"N","genSecMsg":"N","genSecMsgA":"Y","genSecNum":"0","genSecNumA":"Y","wapWildAccPickup":"N","exclFromInsolvent":"N","exclFromInsolventA":"Y","digitalHold":"N","digitalHoldA":"Y","odSwitchInd":"N","odSwitchIndA":"Y"}}}');

        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
                             
    }