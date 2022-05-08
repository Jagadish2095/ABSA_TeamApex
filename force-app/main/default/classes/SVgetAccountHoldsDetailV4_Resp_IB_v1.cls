public class SVgetAccountHoldsDetailV4_Resp_IB_v1 extends Base_IB {
    
    @auraEnabled public String status;
    @auraEnabled public Integer statusCode;
    @auraEnabled public String message;
    @AuraEnabled public SVgetAccountHoldsDetailV4Response SVgetAccountHoldsDetailV4Response{get;set;}
    
    public class SVgetAccountHoldsDetailV4Response{
        @AuraEnabled public nbsapdpo nbsapdpo{get;set;}
        @AuraEnabled public nbsmsgo3 nbsmsgo3{get;set;}
        @AuraEnabled public svsp40o svsp40o{get;set;}
            
    }
    
    public class nbsapdpo{
        @AuraEnabled public String returnCode;
        @AuraEnabled public String reasonCode;
        @AuraEnabled public String serviceVersion;
        
    }
    
    public class nbsmsgo3{
        @AuraEnabled public String version;
        @AuraEnabled public String nbrUserMsgs;
        @AuraEnabled public String nbrUserErrs;
        @AuraEnabled public  msgEntry msgEntry;
        
    }
    
    public class msgEntry{
        @AuraEnabled public String msgClass;
        @AuraEnabled public String msgCode;
        @AuraEnabled public String msgErrInd;
        @AuraEnabled public String msgTxt;
    }
    
    public class svsp40o{
        
        @AuraEnabled public String frozenInd;
        @AuraEnabled public String frozenPrt;
        @AuraEnabled public String stoppedInd;
        @AuraEnabled public String stoppedPrt;
        @AuraEnabled public String dormantInd;
        @AuraEnabled public String dormantPrt;
        @AuraEnabled public String semiDormantInd;
        @AuraEnabled public String semiDormantPrt;
        @AuraEnabled public String exclEstateInd;
        @AuraEnabled public String exclEstatePrt;
        @AuraEnabled public String exclInslvntInd;
        @AuraEnabled public String exclInslvntPrt;
        @AuraEnabled public String courtOrderInd;
        @AuraEnabled public String courtOrderPrt;
        @AuraEnabled public String signingAuthInd;
        @AuraEnabled public String signingAuthPrt;
        @AuraEnabled public String monitorActivityInd;
        @AuraEnabled public String monitorActivityPrt;
        @AuraEnabled public String badDebtInd;
        @AuraEnabled public String badDebtPrt;
        @AuraEnabled public String potBadDebtInd;
        @AuraEnabled public String potBadDebtPrt;
        @AuraEnabled public String legalActionInd;
        @AuraEnabled public String legalActionPrt;
        @AuraEnabled public String nonResidentInd;
        @AuraEnabled public String nonResidentPrt;
        @AuraEnabled public String lostBookInd;
        @AuraEnabled public String lostBookPrt;
        @AuraEnabled public String blockedInd;
        @AuraEnabled public String blockedPrt;
        @AuraEnabled public String offlineEnqInd;
        @AuraEnabled public String offlineEnqPrt;
        @AuraEnabled public String offlEnqFrDate;
        @AuraEnabled public String offlEnqFrDtPrt;
        @AuraEnabled public String securityMessageInd;
        @AuraEnabled public String securityMessagePrt;
        @AuraEnabled public String securityNbr;
        @AuraEnabled public String securityNbrPrt;
        @AuraEnabled public String exceedMaxBalInd;
        @AuraEnabled public String exceedMaxBalPrt;
        @AuraEnabled public String restricHoldInd;
        @AuraEnabled public String restricHoldPrt;
        @AuraEnabled public String wtiCountry;
        @AuraEnabled public String wtiCountryPrt;
        @AuraEnabled public String rbaEddHold;
        @AuraEnabled public String rbaEddHoldPrt;
    }
    
    public static SVgetAccountHoldsDetailV4_Resp_IB_v1 dummyResponse(){
    SVgetAccountHoldsDetailV4_Resp_IB_v1 responseBean = new SVgetAccountHoldsDetailV4_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        
        SVgetAccountHoldsDetailV4_Resp_IB_v1.nbsapdpo nbsapdpo = new SVgetAccountHoldsDetailV4_Resp_IB_v1.nbsapdpo();
        nbsapdpo.reasonCode = '0';
        nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO003';
        
        SVgetAccountHoldsDetailV4_Resp_IB_v1.nbsmsgo3 nbsmsgo3 = new SVgetAccountHoldsDetailV4_Resp_IB_v1.nbsmsgo3();
        nbsmsgo3.version = 'MSG3001';
        nbsmsgo3.nbrUserErrs = '0';
        nbsmsgo3.nbrUserMsgs = '0';
        
        SVgetAccountHoldsDetailV4_Resp_IB_v1.msgEntry msgEntry = new SVgetAccountHoldsDetailV4_Resp_IB_v1.msgEntry();
        msgEntry.msgClass = null;
        msgEntry.msgCode = null;
        msgEntry.msgErrInd = null;
        msgEntry.msgTxt = null;
        
        SVgetAccountHoldsDetailV4_Resp_IB_v1.svsp40o svsp40o = new SVgetAccountHoldsDetailV4_Resp_IB_v1.svsp40o();
              svsp40o.frozenInd  = 'N';
              svsp40o.frozenPrt  = 'N';
              svsp40o.stoppedInd  = 'N';
              svsp40o.stoppedPrt  = 'N';
              svsp40o.dormantInd  = 'N';
              svsp40o.dormantPrt = 'N';
              svsp40o.semiDormantInd = 'N';
              svsp40o.semiDormantPrt = 'Y';
              svsp40o.exclEstateInd = 'N';
              svsp40o.exclEstatePrt = 'N';
              svsp40o.exclInslvntInd ='N';
              svsp40o.exclInslvntPrt = 'N';
              svsp40o.courtOrderInd = 'N';
              svsp40o.courtOrderPrt = 'N';
              svsp40o.signingAuthInd = 'N' ;
              svsp40o.signingAuthPrt = 'N' ;
              svsp40o.monitorActivityInd = 'N';
              svsp40o.monitorActivityPrt = 'N' ;
              svsp40o.badDebtInd = 'N';
              svsp40o.badDebtPrt = 'N' ;
              svsp40o.potBadDebtInd = 'N' ;
              svsp40o.potBadDebtPrt = 'N' ;
              svsp40o.legalActionInd = 'N';
              svsp40o.legalActionPrt = 'N';
              svsp40o.nonResidentInd = 'N' ;
              svsp40o.nonResidentPrt = 'N' ;
              svsp40o.lostBookInd = 'N' ;
              svsp40o.lostBookPrt = 'Y' ;
              svsp40o.blockedInd = 'N';
              svsp40o.blockedPrt = 'N' ;
              svsp40o.offlineEnqInd = 'N' ;
              svsp40o.offlineEnqPrt = 'N' ;
              svsp40o.offlEnqFrDate = '0' ;
              svsp40o.offlEnqFrDtPrt = 'N' ;
              svsp40o.securityMessageInd = 'N' ;
              svsp40o.securityMessagePrt = 'N' ;
              svsp40o.securityNbr = '0';
              svsp40o.securityNbrPrt = 'N' ;
              svsp40o.exceedMaxBalInd  = 'N' ;
              svsp40o.exceedMaxBalPrt = 'N' ;
              svsp40o.restricHoldInd = 'N' ;
              svsp40o.restricHoldPrt = 'Y' ;
              svsp40o.wtiCountry  = null ;
              svsp40o.wtiCountryPrt = 'Y' ;
              svsp40o.rbaEddHold = 'N' ;
              svsp40o.rbaEddHoldPrt = 'Y';  
             
         SVgetAccountHoldsDetailV4_Resp_IB_v1.SVgetAccountHoldsDetailV4Response SVgetAccountHoldsV4bean = new SVgetAccountHoldsDetailV4_Resp_IB_v1.SVgetAccountHoldsDetailV4Response();
         SVgetAccountHoldsV4bean.nbsapdpo = nbsapdpo;
         SVgetAccountHoldsV4bean.nbsmsgo3 = nbsmsgo3;
         SVgetAccountHoldsV4bean.svsp40o = svsp40o;
        
        responseBean.SVgetAccountHoldsDetailV4Response = SVgetAccountHoldsV4bean;
        
        return responseBean;
    }

}