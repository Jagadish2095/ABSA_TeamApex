public class cclinkaccounttocombicardv3_Req_IB_v1 extends Base_IB {
    
    public CClinkAccountToCombiCardV3 CClinkAccountToCombiCardV3{get;set;}
    public class nbsmsgi{
        public String msgTarget{get;set;}
        public String msgLanguage{get;set;}
        public finalMsgId finalMsgId{get;set;}
    }
    public class nbsapdpi{
        public String trace{get;set;}
        public String application{get;set;}
        public String channel{get;set;}
    }
    public class finalMsgId{
        public String finalMsgClass{get;set;}
        public String finalMsgCode{get;set;}
    }
    public class ccp303i{
        public String supervisor{get;set;}
        public String autoLinkInd{get;set;}
        public String ownCifInd{get;set;}
        public String inpAccntNbr{get;set;}
        public String poaInd{get;set;}
        public String combiNbr{get;set;}
        public String jointAccInd{get;set;}
        public String branchCode{get;set;}
        public String soleTraderInd{get;set;}
        public String workStation{get;set;}
        public String bankInterInd{get;set;}
        public String tellerCode{get;set;}
        public String clientCode{get;set;}
    }
    public class CClinkAccountToCombiCardV3{
        public nbsmsgi nbsmsgi{get;set;}
        public ccp303i ccp303i{get;set;}
        public nbsapdpi nbsapdpi{get;set;}
    }
    public cclinkaccounttocombicardv3_Req_IB_v1 createDummyBean(){
        
        cclinkaccounttocombicardv3_Req_IB_v1 requestbean = new cclinkaccounttocombicardv3_Req_IB_v1();
        cclinkaccounttocombicardv3_Req_IB_v1.CClinkAccountToCombiCardV3 CClinkAccountToCombiCardV3bean = new cclinkaccounttocombicardv3_Req_IB_v1.CClinkAccountToCombiCardV3();
        cclinkaccounttocombicardv3_Req_IB_v1.ccp303i ccp303ibean  = new cclinkaccounttocombicardv3_Req_IB_v1.ccp303i();
        cclinkaccounttocombicardv3_Req_IB_v1.finalMsgId finalMsgIdbean  = new cclinkaccounttocombicardv3_Req_IB_v1.finalMsgId();
        cclinkaccounttocombicardv3_Req_IB_v1.nbsapdpi nbsapdpibean  = new cclinkaccounttocombicardv3_Req_IB_v1.nbsapdpi();
        cclinkaccounttocombicardv3_Req_IB_v1.nbsmsgi nbsmsgibean  = new cclinkaccounttocombicardv3_Req_IB_v1.nbsmsgi();
        
        
        finalMsgIdbean.finalMsgClass = 'test';
        finalMsgIdbean.finalMsgCode = 'test';
        
        nbsmsgibean.msgTarget = 'BDP';
        nbsmsgibean.msgLanguage = 'E';
        nbsmsgibean.finalMsgId = finalMsgIdbean;
        
        nbsapdpibean.trace = 'test';
        nbsapdpibean.application = 'test';
        nbsapdpibean.channel = 'test';
        
        ccp303ibean.supervisor = '4048154875';
        ccp303ibean.autoLinkInd = 'SPID';
        ccp303ibean.ownCifInd = '034';
        ccp303ibean.inpAccntNbr = '20191001';
        ccp303ibean.poaInd = '01';
        ccp303ibean.combiNbr = 'test';
        ccp303ibean.branchCode = 'BDP';  
        ccp303ibean.soleTraderInd = '20191001';
        ccp303ibean.workStation = '01';
        ccp303ibean.bankInterInd = 'test';
        ccp303ibean.tellerCode = 'BDP';
        ccp303ibean.clientCode = 'BDP';
        
        CClinkAccountToCombiCardV3bean.ccp303i = ccp303ibean;
        CClinkAccountToCombiCardV3bean.nbsapdpi = nbsapdpibean;
        CClinkAccountToCombiCardV3bean.nbsmsgi = nbsmsgibean; 
        requestBean.CClinkAccountToCombiCardV3 = CClinkAccountToCombiCardV3bean;
        return requestbean;
        
    }
    
}