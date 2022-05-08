public class CQvalAcctHoldsV4_IU_v1 {

     public static CQvalAcctHoldsV4_Req_IB_v1 mapRequestdFields(String accountNumberP,String blocked, String courtOrder, String mandateRequired,
                                                               String dormant, String semiDormant, String confiscated, String externalTransfer,
                                                               String staff, String creditAccount, String excludeFromEstate, String blockAdhocDbt,
                                                               String blockAdhocCrd, String specialRqpRedirect, String commercialPropFin,
                                                               String misHold, String genSecMsg, String genSecNum, String wapWildAccPickup, 
                                                               String exclFromInsolvent, String digitalHold, String odSwitchInd){
         
         CQvalAcctHoldsV4_Req_IB_v1 requestBean = new CQvalAcctHoldsV4_Req_IB_v1();
         CQvalAcctHoldsV4_Req_IB_v1.nbsapdpi nbsapdpiBean = new CQvalAcctHoldsV4_Req_IB_v1.nbsapdpi();
         CQvalAcctHoldsV4_Req_IB_v1.nbsmsgi nbsmsgiBean = new CQvalAcctHoldsV4_Req_IB_v1.nbsmsgi();
         CQvalAcctHoldsV4_Req_IB_v1.finalMsgId finalMsgIdbean = new CQvalAcctHoldsV4_Req_IB_v1.finalMsgId();
         CQvalAcctHoldsV4_Req_IB_v1.cqh524i cqh524iBean = new CQvalAcctHoldsV4_Req_IB_v1.cqh524i();
         
         nbsapdpiBean.channel = 'BDP';
         nbsapdpiBean.application = 'BDP';
         nbsapdpiBean.trace = 'Y';
         
         nbsmsgiBean.msgLanguage = 'E';
         nbsmsgiBean.msgLanguage = 'STD';
         
         finalMsgIdbean.finalMsgClass = '';
         finalMsgIdbean.finalMsgCode = '';
         
        cqh524iBean.accountNbr = accountNumberP;
        cqh524iBean.blocked = blocked;
        cqh524iBean.courtOrder = courtOrder;
        cqh524iBean.mandateRequired = mandateRequired;
        cqh524iBean.dormant = dormant;
        cqh524iBean.semiDormant = semiDormant;
        cqh524iBean.confiscated = confiscated;
        cqh524iBean.externalTransfer = externalTransfer;
        cqh524iBean.staff = staff;
        cqh524iBean.creditAccount = creditAccount;
        cqh524iBean.excludeFromEstate = excludeFromEstate;
        cqh524iBean.blockAdhocDbt = blockAdhocDbt ;
        cqh524iBean.blockAdhocCrd = blockAdhocCrd;
        cqh524iBean.specialRqpRedirect = specialRqpRedirect;
        cqh524iBean.commercialPropFin = commercialPropFin;
        cqh524iBean.misHold = misHold;
        cqh524iBean.genSecMsg = genSecMsg;
        cqh524iBean.genSecNum  = genSecNum;
        cqh524iBean.wapWildAccPickup = wapWildAccPickup;
        cqh524iBean.employeeNumber = '0';
        cqh524iBean.mandate = '0';
        cqh524iBean.exclFromInsolvent = exclFromInsolvent;
        cqh524iBean.digitalHold = digitalHold;
        cqh524iBean.odSwitchInd = odSwitchInd;
        cqh524iBean.rbaEdd = 'N';

         CQvalAcctHoldsV4_Req_IB_v1.CQvalAcctHoldsV4 cQvalAcctHoldsV4bean = new CQvalAcctHoldsV4_Req_IB_v1.CQvalAcctHoldsV4();
         cQvalAcctHoldsV4bean.nbsapdpi = nbsapdpiBean;
         cQvalAcctHoldsV4bean.nbsmsgi = nbsmsgiBean;
         cQvalAcctHoldsV4bean.cqh524i = cqh524iBean;
         
         requestBean.CQvalAcctHoldsV4 = cQvalAcctHoldsV4bean;
         return requestBean;
         
     }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: CQvalAcctHoldsV4_Resp_IB_v1 bean object
      * */
    
    public static CQvalAcctHoldsV4_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        CQvalAcctHoldsV4_Resp_IB_v1 responseBean = (CQvalAcctHoldsV4_Resp_IB_v1)JSON.deserialize( respP.getBody(), CQvalAcctHoldsV4_Resp_IB_v1.class);     
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        System.debug('Response bean: ' + responseBean);
        return responseBean;
    }
     /* Creates a custom bean with the parameters mapped to their respective fields (- for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param:  message
      * @return: CQvalAcctHoldsV4_Resp_IB_v1 bean object
      * */
    
     public static CQvalAcctHoldsV4_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        CQvalAcctHoldsV4_Resp_IB_v1 responseBean = new CQvalAcctHoldsV4_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        
        return responseBean;
    }

}