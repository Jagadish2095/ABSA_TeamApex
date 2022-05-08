/**
 * @description Request Integration Bean for CClistAccsLinkedToCombiV1 Service
 * @author: Humbelani Denge
 * @created: 2021-02-12
 */
public class CClistAccsLinkedToCombiV1_Req_IB_v1 extends Base_IB {
	/**
	 * @description inner class
	 */
	public CClistAccsLinkedToACombiCardV1 CClistAccsLinkedToACombiCardV1;
	/**
	 * @description inner class
	 */
	public class CClistAccsLinkedToACombiCardV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Ccp308i ccp308i;
	}
	/**
	 * @description inner class
	 */
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}
	/**
	 * @description inner class
	 */
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
	/**
	 * @description inner class
	 */
	public class Ccp308i {
		public String combiNbr;
		public String inpAccntNbr;
		public String nbrAccntReq;
	}
	/**
	 * @description inner class
	 */
	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	/**
	 * @description creates dummy request bean for use in unit testing
	 * @return CClistAccsLinkedToCombiV1_Req_IB_v1
	 */
	public static CClistAccsLinkedToCombiV1_Req_IB_v1 createDummyRequest() {
		CClistAccsLinkedToCombiV1_Req_IB_v1 requestBean = new CClistAccsLinkedToCombiV1_Req_IB_v1();
		requestBean.CClistAccsLinkedToACombiCardV1 = new CClistAccsLinkedToCombiV1_Req_IB_v1.CClistAccsLinkedToACombiCardV1();
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsapdpi = new CClistAccsLinkedToCombiV1_Req_IB_v1.Nbsapdpi();
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsapdpi.channel = 'BDP';
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsapdpi.application = 'BDP';
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsapdpi.trace = 'Y';

		requestBean.CClistAccsLinkedToACombiCardV1.nbsmsgi = new CClistAccsLinkedToCombiV1_Req_IB_v1.nbsmsgi();

		requestBean.CClistAccsLinkedToACombiCardV1.nbsmsgi.msgLanguage = 'STD';
		requestBean.CClistAccsLinkedToACombiCardV1.nbsmsgi.msgTarget = 'E';
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsmsgi.FinalMsgId = new CClistAccsLinkedToCombiV1_Req_IB_v1.finalMsgId();

		requestBean.CClistAccsLinkedToACombiCardV1.Nbsmsgi.FinalMsgId = new CClistAccsLinkedToCombiV1_Req_IB_v1.FinalMsgId();
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsmsgi.FinalMsgId.finalMsgClass = '';
		requestBean.CClistAccsLinkedToACombiCardV1.Nbsmsgi.FinalMsgId.finalMsgCode = '';
		requestBean.CClistAccsLinkedToACombiCardV1.Ccp308i = new CClistAccsLinkedToCombiV1_Req_IB_v1.Ccp308i();
		requestBean.CClistAccsLinkedToACombiCardV1.Ccp308i.combiNbr = '04451430000038047';
		requestBean.CClistAccsLinkedToACombiCardV1.Ccp308i.inpAccntNbr = '0';
		requestBean.CClistAccsLinkedToACombiCardV1.Ccp308i.nbrAccntReq = '0';

		return requestBean;
	}
}