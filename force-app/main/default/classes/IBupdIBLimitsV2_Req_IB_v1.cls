/**
 * @description IBupdIBLimitsV2_Req_IB_v1
 */
public class IBupdIBLimitsV2_Req_IB_v1 extends Base_IB {
	public IBupdIBLimitsV2 IBupdIBLimitsV2;
	/**
	 * @description IBupdIBLimitsV2
	 */
	public class IBupdIBLimitsV2 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Nhp297i nhp297i;
	}
	/**
	 * @description Nhp297i
	 */
	public class Nhp297i {
		public String branch;
		public String subBranch;
		public String siteType;
		public String teller;
		public String manager;
		public String agencyCode;
		public String workstation;
		public String supervisor;
		public String accessAccount;
		public String fundTransferLimit;
		public String stopOrderLimit;
		public String accountPaymentLimit;
		public String ownDefinedLimit;
		public String futureDatedLimit;
		public String securityOption;
		public String uFundTransferLim;
		public String uAccPayDayLim;
		public String uAccPayMnthLim;
		public String uAbsaListedMnthLim;
		public String uOnceoffDayLim;
		public String uOnceoffMnthLim;
		public String uAirtimeDayLim;
		public String uAirtimeMnthLim;
		public String uElecDayLim;
		public String uElecMnthLim;
		public String uCashsendDayLim;
		public String uCashsendMnthLim;
		public String uCntclessMnthLim;
	}
	/**
	 * @description FinalMsgId
	 */
	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}
	/**
	 * @description Nbsapdpi
	 */
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
	/**
	 * @description Nbsmsgi
	 */
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
	/**
	 * @description createDummyRequest
	 * @return IBupdIBLimitsV2_Req_IB_v1
	 *
	 */
	public static IBupdIBLimitsV2_Req_IB_v1 createDummyRequest() {
		IBupdIBLimitsV2_Req_IB_v1 requestBean = new IBupdIBLimitsV2_Req_IB_v1();

		requestBean.IBupdIBLimitsV2 = new IBupdIBLimitsV2_Req_IB_v1.IBupdIBLimitsV2();

		requestBean.IBupdIBLimitsV2.nbsapdpi = new IBupdIBLimitsV2_Req_IB_v1.Nbsapdpi();
		requestBean.IBupdIBLimitsV2.nbsapdpi.channel = 'BDP';
		requestBean.IBupdIBLimitsV2.nbsapdpi.application = 'BDE';
		requestBean.IBupdIBLimitsV2.nbsapdpi.trace = 'N';

		requestBean.IBupdIBLimitsV2.nbsmsgi = new IBupdIBLimitsV2_Req_IB_v1.Nbsmsgi();
		requestBean.IBupdIBLimitsV2.nbsmsgi.msgLanguage = 'E';
		requestBean.IBupdIBLimitsV2.nbsmsgi.msgTarget = 'STD';
		requestBean.IBupdIBLimitsV2.nbsmsgi.finalMsgId = new IBupdIBLimitsV2_Req_IB_v1.FinalMsgId();
		requestBean.IBupdIBLimitsV2.nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.IBupdIBLimitsV2.nbsmsgi.finalMsgId.finalMsgCode = '';

		requestBean.IBupdIBLimitsV2.nhp297i = new IBupdIBLimitsV2_Req_IB_v1.Nhp297i();
		requestBean.IBupdIBLimitsV2.nhp297i.branch = '8007';
		requestBean.IBupdIBLimitsV2.nhp297i.subBranch = 'F';
		requestBean.IBupdIBLimitsV2.nhp297i.siteType = 'ABS';
		requestBean.IBupdIBLimitsV2.nhp297i.teller = '355';
		requestBean.IBupdIBLimitsV2.nhp297i.manager = '';
		requestBean.IBupdIBLimitsV2.nhp297i.agencyCode = '0';
		requestBean.IBupdIBLimitsV2.nhp297i.workstation = '';
		requestBean.IBupdIBLimitsV2.nhp297i.supervisor = '';
		requestBean.IBupdIBLimitsV2.nhp297i.accessAccount = '4048499899';
		requestBean.IBupdIBLimitsV2.nhp297i.fundTransferLimit = '10000';
		requestBean.IBupdIBLimitsV2.nhp297i.stopOrderLimit = '7500';
		requestBean.IBupdIBLimitsV2.nhp297i.accountPaymentLimit = '15000';
		requestBean.IBupdIBLimitsV2.nhp297i.ownDefinedLimit = '0';
		requestBean.IBupdIBLimitsV2.nhp297i.futureDatedLimit = '5000';
		requestBean.IBupdIBLimitsV2.nhp297i.securityOption = 'Y';
		requestBean.IBupdIBLimitsV2.nhp297i.uFundTransferLim = '5000';
		requestBean.IBupdIBLimitsV2.nhp297i.uAccPayDayLim = '5000';
		requestBean.IBupdIBLimitsV2.nhp297i.uAccPayMnthLim = '3000';
		requestBean.IBupdIBLimitsV2.nhp297i.uAbsaListedMnthLim = '0';
		requestBean.IBupdIBLimitsV2.nhp297i.uOnceoffDayLim = '0';
		requestBean.IBupdIBLimitsV2.nhp297i.uOnceoffMnthLim = '0';
		requestBean.IBupdIBLimitsV2.nhp297i.uAirtimeDayLim = '0';
		requestBean.IBupdIBLimitsV2.nhp297i.uAirtimeMnthLim = '0';
		requestBean.IBupdIBLimitsV2.nhp297i.uElecDayLim = '0';
		requestBean.IBupdIBLimitsV2.nhp297i.uElecMnthLim = '0';
		requestBean.IBupdIBLimitsV2.nhp297i.uCashsendDayLim = '0';
		requestBean.IBupdIBLimitsV2.nhp297i.uCashsendMnthLim = '0';
		requestBean.IBupdIBLimitsV2.nhp297i.uCntclessMnthLim = '0';

		return requestBean;
	}
}