public class CQgetAcctHoldsMaintV4_IU_v1 {
    
    public static CQgetAcctHoldsMaintV4_Req_IB_v1 mapRequestdFields(String accountNumber){
        List<User> currentUser = [SELECT Id,SiteCode__c, Teller_Operator_Code__c,Supervisor__c FROM USER WHERE Id =: Userinfo.getUserId() limit 1];
        CQgetAcctHoldsMaintV4_Req_IB_v1 requestBean = new CQgetAcctHoldsMaintV4_Req_IB_v1();
        CQgetAcctHoldsMaintV4_Req_IB_v1.nbsapdpi nbsapdpiBean = new CQgetAcctHoldsMaintV4_Req_IB_v1.nbsapdpi();
        CQgetAcctHoldsMaintV4_Req_IB_v1.nbsmsgi nbsmsgiBean = new CQgetAcctHoldsMaintV4_Req_IB_v1.nbsmsgi();
        CQgetAcctHoldsMaintV4_Req_IB_v1.cqh503i cqh503iBean = new CQgetAcctHoldsMaintV4_Req_IB_v1.cqh503i();
        CQgetAcctHoldsMaintV4_Req_IB_v1.finalMsgId finalMsgIdbean = new CQgetAcctHoldsMaintV4_Req_IB_v1.finalMsgId();
        
        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.trace = 'Y';
        
        nbsmsgiBean.msgLanguage = 'E';
        nbsmsgiBean.msgLanguage = 'STD';
        
        finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        
        cqh503iBean.accountNbr = accountNumber;//'4048017641';
        cqh503iBean.branchCode = currentUser[0].SiteCode__c;
        cqh503iBean.branchSiteType = '034';
        cqh503iBean.tellerCode = currentUser[0].Teller_Operator_Code__c;
        cqh503iBean.siteTypeAgency = '034';
        cqh503iBean.supervisorCode = currentUser[0].Supervisor__c;
        cqh503iBean.agencyCode = '034';
        cqh503iBean.corpCode = 'ABS';
        
        CQgetAcctHoldsMaintV4_Req_IB_v1.CQgetAcctHoldsMaintV4 CQgetAcctHoldsMaintV4bean  = new CQgetAcctHoldsMaintV4_Req_IB_v1.CQgetAcctHoldsMaintV4();
        CQgetAcctHoldsMaintV4bean.nbsapdpi = nbsapdpiBean;
        CQgetAcctHoldsMaintV4bean.nbsmsgi = nbsmsgiBean;
        CQgetAcctHoldsMaintV4bean.cqh503i = cqh503iBean;
        
        requestBean.CQgetAcctHoldsMaintV4 = CQgetAcctHoldsMaintV4bean;
        return requestBean;
    }
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: CQgetAcctHoldsMaintV4_Resp_IB_v1 bean object
      * */
    
    public static CQgetAcctHoldsMaintV4_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        CQgetAcctHoldsMaintV4_Resp_IB_v1 responseBean = (CQgetAcctHoldsMaintV4_Resp_IB_v1)JSON.deserialize( respP.getBody(), CQgetAcctHoldsMaintV4_Resp_IB_v1.class);     
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        System.debug('Response bean: ' + responseBean);
        return responseBean;
    }
     /* Creates a custom bean with the parameters mapped to their respective fields (- for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param:  message
      * @return: CQgetAcctHoldsMaintV4_Resp_IB_v1 bean object
      * */
    
     public static CQgetAcctHoldsMaintV4_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        CQgetAcctHoldsMaintV4_Resp_IB_v1 responseBean = new CQgetAcctHoldsMaintV4_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        
        return responseBean;
    }

}