/**
 * Response Integration Bean for GBgetCmsCreditGroupsDetV1 Service
 * @author Englarmerdge Mongwe
 * @created 2020-10-13
 */

public class GBgetCmsCreditGroupsDetV1_Resp_IB_v1  extends Base_IB {
    public NBSAPDPO NBSAPDPO;
	public GSB014O_Z GSB014O;
	public NBSMSGO3_Z NBSMSGO3;

    public class NBSAPDPO {
		public NBSAPLO NBSAPLO;
	}

	public class GSB014O_Z {
		public GSB014O GSB014O;
    }

    public class NBSMSGO3_Z {
		public NBSMSGO3 NBSMSGO3;
	}

	public class NBSAPLO {
		public Integer NBNAPLO_REASON_CODE;
		public Integer NBNAPLO_RETURN_CODE;
		public String NBNAPLO_SERVICE_VERSION;
    }

	public class GSB014O {
		public String GSB014O_PRIMARY_CLIENT;
		public Integer GSB014O_NO_OF_MEMBERS;
		public List<GSB014O_GROUP_DETAIL> GSB014O_GROUP_DETAIL;
		public String GSB014O_PART_OF_GROUP;
		public String GSB014O_ULT_PRIMARY_CLIENT;
	}

	public class GSB014O_GROUP_DETAIL {
		public String GSB014O_GROUP_MEMBER;
	}

	public class NBSMSGO3 {
		public Integer NBNMSGO3_NBR_USER_ERRS;
		public String NBSMSGO3_VERSION;
		public String NBNMSGO3_SYS_ERR_TXT;
		public Integer NBNMSGO3_NBR_USER_MSGS;
		public List<NBNMSGO3_MSG_ENTRY> NBNMSGO3_MSG_ENTRY;
	}

	public class NBNMSGO3_MSG_ENTRY {
		public String NBNMSGO3_MSG_ERR_IND;
		public String NBNMSGO3_MSG_TXT;
		public String NBNMSGO3_MSG_CLASS;
		public String NBNMSGO3_MSG_CODE;
	}
}