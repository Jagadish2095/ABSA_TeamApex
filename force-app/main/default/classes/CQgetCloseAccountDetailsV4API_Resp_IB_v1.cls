/**

 * @description

 * @Author: Mbuyiseni Mbhokane
 * @Since: 21/10/2020
 */
public class CQgetCloseAccountDetailsV4API_Resp_IB_v1 extends Base_IB{

    public NBSAPDPO NBSAPDPO;
	public CQS534O CQS534O;
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
	public class CQS534O_TABLE_I {
		public List<CQS534O_LINE_I> CQS534O_LINE_I;
	}
    /**
    * @description
	*/

	public class CQS534O {
		public String CQS534O_CHQDEP_BOOKS;
		public String CQS534O_REDIRECTINDI;
		public String CQS534O_DR_INT_CLS;
		public String CQS534O_DIVISION_I;
		public String CQS534O_CURRENT_BAL;
		public String CQS534O_CLIENT_TITL_INIT_SNAME;
		public String CQS534O_BLACKLISTED_CHQS;
		public String CQS534O_POSTDATED_TRAN;
		public String CQS534O_CHEQIMAGESTATEMENTS;
		public String CQS534O_CLOSURE_AMTS;
		public String CQS534O_ACCOUNT_NBR_OUT;
		public CQS534O_TABLE_I CQS534O_TABLE_I;
		public String CQS534O_BOM_SPONSORED_AMT;
		public String CQS534O_OVERDRAFT;
		public String CQS534O_1DAYPAAF_TOT;
		public String CQS534O_NXT_STATMNT_DATE;
		public String CQS534O_UNCLEARED_CHQS;
		public String CQS534O_ACCOUNT_NAME;
		public String CQS534O_WAP_HOLD_IND;
		public String CQS534O_CR_INT_CLS;
		public String CQS534O_STATCOLLECTIONPREF;
		public String CQS534O_IB_CB_FEES;
		public String CQS534O_PROCESSING_SITE_OUT;
		public String CQS534O_HOLDS_COUNTER;
		public String CQS534O_MARKED_CHQS;
		public String CQS534O_ACCOUNT_TYPE;
		public String CQS534O_AFF_INTEREST_TO_SWEEP;
		public String CQS534O_STATEMENT_FREQ;
		public String CQS534O_AUTHORIZATION_HOLDS;
		public String CQS534O_OUTSTANDING_CHRGS;
		public String CQS534O_LDP_HOLD_IND;
		public String CQS534O_REVOLVING_DORD;
		public String CQS534O_RETURNED_CHQS;
		public String CQS534O_EFFECTIVE_CLSD_DATE;
		public String CQS534O_AUTH_OFFLINE_AMT;
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
	public class CQS534O_LINE_I {
		public String CQS534O_ACCOUNT_HOLDS;
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
	* @return CQgetCloseAccountDetailsV4API_Resp_IB_v1 
	**/
	

