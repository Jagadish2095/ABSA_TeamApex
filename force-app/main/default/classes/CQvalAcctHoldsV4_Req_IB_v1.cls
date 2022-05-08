public class CQvalAcctHoldsV4_Req_IB_v1 {
    
    public CQvalAcctHoldsV4 CQvalAcctHoldsV4{get;set;}
    
    public class CQvalAcctHoldsV4{
        public nbsapdpi nbsapdpi{get;set;}
        public nbsmsgi nbsmsgi{get;set;}
        public cqh524i cqh524i{get;set;}
        
    }
    
    public class nbsapdpi{
        public String channel;
        public String application;
        public String trace;
    }
    
    public class nbsmsgi{
        public String msgTarget{get;set;}
        public String msgLanguage{get;set;}
        public finalMsgId finalMsgId{get;set;}
    }
    
    public class finalMsgId{
        public String finalMsgClass{get;set;}
        public String finalMsgCode{get;set;}
    }
    
    public class cqh524i{
        public String accountNbr;
        public String branchCode;
        public String branchSiteType;
        public String tellerCode;
        public String siteTypeAgency;
        public String supervisorCode;
        public String agencyCode;
        public String corpCode;
        public String blocked;
        public String courtOrder;
        public String mandateRequired;
        public String dormant;
        public String semiDormant;
        public String confiscated;
        public String externalTransfer;
        public String staff;
        public String creditAccount;
        public String excludeFromEstate;
        public String blockAdhocDbt;
        public String blockAdhocCrd;
        public String specialRqpRedirect;
        public String commercialPropFin;
        public String misHold;
        public String genSecMsg;
        public String genSecNum;
        public String wapWildAccPickup;
        public String employeeNumber;
        public String mandate;
        public String exclFromInsolvent;
        public String digitalHold;
        public String odSwitchInd;
        public String rbaEdd;
    }
    
    public CQvalAcctHoldsV4_Req_IB_v1 createDummy(){
        CQvalAcctHoldsV4_Req_IB_v1 requestBean = new CQvalAcctHoldsV4_Req_IB_v1();
        CQvalAcctHoldsV4_Req_IB_v1.nbsapdpi nbsapdpiRequest = new CQvalAcctHoldsV4_Req_IB_v1.nbsapdpi ();
        CQvalAcctHoldsV4_Req_IB_v1.nbsmsgi nbsmsgiRequest = new CQvalAcctHoldsV4_Req_IB_v1.nbsmsgi ();
        CQvalAcctHoldsV4_Req_IB_v1.finalMsgId finalMsgIdRequest = new CQvalAcctHoldsV4_Req_IB_v1.finalMsgId();
        CQvalAcctHoldsV4_Req_IB_v1.cqh524i cqh524iRequest = new CQvalAcctHoldsV4_Req_IB_v1.cqh524i ();
        
        
        nbsapdpiRequest.application = 'BDP';
        nbsapdpiRequest.channel = 'BDP';
        nbsapdpiRequest.trace = 'Y';
        
        nbsmsgiRequest.msgLanguage = 'E';
        nbsmsgiRequest.msgTarget = 'STD';
        
        finalMsgIdRequest.finalMsgClass = '';
        finalMsgIdRequest.finalMsgCode = '';
        
        cqh524iRequest.accountNbr =  '4048017641'  ;
        cqh524iRequest.branchCode =  '8089'  ;
        cqh524iRequest.branchSiteType =  '034'  ;
        cqh524iRequest.tellerCode =  '25698'  ;
        cqh524iRequest.siteTypeAgency =  '034'  ;
        cqh524iRequest.supervisorCode =  '25698'  ;
        cqh524iRequest.agencyCode =  '8198'  ;
        cqh524iRequest.corpCode =  'ABS'  ;
        cqh524iRequest.blocked =  'N'  ;
        cqh524iRequest.courtOrder =  'Y'  ;
        cqh524iRequest.mandateRequired =  'N'  ;
        cqh524iRequest.dormant =  'N'  ;
        cqh524iRequest.semiDormant =  'N'  ;
        cqh524iRequest.confiscated =  'N'  ;
        cqh524iRequest.externalTransfer =  'Y'  ;
        cqh524iRequest.staff =  'N'  ;
        cqh524iRequest.creditAccount =  'N'  ;
        cqh524iRequest.excludeFromEstate =  'N'  ;
        cqh524iRequest.blockAdhocDbt =  'N'  ;
        cqh524iRequest.blockAdhocCrd =  'N'  ;
        cqh524iRequest.specialRqpRedirect =  'N'  ;
        cqh524iRequest.commercialPropFin =  'N'  ;
        cqh524iRequest.misHold =  'N'  ;
        cqh524iRequest.genSecMsg =  'N'  ;
        cqh524iRequest.genSecNum =  '0'  ;
        cqh524iRequest.wapWildAccPickup =  'N'  ;
        cqh524iRequest.employeeNumber =  '0'  ;
        cqh524iRequest.mandate =  '0'  ;
        cqh524iRequest.exclFromInsolvent =  'N'  ;
        cqh524iRequest.digitalHold =  'N'  ;
        cqh524iRequest.odSwitchInd =  'N'  ;
        cqh524iRequest.rbaEdd =  'N' ;
        
        return requestBean ;
    }
    
}