/**
 * @description       : Integration Bean for CIgetClientDetailsV12 Service
 * @author            : PaulJohn.duRand@absa.africa
 * @last modified on  : 2021-08-25
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/
public class CIgetClientDetailsV12_Req_IB_v1 extends Base_IB {
	/**
	 * @description       : CIgetClientDetailsV12
	 **/
	public CIgetClientDetailsV12 CIgetClientDetailsV12 { get; set; }

	/**
	 * @description       : CIgetClientDetailsV12
	 **/
	public class CIgetClientDetailsV12 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Cip002i cip002i;
	}

	/**
	 * @description       : Nbsapdpi
	 **/
	public class Nbsapdpi {
		public String channel;
		public String application;
		public String trace;
	}

	/**
	 * @description       : Nbsmsgi
	 **/
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}

	/**
	 * @description       : FinalMsgId
	 **/
	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	/**
	 * @description       : Cip002i
	 **/
	public class Cip002i {
		public String inpClientCode;
		public String clntAcctNbr;
		public String siteCode;
	}

	/**
	 * @description getNewInstance of Bean
	 * @author PaulJohn.duRand@absa.africa | 2021-08-25
	 * @return CIgetClientDetailsV12_Req_IB_v1
	 **/
	public CIgetClientDetailsV12_Req_IB_v1 getNewInstance() {
		CIgetClientDetailsV12_Req_IB_v1 requestBean = new CIgetClientDetailsV12_Req_IB_v1();
		requestBean.CIgetClientDetailsV12 = new CIgetClientDetailsV12_Req_IB_v1.CIgetClientDetailsV12();
		requestBean.CIgetClientDetailsV12.nbsapdpi = new CIgetClientDetailsV12_Req_IB_v1.Nbsapdpi();
		requestBean.CIgetClientDetailsV12.nbsmsgi = new CIgetClientDetailsV12_Req_IB_v1.Nbsmsgi();
		requestBean.CIgetClientDetailsV12.nbsmsgi.finalMsgId = new FinalMsgId();
		requestBean.CIgetClientDetailsV12.cip002i = new CIgetClientDetailsV12_Req_IB_v1.Cip002i();
		requestBean.CIgetClientDetailsV12.nbsapdpi.trace = 'N';
		requestBean.CIgetClientDetailsV12.nbsmsgi.msgLanguage = 'E';
		requestBean.CIgetClientDetailsV12.nbsmsgi.msgTarget = 'STD';
		requestBean.CIgetClientDetailsV12.nbsmsgi.finalMsgId.finalMsgClass = '';
		requestBean.CIgetClientDetailsV12.nbsmsgi.finalMsgId.finalMsgCode = '';
		return requestBean;
	}
}