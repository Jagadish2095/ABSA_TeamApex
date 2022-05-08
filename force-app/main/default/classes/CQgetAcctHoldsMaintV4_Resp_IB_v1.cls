public class CQgetAcctHoldsMaintV4_Resp_IB_v1 {
    
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    @AuraEnabled public CQgetAcctHoldsMaintV4Response CQgetAcctHoldsMaintV4Response{get;set;}
    
    public class CQgetAcctHoldsMaintV4Response{
        @AuraEnabled public nbsapdpo nbsapdpo{get;set;}
        @AuraEnabled public nbsmsgo3 nbsmsgo3{get;set;}
        @AuraEnabled public cqh503o cqh503o{get;set;}
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
        @AuraEnabled public msgEntry msgEntry{get;set;}
        
    }
    
    public class msgEntry{
        @AuraEnabled public String msgClass;
        @AuraEnabled public String msgCode;
        @AuraEnabled public String msgErrInd;
        @AuraEnabled public String msgTxt;
    }
    
    public class cqh503o{
        @AuraEnabled public String accountNbrOut;
        @AuraEnabled public String clientName;
        @AuraEnabled public String blocked;
        @AuraEnabled public String courtOrder;
        @AuraEnabled public String mandateRequired;
        @AuraEnabled public String dormant;
        @AuraEnabled public String semiDormant;
        @AuraEnabled public String confiscated;
        @AuraEnabled public String externalTransfer;
        @AuraEnabled public String staffA;
        @AuraEnabled public String staff;
        @AuraEnabled public String creditAccount;
        @AuraEnabled public String excludeFromEstate;
        @AuraEnabled public String excludeFromEstateA;
        @AuraEnabled public String blockAdhocDbt;
        @AuraEnabled public String blockAdhocDbtA;
        @AuraEnabled public String blockAdhocCrd;
        @AuraEnabled public String blockAdhocCrdA;
        @AuraEnabled public String specialRqpRedirect;
        @AuraEnabled public String commercialPropFin;
        @AuraEnabled public String misHold;
        @AuraEnabled public String genSecMsg;
        @AuraEnabled public String genSecMsgA;
        @AuraEnabled public String genSecNum;
        @AuraEnabled public String genSecNumA;
        @AuraEnabled public String wapWildAccPickup;
        @AuraEnabled public String exclFromInsolvent;
        @AuraEnabled public String exclFromInsolventA;
        @AuraEnabled public String digitalHold;
        @AuraEnabled public String digitalHoldA;
        @AuraEnabled public String odSwitchInd;
        @AuraEnabled public String odSwitchIndA;
    }
    
    public static CQgetAcctHoldsMaintV4_Resp_IB_v1 dummyResponse(){
        CQgetAcctHoldsMaintV4_Resp_IB_v1 responseBean = new CQgetAcctHoldsMaintV4_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        
        CQgetAcctHoldsMaintV4_Resp_IB_v1.nbsapdpo nbsapdpo = new CQgetAcctHoldsMaintV4_Resp_IB_v1.nbsapdpo();
        nbsapdpo.reasonCode = '0';
        nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO003';
        
        CQgetAcctHoldsMaintV4_Resp_IB_v1.nbsmsgo3 nbsmsgo3 = new CQgetAcctHoldsMaintV4_Resp_IB_v1.nbsmsgo3();
        nbsmsgo3.version = 'MSG3001';
        nbsmsgo3.nbrUserErrs = '0';
        nbsmsgo3.nbrUserMsgs = '0';
        
        CQgetAcctHoldsMaintV4_Resp_IB_v1.msgEntry msgEntry = new CQgetAcctHoldsMaintV4_Resp_IB_v1.msgEntry();
        msgEntry.msgClass = null;
        msgEntry.msgCode = null;
        msgEntry.msgErrInd = null;
        msgEntry.msgTxt = null;
        
        CQgetAcctHoldsMaintV4_Resp_IB_v1.cqh503o cqh503o = new CQgetAcctHoldsMaintV4_Resp_IB_v1.cqh503o();
        cqh503o.accountNbrOut =  '-246949655' ;
        cqh503o.clientName =  'MR D ZUMA' ;
        cqh503o.blocked =  'N' ;
        cqh503o.courtOrder =  'N' ;
        cqh503o.mandateRequired =  'N' ;
        cqh503o.dormant =  'N' ;
        cqh503o.semiDormant =  'N' ;
        cqh503o.confiscated =  'N' ;
        cqh503o.externalTransfer =  'N' ;
        cqh503o.staffA =  'N' ;
        cqh503o.staff =  'N' ;
        cqh503o.creditAccount =  'N' ;
        cqh503o.excludeFromEstate =  'N' ;
        cqh503o.excludeFromEstateA =  'Y' ;
        cqh503o.blockAdhocDbt =  'N' ;
        cqh503o.blockAdhocDbtA =  'Y' ;
        cqh503o.blockAdhocCrd =  'N' ;
        cqh503o.blockAdhocCrdA =  'Y' ;
        cqh503o.specialRqpRedirect =  'N' ;
        cqh503o.commercialPropFin =  'N' ;
        cqh503o.misHold =  'N' ;
        cqh503o.genSecMsg =  'N' ;
        cqh503o.genSecMsgA =  'Y' ;
        cqh503o.genSecNum =  '0' ;
        cqh503o.genSecNumA =  'Y' ;
        cqh503o.wapWildAccPickup =  'N' ;
        cqh503o.exclFromInsolvent =  'N' ;
        cqh503o.exclFromInsolventA =  'Y' ;
        cqh503o.digitalHold =  'N' ;
        cqh503o.digitalHoldA =  'Y' ;
        cqh503o.odSwitchInd =  'N' ;
        cqh503o.odSwitchIndA =  'Y'; 
        
        CQgetAcctHoldsMaintV4_Resp_IB_v1.CQgetAcctHoldsMaintV4Response  respBean = new CQgetAcctHoldsMaintV4_Resp_IB_v1.CQgetAcctHoldsMaintV4Response();
        respBean.cqh503o = cqh503o;
        respBean.nbsapdpo = nbsapdpo;
        respBean.nbsmsgo3 = nbsmsgo3;

        
        return responseBean;
    }

}