public class CQgetAcctHoldsMaintV4_Req_IB_v1 {
    
    public CQgetAcctHoldsMaintV4 CQgetAcctHoldsMaintV4{get;set;}
    public class CQgetAcctHoldsMaintV4{
       public nbsapdpi nbsapdpi{get;set;}
       public nbsmsgi nbsmsgi{get;set;}
       public cqh503i cqh503i{get;set;}
    }
   public class nbsapdpi {
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
    
    public class cqh503i{
        public String accountNbr;
        public String branchCode;
        public String branchSiteType;
        public String tellerCode;
        public String siteTypeAgency;
        public String supervisorCode;
        public String agencyCode;
        public String corpCode;
    }
    
    public static CQgetAcctHoldsMaintV4_Req_IB_v1 createDummy(){
        CQgetAcctHoldsMaintV4_Req_IB_v1 requestBean = new CQgetAcctHoldsMaintV4_Req_IB_v1();
        CQgetAcctHoldsMaintV4_Req_IB_v1.nbsapdpi nbsapdpiRequest = new CQgetAcctHoldsMaintV4_Req_IB_v1.nbsapdpi ();
        CQgetAcctHoldsMaintV4_Req_IB_v1.nbsmsgi nbsmsgiRequest = new CQgetAcctHoldsMaintV4_Req_IB_v1.nbsmsgi ();
        CQgetAcctHoldsMaintV4_Req_IB_v1.cqh503i cqh503iRequest = new CQgetAcctHoldsMaintV4_Req_IB_v1.cqh503i ();
        CQgetAcctHoldsMaintV4_Req_IB_v1.finalMsgId finalMsgIdRequest = new CQgetAcctHoldsMaintV4_Req_IB_v1.finalMsgId();
            
        nbsapdpiRequest.application = 'BDP';
        nbsapdpiRequest.channel = 'BDP';
        nbsapdpiRequest.trace = 'Y';
        
        nbsmsgiRequest.msgLanguage = 'E';
        nbsmsgiRequest.msgTarget = 'STD';
        
        finalMsgIdRequest.finalMsgClass = '';
        finalMsgIdRequest.finalMsgCode = '';
        
        cqh503iRequest.accountNbr = '4048017641';
        cqh503iRequest.branchCode = '8089';
        cqh503iRequest.branchSiteType = '034';
        cqh503iRequest.tellerCode = '25698';
        cqh503iRequest.siteTypeAgency = '034';
        cqh503iRequest.supervisorCode = '25698';
        cqh503iRequest.agencyCode = '8198';
        cqh503iRequest.corpCode = 'ABS';
       
        
        CQgetAcctHoldsMaintV4_Req_IB_v1.CQgetAcctHoldsMaintV4  respBean = new CQgetAcctHoldsMaintV4_Req_IB_v1.CQgetAcctHoldsMaintV4();
        respBean.nbsapdpi = nbsapdpiRequest;
        respBean.nbsmsgi = nbsmsgiRequest;
        respBean.cqh503i = cqh503iRequest;
        
        
        return requestBean;
        
    }
}