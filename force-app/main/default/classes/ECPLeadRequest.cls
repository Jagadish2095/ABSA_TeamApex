/**
* @description       :
* @author            : jacobuschristiaan.delange@absa.africa
* @group             :
* @last modified on  : 2021-05-27
* @last modified by  : jacobuschristiaan.delange@absa.africa
* Modifications Log
* Ver   Date         Author                                  Modification
* 1.0   2021-05-25   jacobuschristiaan.delange@absa.africa   Initial Version
**/
public class ECPLeadRequest {
/**
 * @description
 * @author jacobuschristiaan.delange@absa.africa | 2021-05-25
 * @param accId
 * @param leadPrdInterest
 * @param accStatus
 **/
@future(callout=true)
public static void ECPLeadRequestCall(string accId, string leadPrdInterest, string accStatus) {
    string ecpLeadReq;
    string ecpLeadResBody;
    Integer count = 0;

    Account accRec = new AccountsSelector().selectAllById(accId);

    if (accRec != null) {
        List<String> lProdInterest = leadPrdInterest.split(';');

        string execLayReqId = accRec.ExecutionLayerRequestID__c != null ? accRec.ExecutionLayerRequestID__c : '';
        string accNo = accRec.AccountNumber != null ? accRec.AccountNumber : '';
        string firstName = accRec.FirstName != null ? accRec.FirstName : '';
        string lastName = accRec.LastName != null ? accRec.LastName : '';
        string persEmail = accRec.PersonEmail != null ? accRec.PersonEmail : '';
        string persMobile = accRec.PersonMobilePhone != null ? accRec.PersonMobilePhone : '';
        /*
        ecpLeadReq = '{';
        ecpLeadReq = ecpLeadReq + '"updateAccount":{';
        ecpLeadReq = ecpLeadReq + '"activeAccount":{';
        ecpLeadReq = ecpLeadReq + '"ExecutionLayerRequestId":"' + execLayReqId + '",';
        ecpLeadReq = ecpLeadReq + '"AccountNo":"' + accNo + '",';
        ecpLeadReq = ecpLeadReq + '"LeadProductInterest":[';

        for (String lPInt : lProdInterest) {
            count = count + 1;
            ecpLeadReq = ecpLeadReq + '{';
            ecpLeadReq = ecpLeadReq + '"Prod' + count + '":' + '"' + leadPrdInterest + '"';
            ecpLeadReq = ecpLeadReq + '}';
        }

        ecpLeadReq = ecpLeadReq + '],';
        ecpLeadReq = ecpLeadReq + '"FirstName":"' + firstName + '",';
        ecpLeadReq = ecpLeadReq + '"LastName":"' + lastName + '",';
        ecpLeadReq = ecpLeadReq + '"Email":"' + persEmail + '",';
        ecpLeadReq = ecpLeadReq + '"Mobile":"' + persMobile + '",';
        ecpLeadReq = ecpLeadReq + '"AccountStatus":"' + accStatus + '",';

        if (accRec.Account_no_generated__c != null) {
            string dTForm = accRec.Account_no_generated__c.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
            ecpLeadReq = ecpLeadReq + '"AccountNoDateTime":"' + dTForm + '"';
        }
        ecpLeadReq = ecpLeadReq + '}';
        ecpLeadReq = ecpLeadReq + '}';
        ecpLeadReq = ecpLeadReq + '}';
        */
        ecpLeadReq = '{';   
        ecpLeadReq = ecpLeadReq+'"senderReference":"Absa",';    
        ecpLeadReq = ecpLeadReq+'"replyMessage":"",';   
        ecpLeadReq = ecpLeadReq+'"replyTime":"2021-03-09T17:07:28Z",';  
        ecpLeadReq = ecpLeadReq+'"nextTry":"2021-05-01T09:00:00Z",';    
        ecpLeadReq = ecpLeadReq+'"fromNumber":"'+persMobile+'",';   
        ecpLeadReq = ecpLeadReq+'"backupContactNumber":"'+persMobile+'",';  
        ecpLeadReq = ecpLeadReq+'"emailAddress":"'+persEmail+'",';  
        ecpLeadReq = ecpLeadReq+'"campaign":"Free Text",';  
        ecpLeadReq = ecpLeadReq+'"campaignType":"Free Text",';  
        ecpLeadReq = ecpLeadReq+'"firstName":"'+firstName+'",'; 
        ecpLeadReq = ecpLeadReq+'"lastName":"'+lastName+'",';   
        ecpLeadReq = ecpLeadReq+'"originalMsg":"Something the customer may have seen before",'; 
        ecpLeadReq = ecpLeadReq+'"packageId":"sim-sme"';    
        ecpLeadReq = ecpLeadReq+'}';
        
        if (!Test.isRunningTest()) {
            ecpLeadResBody = runCallout(ecpLeadReq, 'https://Absa330762.jitterbit.eu/rbservicesenvironmentprd/1.0/api/ecp/leads', 'PUT');
            ECPLeadResponse res = (ECPLeadResponse) JSON.deserialize(ecpLeadResBody, ECPLeadResponse.class);
        } else {
            ecpLeadResBody = runCallout(
                '{"updateAccount":{"activeAccount":{"ExecutionLayerRequestId":"12345678","AccountNo":"2456789632","LeadProductInterest":[{"Prod1":"Merchant Smartpay"},{"Prod2":"Protect your Employees"}],"FirstName":"firstnametest","DisplayName":"lastnametest","Email":"jitterbit5@email.com","Mobile":"829632356","AccountNoDateTime":"2021/05/07 9:28 AM"}}}',
                '',
                'PUT'
            );
        }
    }
}
/**
 * @description
 * @author jacobuschristiaan.delange@absa.africa | 2021-05-25
 * @param body
 * @param url
 * @param method
 * @return string
 **/
public static string runCallout(string body, string url, string method) {
    httpRequest req = new httpRequest();
    req.setEndpoint(url);
    req.setMethod(method);
    req.setHeader('content-type', 'application/json');
    req.setTimeout(60000);
    if (body != '')
        req.setBody(body);
    Http http = new Http();
    HttpResponse res = new HttpResponse();
    if (!Test.isRunningTest()) {
        try {
            res = http.send(req);
        } catch (Exception e) {
                 }
    }
    if (res.getBody() != null && res.getstatusCode() == 200) {
        return res.getBody();
    } else {
        return null;
    }
}
}