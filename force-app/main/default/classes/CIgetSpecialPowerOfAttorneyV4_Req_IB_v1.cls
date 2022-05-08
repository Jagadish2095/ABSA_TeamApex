public class CIgetSpecialPowerOfAttorneyV4_Req_IB_v1 extends Base_IB{
    public CIgetSpecialPowerOfAttorneyV4 CIgetSpecialPowerOfAttorneyV4{get;set;}
    public class nbsmsgi{
        public finalMsgId finalMsgId{get;set;}
        public String msgLanguage{get;set;}
        public String msgTarget{get;set;}
    }
    public class nbsapdpi{
        public String trace{get;set;}
        public String application{get;set;}
        public String channel{get;set;}
    }
    public class finalMsgId{
        public String finalMsgCode{get;set;}
        public String finalMsgClass{get;set;}
    }
    public class cip080di{
        public String siteCode{get;set;}
        public String maxRetrieve{get;set;}
        public String option{get;set;}
        public String restartKey{get;set;}
        public String accountNumber{get;set;}
    }
    public class CIgetSpecialPowerOfAttorneyV4{
        public nbsmsgi nbsmsgi{get;set;}
        public cip080di cip080di{get;set;}
        public nbsapdpi nbsapdpi{get;set;}
    }
    public CIgetSpecialPowerOfAttorneyV4_Req_IB_v1 createDummyBean(){
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1 requestbean = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.CIgetSpecialPowerOfAttorneyV4 CIgetSpecialPowerOfAttorneyV4bean = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.CIgetSpecialPowerOfAttorneyV4();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.cip080di cip080dibean  = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.cip080di();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.finalMsgId finalMsgIdbean  = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.finalMsgId();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.nbsapdpi nbsapdpibean  = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.nbsapdpi();
        CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.nbsmsgi nbsmsgibean  = new CIgetSpecialPowerOfAttorneyV4_Req_IB_v1.nbsmsgi();
        finalMsgIdbean.finalMsgClass = 'test';
        finalMsgIdbean.finalMsgCode = 'test';
        nbsmsgibean.msgTarget = 'BDP';
        nbsmsgibean.msgLanguage = 'E';
        nbsmsgibean.finalMsgId = finalMsgIdbean;
        nbsapdpibean.trace = 'test';
        nbsapdpibean.application = 'test';
        nbsapdpibean.channel = 'test';
        cip080dibean.accountNumber = '4048154875';
        CIgetSpecialPowerOfAttorneyV4bean.cip080di = cip080dibean;
        CIgetSpecialPowerOfAttorneyV4bean.nbsapdpi = nbsapdpibean;
        CIgetSpecialPowerOfAttorneyV4bean.nbsmsgi = nbsmsgibean; 
        requestBean.CIgetSpecialPowerOfAttorneyV4 = CIgetSpecialPowerOfAttorneyV4bean;
        return requestbean;
        
    }
    
}