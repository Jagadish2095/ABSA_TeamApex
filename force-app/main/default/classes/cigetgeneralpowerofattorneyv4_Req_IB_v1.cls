public class cigetgeneralpowerofattorneyv4_Req_IB_v1 extends Base_IB{
    
	public CIgetGeneralPowerOfAttorneyV4 CIgetGeneralPowerOfAttorneyV4{get;set;}
	public class nbsmsgi{
		public finalMsgId finalMsgId{get;set;}
		public String msgTarget{get;set;}
		public String msgLanguage{get;set;}
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
	public class cip081di{
		public String accountNumber{get;set;}
		public String siteCode{get;set;}
		public String maxRetrieve{get;set;}
		public String option{get;set;}
		public String restartKey{get;set;}
		public String clientCode{get;set;}
	}
	public class CIgetGeneralPowerOfAttorneyV4{
		public nbsmsgi nbsmsgi{get;set;}
		public cip081di cip081di{get;set;}
		public nbsapdpi nbsapdpi{get;set;}
	}
    public cigetgeneralpowerofattorneyv4_Req_IB_v1 createDummyBean(){
        cigetgeneralpowerofattorneyv4_Req_IB_v1 requestbean = new cigetgeneralpowerofattorneyv4_Req_IB_v1();
        cigetgeneralpowerofattorneyv4_Req_IB_v1.cigetgeneralpowerofattorneyv4 cigetgeneralpowerofattorneyv4bean = new cigetgeneralpowerofattorneyv4_Req_IB_v1.cigetgeneralpowerofattorneyv4();
        cigetgeneralpowerofattorneyv4_Req_IB_v1.cip081di cip081dibean  = new cigetgeneralpowerofattorneyv4_Req_IB_v1.cip081di();
        cigetgeneralpowerofattorneyv4_Req_IB_v1.finalMsgId finalMsgIdbean  = new cigetgeneralpowerofattorneyv4_Req_IB_v1.finalMsgId();
        cigetgeneralpowerofattorneyv4_Req_IB_v1.nbsapdpi nbsapdpibean  = new cigetgeneralpowerofattorneyv4_Req_IB_v1.nbsapdpi();
        cigetgeneralpowerofattorneyv4_Req_IB_v1.nbsmsgi nbsmsgibean  = new cigetgeneralpowerofattorneyv4_Req_IB_v1.nbsmsgi();
        finalMsgIdbean.finalMsgClass = 'test';
        finalMsgIdbean.finalMsgCode = 'test';
        nbsmsgibean.msgTarget = 'BDP';
        nbsmsgibean.msgLanguage = 'E';
        nbsmsgibean.finalMsgId = finalMsgIdbean;
        nbsapdpibean.trace = 'test';
        nbsapdpibean.application = 'test';
        nbsapdpibean.channel = 'test';
        cip081dibean.accountNumber = '4048154875';
        cigetgeneralpowerofattorneyv4bean.cip081di = cip081dibean;
        cigetgeneralpowerofattorneyv4bean.nbsapdpi = nbsapdpibean;
        cigetgeneralpowerofattorneyv4bean.nbsmsgi = nbsmsgibean; 
        requestBean.cigetgeneralpowerofattorneyv4 = cigetgeneralpowerofattorneyv4bean;
        return requestbean;
        
    }

}