/*
 * Request Integration Bean for CCgetDailyLimitsV2 Service
 * @author Willy Zuvana
 * @created 2020-10-15
 */
public class CCgetDailyLimitsV2_Req_IB_v1 Extends Base_IB {

	public CCgetDailyLimitsV2 CCgetDailyLimitsV2;

	public class Ccp312i {
		public String combiNbr;
	}

	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public String finalMsgId;
	}

	public class CCgetDailyLimitsV2 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Ccp312i ccp312i;
	}
  
    public static CCgetDailyLimitsV2_Req_IB_v1 createDummyRequest(){
        CCgetDailyLimitsV2_Req_IB_v1 requestBean = new CCgetDailyLimitsV2_Req_IB_v1();
        CCgetDailyLimitsV2_Req_IB_v1.Nbsapdpi NbsapdpiBean = new CCgetDailyLimitsV2_Req_IB_v1.Nbsapdpi();
        CCgetDailyLimitsV2_Req_IB_v1.Ccp312i Ccp312iiBean = new CCgetDailyLimitsV2_Req_IB_v1.Ccp312i();
        CCgetDailyLimitsV2_Req_IB_v1.Nbsmsgi NbsmsgiBean = new CCgetDailyLimitsV2_Req_IB_v1.Nbsmsgi();
        CCgetDailyLimitsV2_Req_IB_v1.CCgetDailyLimitsV2 CCgetDailyLimitsV2RequestBean = new CCgetDailyLimitsV2_Req_IB_v1.CCgetDailyLimitsV2();

        NbsapdpiBean.channel = 'BDP';
        NbsapdpiBean.application = 'BDP';
        NbsapdpiBean.trace = 'N'; 
		
		NbsmsgiBean.msgLanguage = 'E';
		NbsmsgiBean.msgTarget = 'STD';
        

        Ccp312iiBean.combiNbr = '4483850000353595';

        CCgetDailyLimitsV2RequestBean.nbsapdpi = NbsapdpiBean;
        CCgetDailyLimitsV2RequestBean.ccp312i = Ccp312iiBean;
        CCgetDailyLimitsV2RequestBean.nbsmsgi = NbsmsgiBean;
        requestBean.CCgetDailyLimitsV2 = CCgetDailyLimitsV2RequestBean;

        return requestBean;

    }
}