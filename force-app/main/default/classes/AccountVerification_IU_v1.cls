/*
* Integration Utilites for Verify Account Details
* @author Danie Booysen
* @created 2019-01-21
*/

public class AccountVerification_IU_v1 {
    
    public static AccountVerification_Req_IB_v1 mapRequestFields(String accountNumberP, String branchCodeP, Account accountP, String bankTranslatedP, String accTypeTranslatedP, String avsruserP, String channelP, String applicationP){
        
        AccountVerification_Req_IB_v1 requestBean = new AccountVerification_Req_IB_v1();
        requestBean.channel = channelP;
        requestBean.application = applicationP;
        requestBean.trace = 'N';//Constant
        requestBean.avsruser = avsruserP;
        requestBean.reqDate = System.now().format('yyyyMMdd');//current date
        requestBean.reqTime = System.now().format('hhmmssss');//current time
        //requestBean.reqConfirm = '';
        requestBean.receiveBank = bankTranslatedP;
        requestBean.receiveBranch = branchCodeP;
        requestBean.receiveAccno = accountNumberP;
        requestBean.accType = accTypeTranslatedP;
        requestBean.idno = accountP.ID_Number__pc ;
        requestBean.initials = accountP.Initials__pc;
        requestBean.name = accountP.LastName;
        requestBean.accDebits = 'Y';
        requestBean.accCredits = 'N';
        requestBean.accLength = 'N';
        //requestBean.emailAddress = ''; //accountP.PersonEmail
        //requestBean.cellNo = ''; //accountP.PersonMobilePhone
        
        return requestBean;
    }
    
    public static AccountVerification_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
        AccountVerification_Resp_IB_v1 responseBean = (AccountVerification_Resp_IB_v1)JSON.deserialize( respP.getBody(), AccountVerification_Resp_IB_v1.class);
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        
        System.debug('AVS Response' + responseBean);
        return responseBean;
    }
    
    public static AccountVerification_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        
        AccountVerification_Resp_IB_v1 responseBean = new AccountVerification_Resp_IB_v1();
        responseBean.Status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        System.debug('AVS Failed Response' + responseBean);
        return responseBean;
    }
}