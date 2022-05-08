public class SVgetAccountHoldsDetailV4_IU_v1 {
    
    public static SVgetAccountHoldsDetailV4_Req_IB_v1 mapRequestdFields(String accountNo,String teller, String siteCode, String supervisorCode){
        
        SVgetAccountHoldsDetailV4_Req_IB_v1 requestBean = new SVgetAccountHoldsDetailV4_Req_IB_v1();
        SVgetAccountHoldsDetailV4_Req_IB_v1.nbsapdpi nbsapdpiBean = new SVgetAccountHoldsDetailV4_Req_IB_v1.nbsapdpi();
        SVgetAccountHoldsDetailV4_Req_IB_v1.nbsmsgi nbsmsgiBean = new SVgetAccountHoldsDetailV4_Req_IB_v1.nbsmsgi();
        SVgetAccountHoldsDetailV4_Req_IB_v1.finalMsgId finalMsgIdbean = new SVgetAccountHoldsDetailV4_Req_IB_v1.finalMsgId();
        SVgetAccountHoldsDetailV4_Req_IB_v1.svsp40i svsp40iBean = new SVgetAccountHoldsDetailV4_Req_IB_v1.svsp40i();
   
        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.trace = 'Y';
        
        nbsmsgiBean.msgLanguage = 'E';
        nbsmsgiBean.msgTarget = 'STD';
        
        finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        
        svsp40iBean.accountNbr = accountNo;
        svsp40iBean.savingsDepositType = 'S';
        svsp40iBean.chargeInd = 'N';
        svsp40iBean.divisionCode = 'B';
        svsp40iBean.workStation = '99';
        svsp40iBean.branchCode = siteCode;
        svsp40iBean.agencyCode = '034';
        svsp40iBean.agencySiteType = '034';
        svsp40iBean.tellerCode = teller;
        svsp40iBean.supervisorCode = supervisorCode;
        svsp40iBean.branchSiteType = '034';
        
        SVgetAccountHoldsDetailV4_Req_IB_v1.SVgetAccountHoldsDetailV4 sVgetAccountHoldsDetailV4bean = new SVgetAccountHoldsDetailV4_Req_IB_v1.SVgetAccountHoldsDetailV4();
        sVgetAccountHoldsDetailV4bean.nbsapdpi = nbsapdpiBean;
        sVgetAccountHoldsDetailV4bean.nbsmsgi = nbsmsgiBean;
        sVgetAccountHoldsDetailV4bean.svsp40i = svsp40iBean;
        
        requestBean.SVgetAccountHoldsDetailV4 = sVgetAccountHoldsDetailV4bean;
        
        return requestBean;

     }
    
    
        /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: SVgetAccountHoldsDetailV4_Resp_IB_v1 bean object
      * */
    
    public static SVgetAccountHoldsDetailV4_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        
    
            SVgetAccountHoldsDetailV4_Resp_IB_v1 responseBean = new SVgetAccountHoldsDetailV4_Resp_IB_v1();
            responseBean = (SVgetAccountHoldsDetailV4_Resp_IB_v1)JSON.deserialize( respP.getBody(), SVgetAccountHoldsDetailV4_Resp_IB_v1.class);
            responseBean.status =  respP.getStatus();
            responseBean.statusCode =respP.getStatusCode();
            System.debug('Create Response bean: ' + responseBean);

        return responseBean;
    }
    
     /* Creates a custom bean with the parameters mapped to their respective fields (- for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param:  message
      * @return: SVgetAccountHoldsDetailV4_Resp_IB_v1 bean object
      * */
    
     public static SVgetAccountHoldsDetailV4_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP,String statusP,String messageP){
        SVgetAccountHoldsDetailV4_Resp_IB_v1 responseBean = new SVgetAccountHoldsDetailV4_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        
        return responseBean;
    }
}