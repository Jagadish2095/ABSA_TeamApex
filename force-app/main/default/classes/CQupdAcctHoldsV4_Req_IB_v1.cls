public class CQupdAcctHoldsV4_Req_IB_v1 {
    
    public CQupdAcctHoldsV4 CQupdAcctHoldsV4{get;set;}
    
    public class CQupdAcctHoldsV4 {
        public nbsapdpi nbsapdpi{get;set;}
        public nbsmsgi nbsmsgi{get;set;}
        public cqh525i cqh525i{get;set;} 
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
    
    public class cqh525i{
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
    
     public CQupdAcctHoldsV4_Req_IB_v1 createDummy(){
        CQupdAcctHoldsV4_Req_IB_v1 requestBean = new CQupdAcctHoldsV4_Req_IB_v1();
        CQupdAcctHoldsV4_Req_IB_v1.nbsapdpi nbsapdpiRequest = new CQupdAcctHoldsV4_Req_IB_v1.nbsapdpi ();
        CQupdAcctHoldsV4_Req_IB_v1.nbsmsgi nbsmsgiRequest = new CQupdAcctHoldsV4_Req_IB_v1.nbsmsgi ();
        CQupdAcctHoldsV4_Req_IB_v1.finalMsgId finalMsgIdRequest = new CQupdAcctHoldsV4_Req_IB_v1.finalMsgId();
        CQupdAcctHoldsV4_Req_IB_v1.cqh525i cqh525iRequest = new CQupdAcctHoldsV4_Req_IB_v1.cqh525i ();
        
            
        nbsapdpiRequest.application = 'BDP';
        nbsapdpiRequest.channel = 'BDP';
        nbsapdpiRequest.trace = 'Y';
        
        nbsmsgiRequest.msgLanguage = 'E';
        nbsmsgiRequest.msgTarget = 'STD';
        finalMsgIdRequest.finalMsgClass = '';
        finalMsgIdRequest.finalMsgCode = '';
         
         
         cqh525iRequest.accountNbr =  '4048017641'  ;
        cqh525iRequest.branchCode =  '8089'  ;
        cqh525iRequest.branchSiteType =  '034'  ;
        cqh525iRequest.tellerCode =  '25698'  ;
        cqh525iRequest.siteTypeAgency =  '034'  ;
        cqh525iRequest.supervisorCode =  '25698'  ;
        cqh525iRequest.agencyCode =  '8198'  ;
        cqh525iRequest.corpCode =  'ABS'  ;
        cqh525iRequest.blocked =  'N'  ;
        cqh525iRequest.courtOrder =  'Y'  ;
        cqh525iRequest.mandateRequired =  'N'  ;
        cqh525iRequest.dormant =  'N'  ;
        cqh525iRequest.semiDormant =  'N'  ;
        cqh525iRequest.confiscated =  'N'  ;
        cqh525iRequest.externalTransfer =  'Y'  ;
        cqh525iRequest.staff =  'N'  ;
        cqh525iRequest.creditAccount =  'N'  ;
        cqh525iRequest.excludeFromEstate =  'N'  ;
        cqh525iRequest.blockAdhocDbt =  'N'  ;
        cqh525iRequest.blockAdhocCrd =  'N'  ;
        cqh525iRequest.specialRqpRedirect =  'N'  ;
        cqh525iRequest.commercialPropFin =  'N'  ;
        cqh525iRequest.misHold =  'N'  ;
        cqh525iRequest.genSecMsg =  'N'  ;
        cqh525iRequest.genSecNum =  '0'  ;
        cqh525iRequest.wapWildAccPickup =  'N'  ;
        cqh525iRequest.employeeNumber =  '0'  ;
        cqh525iRequest.mandate =  '0'  ;
        cqh525iRequest.exclFromInsolvent =  'N'  ;
        cqh525iRequest.digitalHold =  'N'  ;
        cqh525iRequest.odSwitchInd =  'N'  ;
        cqh525iRequest.rbaEdd =  'N' ;

         
         return requestBean;
     }

}