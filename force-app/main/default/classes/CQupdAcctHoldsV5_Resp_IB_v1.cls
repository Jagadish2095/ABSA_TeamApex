/*
* Request Integration Bean for CQupdAcctHoldsV5 Service
* @author Satya Boyenepalli
* @created 2020-12-08
*/

public class CQupdAcctHoldsV5_Resp_IB_v1  extends Base_IB  {
	public NBSAPDPO NBSAPDPO;
	public CQS525O CQS525O;
	public NBSMSGO3 NBSMSGO3;

	public class OutputCopybook {
		public Integer CQN525O_ACCOUNT_NBR_OUT;
		public List<CQN525O_CONFIRMATION_DETAILS> CQN525O_CONFIRMATION_DETAILS;
	}

	public class CQN525O_CONFIRMATION_DETAILS {
		public String CQN525O_DETAILS;
	}

	public class NBSAPDPO {
		public OutputHeader outputHeader;
	}

	public class CQS525O {
		public OutputCopybook outputCopybook;
	}

	public class OutputHeader {
		public String NBNAPLO_ECHO_KEY;
		public Integer NBNAPLO_REASON_CODE;
		public Integer NBNAPLO_RETURN_CODE;
		public String NBNAPLO_VERSION;
		public String NBNAPLO_SERVICE_VERSION;
	}

	public class NBSMSGO3 {
		public OutputErrorMessage outputErrorMessage;
	}

	public class Cqupdate_respone {
		public NBSAPDPO NBSAPDPO;
		public CQS525O CQS525O;
		public NBSMSGO3 NBSMSGO3;
	}

	public class OutputErrorMessage {
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