/**

 * @description Response Integration Bean for CQUpdClosureDetailsV1 services

 * @Author: Mbuyiseni Mbhokane
 * @Since: 13/11/2020
 */
public class CQUpdClosureDetailsV1_Resp_IB_v1 extends Base_IB{
   
    public NBSAPDPO NBSAPDPO;
	public CQS960O CQS960O;
	public NBSMSGO3 NBSMSGO3;


	/**
    * @description
	*/


	public class NBSAPDPO {
		public String NBNAPLO_REASON_CODE;
		public String NBNAPLO_RETURN_CODE;
		public String NBNAPLO_SERVICE_VERSION;
	}

	/**
    * @description
	*/


	public class CQS960O {
		public String CQN960O_CLOS_REASON;
		public String CQN960O_ABAL;
		public String CQN960O_STATUS;
		public String CQN960O_AVBL;
		public String CQS960O_ACCOUNT_NUMBER;
	}

    /**
    * @description
	*/

	public class NBSMSGO3 {
		public String NBNMSGO3_NBR_USER_ERRS;
		public String NBSMSGO3_VERSION;
		public String NBNMSGO3_SYS_ERR_TXT;
		public String NBNMSGO3_NBR_USER_MSGS;
		public List<NBNMSGO3_MSG_ENTRY> NBNMSGO3_MSG_ENTRY;
	}

    /**
    * @description
	*/

	public class NBNMSGO3_MSG_ENTRY {
		public String NBNMSGO3_MSG_ERR_IND;
		public String NBNMSGO3_MSG_TXT;
		public String NBNMSGO3_MSG_CLASS;
		public String NBNMSGO3_MSG_CODE;
	}
	

	/**
	* @description 
	* @author muvhuso.nekhubvi@absa.africa | 2021-08-04 
	* @return CQUpdClosureDetailsV1_Resp_IB_v1 
	**/

	public static CQUpdClosureDetailsV1_Resp_IB_v1 createDummyResponse() {
        CQUpdClosureDetailsV1_Resp_IB_v1 responseBean = new CQUpdClosureDetailsV1_Resp_IB_v1();
        responseBean.NBSAPDPO = new CQUpdClosureDetailsV1_Resp_IB_v1.NBSAPDPO();
        responseBean.NBSMSGO3 = new CQUpdClosureDetailsV1_Resp_IB_v1.NBSMSGO3();
        responseBean.CQS960O = new CQUpdClosureDetailsV1_Resp_IB_v1.CQS960O();
        CQUpdClosureDetailsV1_Resp_IB_v1.NBNMSGO3_MSG_ENTRY msgEntry = new CQUpdClosureDetailsV1_Resp_IB_v1.NBNMSGO3_MSG_ENTRY();
        List<CQUpdClosureDetailsV1_Resp_IB_v1.NBNMSGO3_MSG_ENTRY> msgEntries = new List<CQUpdClosureDetailsV1_Resp_IB_v1.NBNMSGO3_MSG_ENTRY>();

        responseBean.NBSAPDPO.NBNAPLO_REASON_CODE = '0';
        responseBean.NBSAPDPO.NBNAPLO_RETURN_CODE = '0';
        responseBean.NBSAPDPO.NBNAPLO_SERVICE_VERSION = 'BUSO001';
        msgEntry.NBNMSGO3_MSG_CLASS = 'CQSMGC01';
        msgEntry.NBNMSGO3_MSG_CODE = '0008';
        msgEntry.NBNMSGO3_MSG_ERR_IND = 'E';
        msgEntry.NBNMSGO3_MSG_TXT = 'Invalid account number - account does not exist';
        msgEntries.add(msgEntry);
        responseBean.NBSMSGO3.NBNMSGO3_MSG_ENTRY = msgEntries;
        responseBean.NBSMSGO3.NBNMSGO3_NBR_USER_ERRS = '1';
        responseBean.NBSMSGO3.NBNMSGO3_NBR_USER_MSGS = '1';
        responseBean.NBSMSGO3.NBNMSGO3_SYS_ERR_TXT = '';
        responseBean.NBSMSGO3.NBSMSGO3_VERSION = 'MSG3001';
        responseBean.CQS960O.CQN960O_ABAL = '0.00';
        responseBean.CQS960O.CQN960O_AVBL = '0.00';
        responseBean.CQS960O.CQN960O_CLOS_REASON = '';
        responseBean.CQS960O.CQN960O_STATUS = '';
        responseBean.CQS960O.CQS960O_ACCOUNT_NUMBER = '0';
		return responseBean;
	}
}