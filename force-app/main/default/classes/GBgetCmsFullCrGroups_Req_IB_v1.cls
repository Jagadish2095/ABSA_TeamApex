/**
 * @description       :
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-07-09
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-24   Himanshu.Nimje@absa.africa   Initial Version
 **/

public class GBgetCmsFullCrGroups_Req_IB_v1 extends Base_IB {
	public NBSAPDPI NBSAPDPI;
	public NBSMSGI_Z NBSMSGI;
	public GSB025I_Z GSB025I;
	/** @description GBgetCmsFullCrGroups_Req_IB_v1 wrapper class */
	public class NBSMSGI_Z {
		public NBSMSGI NBSMSGI;
	}
	/** @description GBgetCmsFullCrGroups_Req_IB_v1 wrapper class */
	public class GSB025I {
		public String GSB025I_CLIENT_CODE;
	}
	/** @description GBgetCmsFullCrGroups_Req_IB_v1 wrapper class */
	public class NBSMSGI {
		public String NBNMSGI_MSG_LANGUAGE;
		public String NBNMSGI_MSG_TARGET;
	}
	/** @description GBgetCmsFullCrGroups_Req_IB_v1 wrapper class */
	public class NBSAPLI {
		public String NBNAPLI_CHANNEL;
		public String NBNAPLI_APPLICATION;
		public String NBNAPLI_TRACE;
	}
	/** @description GBgetCmsFullCrGroups_Req_IB_v1 wrapper class */
	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}
	/** @description GBgetCmsFullCrGroups_Req_IB_v1 wrapper class */
	public class GSB025I_Z {
		public GSB025I GSB025I;
	}
	/**
	 * @description Dummy Request
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 * @return GBgetCmsFullCrGroups_Req_IB_v1
	 **/
	public static GBgetCmsFullCrGroups_Req_IB_v1 createDummyRequest() {
		GBgetCmsFullCrGroups_Req_IB_v1 requestBean = new GBgetCmsFullCrGroups_Req_IB_v1();
		requestBean.NBSAPDPI = new GBgetCmsFullCrGroups_Req_IB_v1.NBSAPDPI();
		requestBean.NBSMSGI = new GBgetCmsFullCrGroups_Req_IB_v1.NBSMSGI_Z();
		requestBean.GSB025I = new GBgetCmsFullCrGroups_Req_IB_v1.GSB025I_Z();
		requestBean.NBSAPDPI.NBSAPLI = new GBgetCmsFullCrGroups_Req_IB_v1.NBSAPLI();
		requestBean.NBSMSGI.NBSMSGI = new GBgetCmsFullCrGroups_Req_IB_v1.NBSMSGI();
		requestBean.GSB025I.GSB025I = new GBgetCmsFullCrGroups_Req_IB_v1.GSB025I();

		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL = 'BDP';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION = 'BDP';
		requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE = 'Y';

		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE = 'E';
		requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET = 'STD';

		requestBean.GSB025I.GSB025I.GSB025I_CLIENT_CODE = 'ADHAUS 003';

		return requestBean;
	}
}