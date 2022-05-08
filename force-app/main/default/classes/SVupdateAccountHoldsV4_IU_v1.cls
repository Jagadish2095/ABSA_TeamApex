public class SVupdateAccountHoldsV4_IU_v1 {
    
    public static SVupdateAccountHoldsV4_Req_IB_v1 mapRequestdFields(String accountNumberP,String frozenInd, String stoppedInd, String dormantInd,
                                             String semiDormantInd, String exclEstateInd, String exclInslvntInd, String courtOrderInd,
                                             String signingAuthInd, String monitorActivityInd, String potBadDebtInd,
                                             String legalActionInd, String nonResidentInd, String lostBookInd,
                                             String blockedInd, String offlineEnqInd, String securityMessageInd, 
                                              String restricHoldInd,String exceedMaxBalInd, String wtiCountry,String rbaEddHold, String siteCode, String teller, String supervisor){
        
        SVupdateAccountHoldsV4_Req_IB_v1 requestBean = new SVupdateAccountHoldsV4_Req_IB_v1();
        SVupdateAccountHoldsV4_Req_IB_v1.nbsapdpi nbsapdpiBean = new SVupdateAccountHoldsV4_Req_IB_v1.nbsapdpi();
        SVupdateAccountHoldsV4_Req_IB_v1.nbsmsgi nbsmsgiBean = new SVupdateAccountHoldsV4_Req_IB_v1.nbsmsgi();
        SVupdateAccountHoldsV4_Req_IB_v1.svsp42i svsp42iBean = new SVupdateAccountHoldsV4_Req_IB_v1.svsp42i();
                                                     
        nbsapdpiBean.channel = 'BDP';
        nbsapdpiBean.application = 'BDP';
        nbsapdpiBean.trace = 'Y';
        
        nbsmsgiBean.msgLanguage = 'E';
        nbsmsgiBean.msgTarget = 'STD';
        
        svsp42iBean.accountNbr = accountNumberP;
        svsp42iBean.savingsDepositType = 'S';
        svsp42iBean.chargeInd = 'N';
        
        svsp42iBean.frozenInd = frozenInd;
        svsp42iBean.stoppedInd = stoppedInd;
        svsp42iBean.dormantInd = dormantInd;
        svsp42iBean.semiDormantInd = semiDormantInd;
        svsp42iBean.exclEstateInd = exclEstateInd ;
        svsp42iBean.exclInslvntInd = exclInslvntInd;
        svsp42iBean.courtOrderInd = courtOrderInd;
        svsp42iBean.signingAuthInd = signingAuthInd;
        svsp42iBean.monitorActivityInd = monitorActivityInd;
        svsp42iBean.badDebtInd = 'N';//badDebtInd ;
        svsp42iBean.potBadDebtInd = potBadDebtInd;
        svsp42iBean.legalActionInd = legalActionInd;
        svsp42iBean.nonResidentInd = nonResidentInd;
        svsp42iBean.lostBookInd = lostBookInd;
        svsp42iBean.blockedInd = blockedInd;
        svsp42iBean.offlineEnqInd = offlineEnqInd;
        svsp42iBean.offlEnqFrDt = '0';//offlEnqFrDt;
        svsp42iBean.securityMessageInd = securityMessageInd;
        svsp42iBean.securityNumber = '0';//securityNumber;
        svsp42iBean.exceedMaxBalInd = exceedMaxBalInd;
        svsp42iBean.restricHoldInd = restricHoldInd;
        svsp42iBean.wtiCountry = wtiCountry;
        svsp42iBean.rbaEddHold = rbaEddHold;
        svsp42iBean.divisionCode = 'B';
        svsp42iBean.workStation = '99';
        svsp42iBean.branchCode = siteCode;
        svsp42iBean.agencyCode = '034';
        svsp42iBean.agencySiteType = '034';
        svsp42iBean.tellerCode = teller;
        svsp42iBean.supervisorCode = supervisor; 
        svsp42iBean.branchSiteType = '034';
        
        SVupdateAccountHoldsV4_Req_IB_v1.SVupdateAccountHoldsV4 sVupdateAccountHoldsV4bean = new SVupdateAccountHoldsV4_Req_IB_v1.SVupdateAccountHoldsV4();
        sVupdateAccountHoldsV4bean.nbsapdpi = nbsapdpiBean;
        sVupdateAccountHoldsV4bean.nbsmsgi = nbsmsgiBean;
        sVupdateAccountHoldsV4bean.svsp42i = svsp42iBean;
        
        requestBean.SVupdateAccountHoldsV4 = sVupdateAccountHoldsV4bean;
        return requestBean;
        
    }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: CQupdAcctHoldsV4_Resp_IB_v1 bean object
      * */
    
    public static SVupdateAccountHoldsV4_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        SVupdateAccountHoldsV4_Resp_IB_v1 responseBean = (SVupdateAccountHoldsV4_Resp_IB_v1)JSON.deserialize( respP.getBody(), SVupdateAccountHoldsV4_Resp_IB_v1.class);     
        responseBean.Status = respP.getStatus();
        responseBean.statusCode = respP.getStatusCode();
        System.debug('Response bean: ' + responseBean);
        return responseBean;
    }
     /* Creates a custom bean with the parameters mapped to their respective fields (- for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param:  message
      * @return: SVupdateAccountHoldsV4_Resp_IB_v1 bean object
      * */
    
     public static SVupdateAccountHoldsV4_Resp_IB_v1 mapFailedResponseFields(String statusP, Integer statusCodeP, String messageP){
        SVupdateAccountHoldsV4_Resp_IB_v1 responseBean = new SVupdateAccountHoldsV4_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        
        return responseBean;
    }

}