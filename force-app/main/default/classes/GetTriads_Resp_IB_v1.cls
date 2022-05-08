/*
 * Response Bean for Triad Service
 * @author Almas Aleem
 * @created 2020-09-16
 */

public class GetTriads_Resp_IB_v1 extends Base_IB{
	@AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    
    public class TRC519O_OUTPUT_PROCESS_RESULTS {
		public Integer TRC519O_RETURN_CODE;
	}

	public class TRC519O_OUTPUT_DATA {
		public Integer TRC519O_AGE_CUST_RELATIONSHIP;
		public Integer TRC519O_LIMIT_ACCL;
		public Integer TRC519O_TOT_VAL_CREDITS_L6M;
		public String TRC519O_TRIAD_EXCL_REASON;
		public String TRC519O_DATE_OPEN_OLDEST_SAV;
		public Double TRC519O_AVG_CTO_L3M_L6M;
		public Integer TRC519O_BEH_SCORE_AVAF;
		public Integer TRC519O_NUM_MTS_EXS_L6M;
		public String TRC519O_DATE_OPEN_OLDEST_CHQ;
		public Integer TRC519O_LIMIT_ABRA;
		public Integer TRC519O_LIMIT_AMMR;
		public String TRC519O_DATE_CUST_REL;
		public Integer TRC519O_BEH_SCORE_LOANS;
		public Integer TRC519O_MAX_CONSEQ_DAYS_EXS;
		public String TRC519O_TRIAD_EXCLUSION;
		public Integer TRC519O_NUM_CHQ_RD_L6M;
		public Integer TRC519O_BEH_SCORE_CHQ;
		public Integer TRC519O_VAL_SAV_RET_PYMNT_L6M;
		public Integer TRC519O_LIMIT_CAPPED_AOL;
		public Integer TRC519O_NUM_SAV_RD_L3M;
		public Integer TRC519O_NUM_SAV_RD_L6M;
		public Integer TRC519O_DAYS_IN_CREDIT_CHQ_L6M;
		public Integer TRC519O_AGE_CHQ_RELATIONSHIP;
		public Integer TRC519O_CFAC_EXCLUSION_REASON;
		public Integer TRC519O_LIMIT_AMLR;
		public Integer TRC519O_TOT_VAL_DEBITS_L6M;
		public Integer TRC519O_DAYS_IN_DEBIT_CHQ_L6M;
		public Integer TRC519O_BEH_SCORE_CARD;
		public Integer TRC519O_EXP_CREDIT_TURNOVER_CU;
		public Integer TRC519O_AGE_SAV_RELATIONSHIP;
		public Integer TRC519O_MAX_ORD_CRED_EXPOSURE;
		public Integer TRC519O_VAL_CHQ_RET_PYMNT_L6M;
		public Integer TRC519O_EXP_CREDIT_TURNOVER_CQ;
		public Integer TRC519O_LIMIT_AOL;
		public Integer TRC519O_AGE_ACC_RELATIONSHIP;
		public Integer TRC519O_CUST_ALIGN_SCORE;
		public String TRC519O_PROT_NCA;
		public String TRC519O_CFAC_EXCLUSION;
		public Double TRC519O_AVG_CTO_L6M_L12M;
		public String TRC519O_DATE_OPEN_OLDEST_ACC;
		public Integer TRC519O_LIMIT_AMR;
		public Integer TRC519O_NUM_CHQ_RD_L3M;
		public List<TRC519O_COND_ACCOUNT_DETAILS> TRC519O_COND_ACCOUNT_DETAILS;
		public Integer TRC519O_BEH_SCORE_MLOAN;
	}

	public TRC519O TRC519O;
	public NBSAPDPO NBSAPDPO;

	public class TRC519O {
		public TRC519O_OUTPUT_PROCESS_RESULTS TRC519O_OUTPUT_PROCESS_RESULTS;
		public TRC519O_OUTPUT_DATA TRC519O_OUTPUT_DATA;
	}

	public class NBSAPLO {
		public Integer NBNAPLO_REASON_CODE;
		public Integer NBNAPLO_RETURN_CODE;
		public String NBNAPLO_SERVICE_VERSION;
	}

	public class NBSAPDPO {
		public NBSAPLO NBSAPLO;
	}

	public class TRC519O_COND_ACCOUNT_DETAILS {
		public Integer TRC519O_COND_ACC_VAL_DP_RETPY;
		public Integer TRC519O_COND_ACC_VAL_CQ_RETPY;
		public Integer TRC519O_COND_ACC_MIN_BAL;
		public Integer TRC519O_COND_ACC_DAYS_EXCESS;//Excess
		public Integer TRC519O_COND_ACC_DR_TURNOVER;
		public Integer TRC519O_COND_ACC_AVG_BAL;
		public Integer TRC519O_COND_ACC_CR_TURNOVER;
		public Integer TRC519O_COND_ACC_TOT_LIMIT;
		public Integer TRC519O_COND_ACC_NUM_DR_SAV;//number of debits deposit value
		public Integer TRC519O_COND_ACC_NUM_CQ_RD_EV;//cheque rd event 
		public Integer TRC519O_COND_CLNT_RISK_GRADE;
		public Integer TRC519O_COND_ACC_HIGH_LIMIT;
		public Integer TRC519O_COND_ACC_DAYS_DR_CHQ;//Debit
		public Integer TRC519O_COND_ACC_NUM_DP_RD_EV;//savings rd event 
		public Integer TRC519O_COND_ACC_MAX_BAL;
		public Integer TRC519O_COND_ACC_NUM_DR_CHQ; //number of debits cheque value
		public Integer TRC519O_COND_NO_OPEN_CQ_ACC;//No of Accounts
		public Integer TRC519O_COND_ACC_DAYS_CR_CHQ;//Credit
	}
}