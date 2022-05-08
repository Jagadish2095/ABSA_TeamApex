/*
 * Resp Bean for GBGetContBranchDetV1_Req_IB_v1 Service
 * @author Saurabh Pandey
 * @created 2020-09-21
 */

public class GBGetContBranchDetV1_Resp_IB_v1 extends Base_IB{
    
	public class GSB021O {
		public String GSB021O_BUSINESS_SUB_SEG;
		public Integer GSB021O_OVER_CONT_OFF_NUM;
		public String GSB021O_BUSINESS_SEG;
		public String GSB021O_AGRI_CLIENT;
		public Integer GSB021O_DATE_APPROVED;
		public Integer GSB021O_CONTROL_BRANCH;
		public Integer GSB021O_CAP_BY_EMPLOYEE;
		public Integer GSB021O_GROUP_REVIEW_DATE;
		public Integer GSB021O_CONT_OFF_NUM;
		public String GSB021O_STATUS;
		public String GSB021O_BANKING_SECTOR;
		public Integer GSB021O_OVERALL_CONTROL;
		public String GSB021O_CONT_OFF_TYPE;
		public Integer GSB021O_FRANCHISOR_CODE;
		public Integer GSB021O_DATE_CREATED;
		public String GSB021O_FRANCH_CODE_DESC;
		public String GSB021O_OVER_CONT_OFF_TYP;
		public Integer GSB021O_BANK_SECTOR_CODE;
		public Integer GSB021O_APP_BY_EMPLOYEE;
		public String GSB021O_INDV_GROUP;
		public String GSB021O_DIVISION_CODE;
		public String GSB021O_SQL_MESS_CODE;
		public String GSB021O_LAST_ACTION;
		public String GSB021O_EXPOSURE_POLICY;
	}

	public GSB021O_Z GSB021O;
	public NBSAPDPO NBSAPDPO;
	public NBSMSGO3_Z NBSMSGO3;

	public class NBSMSGO3_Z {
		public NBSMSGO3 NBSMSGO3;
	}

	public class NBSAPLO {
		public Integer returnCode;
		public String outputServiceVersion;
		public Integer reasonCode;
	}

	public class NBSAPDPO {
		public NBSAPLO NBSAPLO;
	}

	public class GSB021O_Z {
		public GSB021O GSB021O;
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