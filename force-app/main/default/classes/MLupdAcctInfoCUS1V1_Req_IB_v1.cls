/** 
 * @description Request Integration Bean for MLupdAcctInfoforCUS1V1Service Service
 * @author Simangaliso Mathenjwa
 * @created 16 May 2021 
 */
public  class MLupdAcctInfoCUS1V1_Req_IB_v1 extends Base_IB {
    public NBSAPDPI NBSAPDPI;
	public NBSMSGI_Z NBSMSGI;
	public MLB855I MLB855I;

	/**
	* @description NBSMSGI_Z class
	*/
    public class NBSMSGI_Z {
		public NBSMSGI NBSMSGI;
	}

	/**
	* @description MLB855I class
	*/
	public class MLB855I {
		public MLB855I_INPUT_AREA MLB855I_INPUT_AREA;
	}

	/**
	* @description MLB855I_SECONDARY_ACCTS class
	*/
	public class MLB855I_SECONDARY_ACCTS {
		public String MLB855I_SEC_ACCT_ID;
		public Long MLB855I_SEC_ACCT_NUMBER;
	}

	/**
	* @description MLB855I_INPUT_AREA class
	*/
	public class MLB855I_INPUT_AREA {
		public Long MLB855I_ACCT_NUMBER;
		public String MLB855I_USER_ID;
		public String MLB855I_SITE_CODE;
		public Integer MLB855I_REF_NUMBER;
		public String MLB855I_REQ_TYPE;
		public Double MLB855I_SCHM_CODE;
		public String MLB855I_PRIME_ACCT_ID;
		public Long MLB855I_PRIME_ACCT_NUMBER;
		public List<MLB855I_SECONDARY_ACCTS> MLB855I_SECONDARY_ACCTS;
		public Integer MLB855I_APPROV_RATE_CON;
		public Integer MLB855I_APPROV_RATE_EFF_DATE;
		public Integer MLB855I_ACCEPT_FIXED_RATE;
		public Integer MLB855I_ACCEPT_FIXED_RATE_TERM;
		public Integer MLB855I_NEW_REQ_REM_TERM;
		public String MLB855I_RECALC_REPAY_IND;
		public Integer MLB855I_REDUCE_AMT_BY;
		public Integer MLB855I_NEW_PAYMENT_DUE_DAY;
		public Integer MLB855I_NEW_MONTHLY_SERV_FEE;
		public String MLB855I_REWARDS_ID;
	}

	/**
	* @description NBSMSGI class
	*/
	public class NBSMSGI {
		public String NBNMSGI_MSG_LANGUAGE;
		public String NBNMSGI_MSG_TARGET;
	}

	/**
	* @description NBSAPLI class
	*/
	public class NBSAPLI {
		public String NBNAPLI_CHANNEL;
		public String NBNAPLI_APPLICATION;
		public String NBNAPLI_TRACE;
	}

	/**
	* @description NBSAPDPI class
	*/
	public class NBSAPDPI {
		public NBSAPLI NBSAPLI;
	}

    /**
	* @description method to create dummy request
    * @return requestBean
	*/
    public static MLupdAcctInfoCUS1V1_Req_IB_v1 createDummyRequest() {
        MLupdAcctInfoCUS1V1_Req_IB_v1 requestBean = new MLupdAcctInfoCUS1V1_Req_IB_v1();
        requestBean.NBSAPDPI = new MLupdAcctInfoCUS1V1_Req_IB_v1.NBSAPDPI();
        requestBean.NBSAPDPI.NBSAPLI = new MLupdAcctInfoCUS1V1_Req_IB_v1.NBSAPLI();
        requestBean.NBSMSGI = new MLupdAcctInfoCUS1V1_Req_IB_v1.NBSMSGI_Z();
        requestBean.NBSMSGI.NBSMSGI = new MLupdAcctInfoCUS1V1_Req_IB_v1.NBSMSGI();
        requestBean.MLB855I = new MLupdAcctInfoCUS1V1_Req_IB_v1.MLB855I();
        requestBean.MLB855I.MLB855I_INPUT_AREA = new MLupdAcctInfoCUS1V1_Req_IB_v1.MLB855I_INPUT_AREA();
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_CHANNEL ='API';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_APPLICATION ='Gateway';
        requestBean.NBSAPDPI.NBSAPLI.NBNAPLI_TRACE ='';
        requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_LANGUAGE= 'E';
        requestBean.NBSMSGI.NBSMSGI.NBNMSGI_MSG_TARGET= 'STD';
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_ACCT_NUMBER= long.valueOf('8050306640');
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_USER_ID = 'ABGE081';
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_SITE_CODE = '';
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_REF_NUMBER = 12;
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_REQ_TYPE = 'DUE';
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_SCHM_CODE = 1.5;
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_PRIME_ACCT_ID = 'P001';
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_PRIME_ACCT_NUMBER = long.valueOf('8050306640');
        requestBean.MLB855I.MLB855I_INPUT_AREA.MLB855I_NEW_PAYMENT_DUE_DAY = 25;

        return requestBean;

    }
}