public class ccdelinkaccountsv1_Req_IB_v1 extends Base_IB {
    public CCdelinkAccountsV1 CCdelinkAccountsV1{get;set;}
    public class nbsmsgi{
        public String msgLanguage{get;set;}
        public String msgTarget{get;set;}
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
    public class delinkAccntLst{
        public String accntNbr{get;set;}
        public String delinkInd{get;set;}
    }
    public class ccp309i{
        public String workStation{get;set;}
        public String combiNbr{get;set;}
        public String branchCode{get;set;}
        public String inpAccntNbr{get;set;}
        public String supervisor{get;set;}
        public String nbrAccntReq{get;set;}
        public String tellerCode{get;set;}
        public list<delinkAccntLst> delinkAccntLst{get;set;}
    }
    public class CCdelinkAccountsV1{
        public nbsmsgi nbsmsgi{get;set;}
        public ccp309i ccp309i{get;set;}
        public nbsapdpi nbsapdpi{get;set;}
    }
    public ccdelinkaccountsv1_Req_IB_v1 createDummyBean(){
        ccdelinkaccountsv1_Req_IB_v1 requestbean = new ccdelinkaccountsv1_Req_IB_v1();
        ccdelinkaccountsv1_Req_IB_v1.CCdelinkAccountsV1 CCdelinkAccountsV1bean = new ccdelinkaccountsv1_Req_IB_v1.CCdelinkAccountsV1();
        ccdelinkaccountsv1_Req_IB_v1.ccp309i ccp309ibean  = new ccdelinkaccountsv1_Req_IB_v1.ccp309i();
        ccdelinkaccountsv1_Req_IB_v1.finalMsgId finalMsgIdbean  = new ccdelinkaccountsv1_Req_IB_v1.finalMsgId();
        ccdelinkaccountsv1_Req_IB_v1.nbsapdpi nbsapdpibean  = new ccdelinkaccountsv1_Req_IB_v1.nbsapdpi();
        ccdelinkaccountsv1_Req_IB_v1.nbsmsgi nbsmsgibean  = new ccdelinkaccountsv1_Req_IB_v1.nbsmsgi();
        ccdelinkaccountsv1_Req_IB_v1.delinkAccntLst delinkAccntLstBean = new ccdelinkaccountsv1_Req_IB_v1.delinkAccntLst();
        List<ccdelinkaccountsv1_Req_IB_v1.delinkAccntLst> delinkAccntLstBeanList = new List<ccdelinkaccountsv1_Req_IB_v1.delinkAccntLst>();
        
        finalMsgIdbean.finalMsgClass = 'test';
        finalMsgIdbean.finalMsgCode = 'test';
        
        nbsmsgibean.msgTarget = 'BDP';
        nbsmsgibean.msgLanguage = 'E';
        nbsmsgibean.finalMsgId = finalMsgIdbean;
        
        nbsapdpibean.trace = 'test';
        nbsapdpibean.application = 'test';
        nbsapdpibean.channel = 'test';
        
        delinkAccntLstBean.accntNbr = '0';
        delinkAccntLstBean.delinkInd = 'Y';
        delinkAccntLstBeanList.add(delinkAccntLstBean);
        
        ccp309ibean.workStation = '4048154875';
        ccp309ibean.combiNbr = 'SPID';
        ccp309ibean.branchCode = '034';
        ccp309ibean.inpAccntNbr = '20191001';
        ccp309ibean.supervisor = '01';
        ccp309ibean.nbrAccntReq = 'test';
        ccp309ibean.tellerCode = 'BDP'; 
        ccp309ibean.delinkAccntLst = delinkAccntLstBeanList; 
        CCdelinkAccountsV1bean.ccp309i = ccp309ibean;
        CCdelinkAccountsV1bean.nbsapdpi = nbsapdpibean;
        CCdelinkAccountsV1bean.nbsmsgi = nbsmsgibean; 
        requestBean.CCdelinkAccountsV1 = CCdelinkAccountsV1bean;
        return requestbean;
        
    }
    
}