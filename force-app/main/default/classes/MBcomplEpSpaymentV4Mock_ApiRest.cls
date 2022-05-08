/*
* Mock ApiRest Bean for MBcomplEpSpaymentV4 Service
* @author Lulu Rankwe
* @created 2020-03-06
*/

global class MBcomplEpSpaymentV4Mock_ApiRest implements HttpCalloutMock
{
    
    Private String typeTest;
    
    public MBcomplEpSpaymentV4Mock_ApiRest(final String typeTest){
        this.typeTest = typeTest;
    }

    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"MBcomplEPSpaymentV4Response": {"nbsapdpo": {"returnCode": "0", "reasonCode": "0", "serviceVersion": "BUSO001"},"nbsmsgo": {"version": "MSG3021","sysErrTxt": null,"nbrUserMsgs": "0","nbrUserErrs": "0","msgEntry": {"msgClass": null,"msgCode": null, "msgErrInd": null,"msgTxt": null}},"mbp302o": {"procMode": "O", "todaysDate": "20200413","timeNow": "14162108","respCode": "0","respOther": "0","recsReturn": "1","respDesc": "SUCCESSFUL PROCESS","fwWarnInd": null, "instrStatus": "CURRENT", "intExtBenInd": "E","actDate": "20200218","trigDate": "20200218", "amount": "500.23","srcAcc": "000000000000009050544469","srcAccType": "SA","srcClrCode": "632005", "srcInstCode": "ABSA BANK","srcStmtRef": "test ac","trgAcc": "000000000000062001847237","trgAccType": "1","trgClrCode": "250655","trgInstCode": "FIRSTRAND","trgStmtRef": "test ac", "corpCode": "Z","sbu": "F","payDay": "0","doType": null,"cardAuth": "0","notifInd": null,"srcNotifMed": "N","trgNotifMed": "N","lastMaintOvrId": null,"lastMaintOvr2Id": null,"changeOverride2": null,"changeOverride": null,"paymStatus": "COMPLPAYM","paymTime": "114900", "paymProcessAmnt": "500.23","paymErrCode": "0","paymIipInd": "D","paymIipAuth": "323589","paymBusRef": "1605F9ACE7","paymNotes": null,"initpaymOverride": null,"productsSpa": null}}}');
        
        if(typeTest == StringConstants.POSITIVE_STRING){
            response.setStatusCode(200);
        }else if(typeTest == StringConstants.NEGATIVE_STRING){
            response.setStatusCode(400);
        }
        return response; 
    }
    
    
}