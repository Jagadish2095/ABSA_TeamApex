/** 
 * @description Response Integration Bean for MLgetAcctInfoforCUS1V1Service Service
 * @author Simangaliso Mathenjwa
 * @created 16 May 2021 
 * @updated Koketso Mpshane 08-06-2021
 */
public class MLgetAcctInfoCUS1V1_Resp_IB_v1 extends Base_IB {
    
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;

    @AuraEnabled public NBSAPDPO NBSAPDPO;
	@AuraEnabled public MLB854O MLB854O;
	@AuraEnabled public NBSMSGO3_Z NBSMSGO3;

    /**
	* @description NBSMSGO3_Z class
	*/
	public class NBSMSGO3_Z {
		@AuraEnabled public NBSMSGO3 NBSMSGO3;
	}

    /**
	* @description MLB854O_OUTPUT_AREA class
	*/
	public class MLB854O_OUTPUT_AREA {
		@AuraEnabled public Double MLB854O_FBT_RATE;
        @AuraEnabled public Double MLB854O_TOT_PAYMENT;
        @AuraEnabled public Double MLB854O_PRIME_ACCT_PAYMENT;
        @AuraEnabled public Double MLB854O_FLEXI_AVAIL_AMT;
        @AuraEnabled public Double MLB854O_CUR_ADVANCE_AMT;
        @AuraEnabled public String MLB854O_CUR_INT_RATE_TYPE;
		@AuraEnabled public String interestRateTypeTranslated;
        @AuraEnabled public Integer MLB854O_FLEXI_CODE;
        @AuraEnabled public Double MLB854O_NEW_PAYMENT;
        @AuraEnabled public String MLB854O_CLIENT_NAME;
        @AuraEnabled public List<MLB854O_FIXED_RATES> MLB854O_FIXED_RATES;
        @AuraEnabled public Double MLB854O_CUR_PAYMENT;
        @AuraEnabled public String MLB854O_DOC_NCA_IND;
        @AuraEnabled public Integer MLB854O_SCHM_CODE;
		@AuraEnabled public String schemaCodeTranslated;
        @AuraEnabled public Integer MLB854O_PRIME_ACCT_REM_TERM;
        @AuraEnabled public Long MLB854O_ACCT_NUMBER;
        @AuraEnabled public Integer MLB854O_CLIENT_TYPE;
        @AuraEnabled public Integer MLB854O_CUR_REM_TERM;
        @AuraEnabled public Double MLB854O_OUTS_BAL;
        @AuraEnabled public Integer MLB854O_MAX_REM_TERM;
        @AuraEnabled public Integer MLB854O_RETURN_CODE;
		@AuraEnabled public String returnCodeTranslated;
        @AuraEnabled public Double MLB854O_CUR_SERVICE_FEE;
        @AuraEnabled public List<MLB854O_SECONDARY_ACCTS> MLB854O_SECONDARY_ACCTS;
        @AuraEnabled public Double MLB854O_MBR_RATE;
        @AuraEnabled public String MLB854O_LANG_IND;
        @AuraEnabled public Integer MLB854O_REF_NUMBER;
        @AuraEnabled public Integer MLB854O_CUR_DUE_DAY;
        @AuraEnabled public String MLB854O_REWARDS_ID;
        @AuraEnabled public Double MLB854O_NEW_EST_PAYMENT;
        @AuraEnabled public Double MLB854O_PRIME_ACCT_INT_RATE;
        @AuraEnabled public Double MLB854O_SETTLEMENT_AMT;
        @AuraEnabled public Double MLB854O_PRIME_ACCT_BAL;
        @AuraEnabled public Double MLB854O_CUR_INT_RATE;
        @AuraEnabled public Long MLB854O_PRIME_ACCT_NUMBER;
        @AuraEnabled public String MLB854O_PRIME_ACCT_ID;
        @AuraEnabled public Double MLB854O_MAX_REM_TERM_PAYMENT;
	}

    /**
	* @description NBSAPLO class
	*/
	public class NBSAPLO {
		@AuraEnabled public Integer NBNAPLO_REASON_CODE;
		@AuraEnabled public Integer NBNAPLO_RETURN_CODE;
		@AuraEnabled public String NBNAPLO_SERVICE_VERSION;
	}

    /**
	* @description NBSAPDPO class
	*/
	public class NBSAPDPO {
		@AuraEnabled public NBSAPLO NBSAPLO;
	}

    /**
	* @description MLB854O class
	*/
	public class MLB854O {
		@AuraEnabled public MLB854O_OUTPUT_AREA MLB854O_OUTPUT_AREA;
	}

    /**
	* @description MLB854O_FIXED_RATES class
	*/
	public class MLB854O_FIXED_RATES {
		@AuraEnabled public Double MLB854O_FIXEDRATE_EST_PAYMENTS;
		@AuraEnabled public Integer MLB854O_FIXED_RATE_COUNT;
		@AuraEnabled public Integer MLB854O_FIXED_RATE_TERM;
		@AuraEnabled public Double MLB854O_FIXED_RATE_OFFERED;
	}

    /**
	* @description NBSMSGO3 class
	*/
	public class NBSMSGO3 {
		@AuraEnabled public Integer NBNMSGO3_NBR_USER_ERRS;
		@AuraEnabled public String NBSMSGO3_VERSION;
		@AuraEnabled public String NBNMSGO3_SYS_ERR_TXT;
		@AuraEnabled public Integer NBNMSGO3_NBR_USER_MSGS;
		@AuraEnabled public List<NBNMSGO3_MSG_ENTRY> NBNMSGO3_MSG_ENTRY;
	}

    /**
	* @description MLB854O_SECONDARY_ACCTS class
	*/
	public class MLB854O_SECONDARY_ACCTS {
		@AuraEnabled public Integer MLB854O_SEC_ACCT_REM_TERM;
		@AuraEnabled public String MLB854O_SEC_ACCT_ID;
		@AuraEnabled public Double MLB854O_SEC_ACCT_BAL;
		@AuraEnabled public Double MLB854O_SEC_ACCT_PAYMENT;
		@AuraEnabled public Double MLB854O_SEC_ACCT_INT_RATE;
		@AuraEnabled public Long MLB854O_SEC_ACCT_NUMBER;
	}

    /**
	* @description NBNMSGO3_MSG_ENTRY class
	*/
	public class NBNMSGO3_MSG_ENTRY {
		@AuraEnabled public String NBNMSGO3_MSG_ERR_IND;
		@AuraEnabled public String NBNMSGO3_MSG_TXT;
		@AuraEnabled public String NBNMSGO3_MSG_CLASS;
		@AuraEnabled public String NBNMSGO3_MSG_CODE;
	}
}