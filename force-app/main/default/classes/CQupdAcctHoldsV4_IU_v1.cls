public class CQupdAcctHoldsV4_IU_v1 {
    
    public static CQupdAcctHoldsV4_Req_IB_v1 mapRequestdFields(String accountNumberP,String blocked, String courtOrder, String mandateRequired,
                                             String dormant, String semiDormant, String confiscated, String externalTransfer,
                                             String staff, String creditAccount, String excludeFromEstate, String blockAdhocDbt,
                                             String blockAdhocCrd, String specialRqpRedirect, String commercialPropFin,
                                             String misHold, String genSecMsg, String wapWildAccPickup, 
                                             String exclFromInsolvent, String digitalHold, String odSwitchInd){
        
        CQupdAcctHoldsV4_Req_IB_v1 requestBean = new CQupdAcctHoldsV4_Req_IB_v1();

        List<User> currentUser = [SELECT Id,SiteCode__c, Teller_Operator_Code__c,Supervisor__c FROM USER WHERE Id =: Userinfo.getUserId() limit 1];
        CQupdAcctHoldsV4_Req_IB_v1.nbsapdpi nbsapdpiBean = new CQupdAcctHoldsV4_Req_IB_v1.nbsapdpi();
        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.trace = 'Y';
        
        CQupdAcctHoldsV4_Req_IB_v1.nbsmsgi nbsmsgiBean = new CQupdAcctHoldsV4_Req_IB_v1.nbsmsgi();
        nbsmsgiBean.msgLanguage = 'E';
        nbsmsgiBean.msgTarget = 'STD';
        
        CQupdAcctHoldsV4_Req_IB_v1.finalMsgId finalMsgIdbean = new CQupdAcctHoldsV4_Req_IB_v1.finalMsgId();
        finalMsgIdbean.finalMsgClass = '';
        finalMsgIdbean.finalMsgCode = '';
        
        CQupdAcctHoldsV4_Req_IB_v1.cqh525i cqh525iBean = new CQupdAcctHoldsV4_Req_IB_v1.cqh525i();
        cqh525iBean.accountNbr = accountNumberP;
        cqh525iBean.branchCode = currentUser[0].SiteCode__c;
        cqh525iBean.branchSiteType = '034';
        cqh525iBean.tellerCode = currentUser[0].Teller_Operator_Code__c;
        cqh525iBean.siteTypeAgency = '034';
        cqh525iBean.supervisorCode = currentUser[0].Supervisor__c;
        cqh525iBean.agencyCode = '034';
        cqh525iBean.corpCode = 'ABS';

        
        cqh525iBean.blocked = blocked;
        cqh525iBean.courtOrder = courtOrder;
        cqh525iBean.mandateRequired = mandateRequired;
        cqh525iBean.dormant = dormant;//'N';
        cqh525iBean.semiDormant = semiDormant;
        cqh525iBean.confiscated = confiscated;
        cqh525iBean.externalTransfer = externalTransfer;
        cqh525iBean.staff = staff;
        cqh525iBean.creditAccount = creditAccount;
        cqh525iBean.excludeFromEstate = excludeFromEstate;
        cqh525iBean.blockAdhocDbt = blockAdhocDbt ;
        cqh525iBean.blockAdhocCrd = blockAdhocCrd;
        cqh525iBean.specialRqpRedirect = specialRqpRedirect;
        cqh525iBean.commercialPropFin = commercialPropFin;
        cqh525iBean.misHold = misHold;
        cqh525iBean.genSecMsg = genSecMsg;
        cqh525iBean.genSecNum  = '0';//genSecNum;
        cqh525iBean.wapWildAccPickup = wapWildAccPickup;
        cqh525iBean.employeeNumber = '0';
        cqh525iBean.mandate = '0';
        cqh525iBean.exclFromInsolvent = exclFromInsolvent;
        cqh525iBean.digitalHold = digitalHold;
        cqh525iBean.odSwitchInd = odSwitchInd;
        cqh525iBean.rbaEdd = 'N';
        
        CQupdAcctHoldsV4_Req_IB_v1.CQupdAcctHoldsV4  cQupdAcctHoldsV4bean = new CQupdAcctHoldsV4_Req_IB_v1.CQupdAcctHoldsV4();
        cQupdAcctHoldsV4bean.nbsapdpi = nbsapdpiBean;
        cQupdAcctHoldsV4bean.nbsmsgi = nbsmsgiBean;
        cQupdAcctHoldsV4bean.cqh525i = cqh525iBean;
        
        requestBean.CQupdAcctHoldsV4 = cQupdAcctHoldsV4bean;
        return requestBean;
        
    }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: CQupdAcctHoldsV4_Resp_IB_v1 bean object
      * */
    
    public static CQupdAcctHoldsV4_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        CQupdAcctHoldsV4_Resp_IB_v1 responseBean = (CQupdAcctHoldsV4_Resp_IB_v1)JSON.deserialize( respP.getBody(), CQupdAcctHoldsV4_Resp_IB_v1.class);     
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        System.debug('Response bean: ' + responseBean);
        return responseBean;
    }
     /* Creates a custom bean with the parameters mapped to their respective fields (- for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param:  message
      * @return: CQupdAcctHoldsV4_Resp_IB_v1 bean object
      * */
    
     public static CQupdAcctHoldsV4_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        CQupdAcctHoldsV4_Resp_IB_v1 responseBean = new CQupdAcctHoldsV4_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        
        return responseBean;
    }


}