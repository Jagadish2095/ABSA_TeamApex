/**
 * @description       : Response Bean Class
 * @author            : Himanshu.Nimje@absa.africa
 * @last modified on  : 2021-07-09
 * @last modified by  : Himanshu.Nimje@absa.africa
 * Modifications Log
 * Ver   Date         Author                       Modification
 * 1.0   2021-06-24   Himanshu.Nimje@absa.africa   Initial Version
 **/

public class GBgetCmsFullCrGroups_Resp_IB_v1 extends Base_IB {
	public NBSAPDPO NBSAPDPO;
	public GSB025O_Z GSB025O;
	public NBSMSGO3_Z NBSMSGO3;
	/**
	 * @description Resp Bean Class
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/
	public class NBSMSGO3_Z {
		public NBSMSGO3 NBSMSGO3;
	}
	/**
	 * @description Resp Bean Class
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/

	public class NBSAPLO {
		public Integer NBNAPLO_REASON_CODE;
		public Integer NBNAPLO_RETURN_CODE;
		public String NBNAPLO_SERVICE_VERSION;
	}
	/**
	 * @description Resp Bean Class
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/

	public class NBSAPDPO {
		public NBSAPLO NBSAPLO;
	}
	/**
	 * @description Resp Bean Class
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/

	public class GSB025O {
		public String GSB025O_ULT_PRIMARY_CLIENT;
		public Integer GSB025O_NO_OF_CLIENTS;
		public List<GSB025O_GROUP_DETAIL> GSB025O_GROUP_DETAIL;
		public String GSB025O_PART_OF_GROUP;
	}
	/**
	 * @description Resp Bean Class
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/

	public class GSB025O_Z {
		public GSB025O GSB025O;
	}
	/**
	 * @description Resp Bean Class
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/
	public class GSB025O_GROUP_DETAIL {
		public String GSB025O_STATUS_IND;
		public Integer GSB025O_GROUP_NUM;
		public String GSB025O_CLIENT_LINK;
		public String GSB025O_PRIM_OR_GRPMEM;
	}
	/**
	 * @description Resp Bean Class
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/
	public class NBSMSGO3 {
		public Integer NBNMSGO3_NBR_USER_ERRS;
		public String NBSMSGO3_VERSION;
		public String NBNMSGO3_SYS_ERR_TXT;
		public Integer NBNMSGO3_NBR_USER_MSGS;
		public List<NBNMSGO3_MSG_ENTRY> NBNMSGO3_MSG_ENTRY;
	}
	/**
	 * @description Resp Bean Class
	 * @author Himanshu.Nimje@absa.africa | 2021-06-24
	 **/
	public class NBNMSGO3_MSG_ENTRY {
		public String NBNMSGO3_MSG_ERR_IND;
		public String NBNMSGO3_MSG_TXT;
		public String NBNMSGO3_MSG_CLASS;
		public String NBNMSGO3_MSG_CODE;
	}
}