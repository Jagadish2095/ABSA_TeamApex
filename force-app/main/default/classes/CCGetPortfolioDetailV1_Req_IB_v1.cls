/*
 * Request Integration Bean for CCGetPortfolioDetailV1 Service
 * @author Prashant Jain
 * @created 2020-03-16
 */

public class CCGetPortfolioDetailV1_Req_IB_v1 extends Base_IB {

	public CCgetPortfolioDetailV1 CCgetPortfolioDetailV1;

	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	public class Ccp301i {
		public String combiNbr;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class CCgetPortfolioDetailV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Ccp301i ccp301i;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}

    public static CCGetPortfolioDetailV1_Req_IB_v1 createDummyRequest() {
        
        CCGetPortfolioDetailV1_Req_IB_v1 requestBean = new CCGetPortfolioDetailV1_Req_IB_v1();
        requestBean.CCgetPortfolioDetailV1 = new CCGetPortfolioDetailV1_Req_IB_v1.CCgetPortfolioDetailV1();
        requestBean.CCgetPortfolioDetailV1.nbsapdpi = new CCGetPortfolioDetailV1_Req_IB_v1.Nbsapdpi();
        requestBean.CCgetPortfolioDetailV1.nbsmsgi = new CCGetPortfolioDetailV1_Req_IB_v1.Nbsmsgi();
        requestBean.CCgetPortfolioDetailV1.ccp301i = new CCGetPortfolioDetailV1_Req_IB_v1.Ccp301i();
        
        requestBean.CCgetPortfolioDetailV1.nbsapdpi.channel = 'BPD';
        requestBean.CCgetPortfolioDetailV1.nbsapdpi.application = 'BPD';
        requestBean.CCgetPortfolioDetailV1.nbsapdpi.trace = 'Y';
        requestBean.CCgetPortfolioDetailV1.nbsmsgi.msgLanguage = 'E';
        requestBean.CCgetPortfolioDetailV1.nbsmsgi.msgTarget = 'STD';
        
        requestBean.CCgetPortfolioDetailV1.ccp301i.combiNbr = '4483850000161519';
        
        return requestBean;
    }
}