	public static CQgetCloseAccountDetailsV4API_Resp_IB_v1 createDummyResponse() {
        CQgetCloseAccountDetailsV4API_Resp_IB_v1 responseBean = new CQgetCloseAccountDetailsV4API_Resp_IB_v1();
        responseBean.NBSAPDPO = new CQgetCloseAccountDetailsV4API_Resp_IB_v1.NBSAPDPO();
        responseBean.NBSMSGO3 = new CQgetCloseAccountDetailsV4API_Resp_IB_v1.NBSMSGO3();
        responseBean.CQS534O = new CQgetCloseAccountDetailsV4API_Resp_IB_v1.CQS534O();
        responseBean.CQS534O.CQS534O_TABLE_I = new CQgetCloseAccountDetailsV4API_Resp_IB_v1.CQS534O_TABLE_I();
        CQgetCloseAccountDetailsV4API_Resp_IB_v1.NBNMSGO3_MSG_ENTRY msgEntry = new CQgetCloseAccountDetailsV4API_Resp_IB_v1.NBNMSGO3_MSG_ENTRY();
        List<CQgetCloseAccountDetailsV4API_Resp_IB_v1.NBNMSGO3_MSG_ENTRY> msgEntryList = new List<CQgetCloseAccountDetailsV4API_Resp_IB_v1.NBNMSGO3_MSG_ENTRY>();
        CQgetCloseAccountDetailsV4API_Resp_IB_v1.CQS534O_LINE_I lineBean = new CQgetCloseAccountDetailsV4API_Resp_IB_v1.CQS534O_LINE_I();
        List<CQgetCloseAccountDetailsV4API_Resp_IB_v1.CQS534O_LINE_I> lineBeanList = new List<CQgetCloseAccountDetailsV4API_Resp_IB_v1.CQS534O_LINE_I>();

        responseBean.NBSAPDPO.NBNAPLO_REASON_CODE = '0';
        responseBean.NBSAPDPO.NBNAPLO_RETURN_CODE = '0';
        responseBean.NBSAPDPO.NBNAPLO_SERVICE_VERSION = 'BUSO003';

        msgEntry.NBNMSGO3_MSG_CLASS = '';
        msgEntry.NBNMSGO3_MSG_CODE = '';
        msgEntry.NBNMSGO3_MSG_ERR_IND = '';
        msgEntry.NBNMSGO3_MSG_TXT = '';
        msgEntryList.add(msgEntry);

        responseBean.NBSMSGO3.NBNMSGO3_MSG_ENTRY = msgEntryList;
        responseBean.NBSMSGO3.NBNMSGO3_NBR_USER_ERRS = '0';
        responseBean.NBSMSGO3.NBNMSGO3_NBR_USER_MSGS = '0';
        responseBean.NBSMSGO3.NBNMSGO3_SYS_ERR_TXT = '';
        responseBean.NBSMSGO3.NBSMSGO3_VERSION = 'MSG3001';

        lineBean.CQS534O_ACCOUNT_HOLDS = 'HIGH RISK';
        lineBeanList.add(lineBean);

        responseBean.CQS534O.CQS534O_CHQDEP_BOOKS = 'N';
		responseBean.CQS534O.CQS534O_REDIRECTINDI = '';
		responseBean.CQS534O.CQS534O_DR_INT_CLS = '0.00';
		responseBean.CQS534O.CQS534O_DIVISION_I = 'ABS';
		responseBean.CQS534O.CQS534O_CURRENT_BAL = '99470.06';
		responseBean.CQS534O.CQS534O_CLIENT_TITL_INIT_SNAME = 'MR H NGCOBO';
		responseBean.CQS534O.CQS534O_BLACKLISTED_CHQS = '0.00';
		responseBean.CQS534O.CQS534O_POSTDATED_TRAN = '0.00';
		responseBean.CQS534O.CQS534O_CHEQIMAGESTATEMENTS = 'N';
		responseBean.CQS534O.CQS534O_CLOSURE_AMTS = '98773.20';
		responseBean.CQS534O.CQS534O_ACCOUNT_NBR_OUT = '4048382672';
		responseBean.CQS534O.CQS534O_TABLE_I.CQS534O_LINE_I = lineBeanList;
		responseBean.CQS534O.CQS534O_BOM_SPONSORED_AMT = '0.00';
		responseBean.CQS534O.CQS534O_OVERDRAFT = '0.00';
		responseBean.CQS534O.CQS534O_1DAYPAAF_TOT = '0.00';
		responseBean.CQS534O.CQS534O_NXT_STATMNT_DATE = '20200918';
		responseBean.CQS534O.CQS534O_UNCLEARED_CHQS = '0.00';
		responseBean.CQS534O.CQS534O_ACCOUNT_NAME = 'NGCOBO';
		responseBean.CQS534O.CQS534O_WAP_HOLD_IND = 'N';
		responseBean.CQS534O.CQS534O_CR_INT_CLS = '65.07';
		responseBean.CQS534O.CQS534O_STATCOLLECTIONPREF = 'P';
		responseBean.CQS534O.CQS534O_IB_CB_FEES = '0.00';
		responseBean.CQS534O.CQS534O_PROCESSING_SITE_OUT = '8198';
		responseBean.CQS534O.CQS534O_HOLDS_COUNTER = '3';
		responseBean.CQS534O.CQS534O_MARKED_CHQS = '0.00';
		responseBean.CQS534O.CQS534O_ACCOUNT_TYPE = '3';
		responseBean.CQS534O.CQS534O_AFF_INTEREST_TO_SWEEP = '0.00';
		responseBean.CQS534O.CQS534O_STATEMENT_FREQ = '1';
		responseBean.CQS534O.CQS534O_AUTHORIZATION_HOLDS = '0.00';
		responseBean.CQS534O.CQS534O_OUTSTANDING_CHRGS = '0.00';
		responseBean.CQS534O.CQS534O_LDP_HOLD_IND = 'N';
		responseBean.CQS534O.CQS534O_REVOLVING_DORD = 'N';
		responseBean.CQS534O.CQS534O_RETURNED_CHQS = '0.00';
		responseBean.CQS534O.CQS534O_EFFECTIVE_CLSD_DATE = '20201020';
		responseBean.CQS534O.CQS534O_AUTH_OFFLINE_AMT = ' 0.00';
        

		return responseBean;
	}
}