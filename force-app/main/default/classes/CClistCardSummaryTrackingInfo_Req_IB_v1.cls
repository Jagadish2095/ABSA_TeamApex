/**
 * @description Request Integration Bean for CClistCardSummaryTrackingInfo Service
 * @author Jason Quevauvilliers
 * @created 2021-03-24
 */
public class CClistCardSummaryTrackingInfo_Req_IB_v1 extends Base_IB {
	public CClistCardSummaryTrackingInfoV2_cls CClistCardSummaryTrackingInfoV2;

	/**
	 * @description inner class
	 */
	public class CClistCardSummaryTrackingInfoV2_cls {
		public Nbsapdpi_cls nbsapdpi;
		public Nbsmsgi_cls nbsmsgi;
		public Ccp401i_cls ccp401i;
	}

	/**
	 * @description inner class
	 */
	public class Nbsapdpi_cls {
		public String channel;
		public String application;
		public String trace;
	}

	/**
	 * @description inner class
	 */
	public class Nbsmsgi_cls {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId_cls finalMsgId;
	}

	/**
	 * @description inner class
	 */
	public class Ccp401i_cls {
		public String clientCode;
		public String regNbr;
		public String idNbr;
		public String cardNbr;
	}

	/**
	 * @description inner class
	 */
	public class FinalMsgId_cls {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	/**
	 * @description Creates a fake request for testing
	 * @return DLGetPaymentHistoryForCustomer_Req_IB_v1
	 */
	public static CClistCardSummaryTrackingInfo_Req_IB_v1 createDummyRequest() {
		CClistCardSummaryTrackingInfo_Req_IB_v1 requestBean = new CClistCardSummaryTrackingInfo_Req_IB_v1();
		requestBean.CClistCardSummaryTrackingInfoV2 = new CClistCardSummaryTrackingInfo_Req_IB_v1.CClistCardSummaryTrackingInfoV2_cls();
		requestBean.CClistCardSummaryTrackingInfoV2.nbsapdpi = new CClistCardSummaryTrackingInfo_Req_IB_v1.Nbsapdpi_cls();
		requestBean.CClistCardSummaryTrackingInfoV2.nbsmsgi = new CClistCardSummaryTrackingInfo_Req_IB_v1.Nbsmsgi_cls();
		requestBean.CClistCardSummaryTrackingInfoV2.nbsmsgi.finalMsgId = new CClistCardSummaryTrackingInfo_Req_IB_v1.FinalMsgId_cls();
		requestBean.CClistCardSummaryTrackingInfoV2.ccp401i = new CClistCardSummaryTrackingInfo_Req_IB_v1.Ccp401i_cls();

		requestBean.CClistCardSummaryTrackingInfoV2.nbsapdpi.channel = 'BDP';
		requestBean.CClistCardSummaryTrackingInfoV2.nbsapdpi.application = 'BDP';
		requestBean.CClistCardSummaryTrackingInfoV2.nbsapdpi.trace = 'Y';

		requestBean.CClistCardSummaryTrackingInfoV2.nbsmsgi.msgLanguage = 'E';
		requestBean.CClistCardSummaryTrackingInfoV2.nbsmsgi.msgTarget = 'STD';

		requestBean.CClistCardSummaryTrackingInfoV2.ccp401i.clientCode = 'NORMAJ 013';
		return requestBean;
	}
}