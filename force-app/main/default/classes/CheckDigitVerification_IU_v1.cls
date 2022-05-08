public class CheckDigitVerification_IU_v1 {
    
    public static CheckDigitVerification_Req_IB_v1 mapRequestFields(String accountNumberP, String branchCodeP, String accountTypeP, String transactionTypeP, String cdvRequiredP, String expiryDateP, String channelP, String applicationP, String msgLanguageP, String msgTargetP, String traceP){
        
        CheckDigitVerification_Req_IB_v1 requestBean = new CheckDigitVerification_Req_IB_v1();
        requestBean.accountNumber = accountNumberP;
        requestBean.branchCode = branchCodeP;
        requestBean.accountType = accountTypeP;
        requestBean.transactionType = transactionTypeP;
        requestBean.cdvRequired = cdvRequiredP;
        requestBean.expiryDate = expiryDateP;
        requestBean.channel = channelP;
        requestBean.application = applicationP;
        requestBean.msgLanguage = msgLanguageP;
        requestBean.msgTarget = msgTargetP;
        requestBean.trace = traceP;
        
        System.debug('Check Digit Verification Request bean: ' + requestBean);
        return requestBean;
    }
    
    public static CheckDigitVerification_Resp_IB_v1 mapResponseFields(HttpResponse responseP){
        
        CheckDigitVerification_Resp_IB_v1 responseBean = (CheckDigitVerification_Resp_IB_v1)JSON.deserialize( responseP.getBody(), CheckDigitVerification_Resp_IB_v1.class );
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        
        System.debug('Check Digit Verification Response bean: ' + responseBean);
        return responseBean;
    }
    
    public static CheckDigitVerification_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        
        CheckDigitVerification_Resp_IB_v1 responseBean = new CheckDigitVerification_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        System.debug('Check Digit Verification Failed Response bean: ' + responseBean);
        return responseBean;
    }
    
}