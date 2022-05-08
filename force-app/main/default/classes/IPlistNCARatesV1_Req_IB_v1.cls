/**
 * @description       : Request bean
 * @author            : Saurabh Pandey
 * @last modified on  : 2021-06-12
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-12   Saurabh Pandey   Initial Version
 **/

public class IPlistNCARatesV1_Req_IB_v1 extends Base_IB {
	public IPlistNCARatesV1 IPlistNCARatesV1;
	/**
	 * @description       : Request bean
	 * @author            : Saurabh Pandey
	 **/
	public class Ipb100i {
		public String brandCode;
		public String effectiveDate;
	}
	/**
	 * @description       : Request bean
	 * @author            : Saurabh Pandey
	 **/
	public class IPlistNCARatesV1 {
		public Nbsapdpi nbsapdpi;
		public Nbsmsgi nbsmsgi;
		public Ipb100i ipb100i;
	}
	/**
	 * @description       : Request bean
	 * @author            : Saurabh Pandey
	 **/
	public class Nbsapdpi {
		public String application;
		public String channel;
		public String trace;
	}
	/**
	 * @description       : Request bean
	 * @author            : Saurabh Pandey
	 **/
	public class Nbsmsgi {
		public String msgLanguage;
		public String msgTarget;
		public FinalMsgId finalMsgId;
	}
	/**
	 * @description       : Request bean
	 * @author            : Saurabh Pandey
	 **/
	public class FinalMsgId {
		public String finalMsgClass;
		public String finalMsgCode;
	}

	/**
	 * @description dummy request
	 * @author Himanshu.Nimje@absa.africa | 2021-06-12
	 * @return IPlistNCARatesV1_Req_IB_v1
	 **/
	public static IPlistNCARatesV1_Req_IB_v1 createDummyRequest() {
		IPlistNCARatesV1_Req_IB_v1 requestBean = new IPlistNCARatesV1_Req_IB_v1();
		IPlistNCARatesV1_Req_IB_v1.IPlistNCARatesV1 IPlistNCARatesV1 = new IPlistNCARatesV1_Req_IB_v1.IPlistNCARatesV1();

		IPlistNCARatesV1_Req_IB_v1.Ipb100i Ipb100i = new IPlistNCARatesV1_Req_IB_v1.Ipb100i();
		Ipb100i.brandCode = 'ABS';
		Ipb100i.effectiveDate = '20201117';
		IPlistNCARatesV1_Req_IB_v1.Nbsapdpi Nbsapdpi = new IPlistNCARatesV1_Req_IB_v1.Nbsapdpi();
		Nbsapdpi.application = '';
		Nbsapdpi.channel = '';
		Nbsapdpi.trace = 'N';
		IPlistNCARatesV1_Req_IB_v1.FinalMsgId FinalMsgId = new IPlistNCARatesV1_Req_IB_v1.FinalMsgId();
		FinalMsgId.finalMsgClass = '';
		FinalMsgId.finalMsgCode = '';

		IPlistNCARatesV1_Req_IB_v1.Nbsmsgi Nbsmsgi = new IPlistNCARatesV1_Req_IB_v1.Nbsmsgi();
		Nbsmsgi.msgLanguage = 'E';
		Nbsmsgi.msgTarget = 'STD';
		Nbsmsgi.finalMsgId = FinalMsgId;

		IPlistNCARatesV1.ipb100i = Ipb100i;
		IPlistNCARatesV1.nbsapdpi = Nbsapdpi;
		IPlistNCARatesV1.nbsmsgi = Nbsmsgi;
		requestBean.IPlistNCARatesV1 = IPlistNCARatesV1;

		return requestBean;
	}
}