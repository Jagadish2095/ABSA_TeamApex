/**
 * @description Response Integration Bean for Retreive Account PageList Service
 * @author manideep kenche
 * @created 2021-08-20
 */
public class RetreiveAccountPageList_Resp_IB_v1 extends Base_IB{
	public Integer total;	//1
	public String status;	//success
	public list<data> data;
/**
 * @description data
 */
	class data {
		public consumerAccountIdentifier consumerAccountIdentifier;
		public String tableName;	//GENERAL
		public Integer rowId;	//54807
		public long lastUpdated;	//1628979538223
		public userDefinedData userDefinedData;
		public Integer version;	//10
		public String businessKey;	//54807
	}
/**
 * @description consumerAccountIdentifier
 */
	class consumerAccountIdentifier {
		public Integer consumerAccountAgencyIdentifier;	//170221501
		public string creditorReferenceNumber;	//XXXXXX 001
		public string creditorAccountLegacyIdentifier;	//0000000077091128
		public String creditorExternalAccountId;	//
		public String businessKey;	//170221501
	}

/**
 * @description userDefinedData
 */
	public class userDefinedData {
        public integer UDEFNDD;	//230
        
		/* public String UDEFACCOUNT_TYPE;	//FCR
		public String UDEFACC_CORP_CODE;	//FSA
		public object UDEFACC_OPENED_DT;	//1494021600000
		public Integer UDEFAMT_MEMO_INT;	//0
		public Double UDEFAMT_PAST_DUE;	//8980.83
		public Integer UDEFAVAIL_CR_LN;	//0
		public Integer UDEFBILL_CYCLE;	//0
		public object UDEFBND_ACC_COMENC_DT;	//-2208996000000
		public object UDEFBND_ACC_PD_OUT_DT;	//-2208996000000
		public String UDEFBRAP;	//N
		public object UDEFCARD_EXP_DT;	//1653256800000
		public String UDEFCC_LEGAL_NR;	//
		public String UDEFCC_PLASTIC_NUM;	//
		public String UDEFCORP_CODE;	//FSA
		public String UDEFCREDIT_LIFE_IND;	//N
		public Integer UDEFCURR_CR_LN;	//0
		public String UDEFCYCLE120;	//
		public Integer UDEFCYCLE120DLQ;	//0
		public String UDEFCYCLE150;	//
		public Integer UDEFCYCLE150DLQ;	//0
		public String UDEFCYCLE180;	//
		public Integer UDEFCYCLE180DLQ;	//0
		public String UDEFCYCLE210;	//
		public Integer UDEFCYCLE210DLQ;	//0
		public String UDEFCYCLE30;	//
		public Integer UDEFCYCLE30DLQ;	//0
		public String UDEFCYCLE5;	//
		public Integer UDEFCYCLE5DLQ;	//0
		public String UDEFCYCLE60;	//
		public Integer UDEFCYCLE60DLQ;	//0
		public String UDEFCYCLE90;	//
		public Integer UDEFCYCLE90DLQ;	//0
		public String UDEFDEBIT_ORD_IND;	//N
		public Integer UDEFDELINQUENT_CYCLE;	//0
		public String UDEFDIV;	//05
		public String UDEFDM_OWNER;	//Y
		public String UDEFDORMANCY_INACT;	//
		public object UDEFDT_LAST_CURRENT;	//-2208996000000
		public object UDEFDT_LAST_STATUS_CHANGE;	//-2208996000000
		public String UDEFDUAL_NUM;	//
		public String UDEFFIID_CODE;	//
		public Integer UDEFFUTURE_INST_AMT;	//0
		public object UDEFFUTURE_INST_DT;	//-2208996000000
		public String UDEFGL_ACCOUNT_TYPE;	//FCR
		public String UDEFGUARANTEES;	//N
		public Integer UDEFGUARANT_AMT;	//0
		public String UDEFHAS_OVERDRAFT;	//N
		public String UDEFHOC;	//
		public String UDEFIIS_IND;	//Y
		public String UDEFINDEMNITY_IND_S06;	//
		public Integer UDEFINSTAL_PREV_AMT;	//0
		public object UDEFINSTL_PREV_DT;	//-2208996000000
		public Integer UDEFINST_AMT;	//0
		public object UDEFINST_CHNG_DT;	//-2208996000000
		public object UDEFINST_DT;	//-2208996000000
		public Double UDEFINT_RATE;	//19.54
		public object UDEFINT_RATE_EFF_DT;	//-2208996000000
		public object UDEFLAST_BROKEN_PTP_DATE;	//-2208996000000
		public object UDEFLAST_PAYMENT_DT;	//-2208996000000
		public Integer UDEFLAST_PYMT_AMT;	//0
		public String UDEFLOSS_GRADE;	//00
		public Integer UDEFLTV;	//0
		public Integer UDEFMAX_BAL_BREAK;	//0
		public Integer UDEFMIN_BAL_BREAK;	//0
		public Integer UDEFMOB;	//0
		
		public Integer UDEFNDD_IN_CYCLE;	//6
		public Integer UDEFNID;	//2
		public Integer UDEFNR_TIMES_OVERLINE;	//0
		public Integer UDEFNUM_CONSEC_BRK_PTP;	//2
		public Integer UDEFNUM_OF_TENANTS;	//0
		public Integer UDEFNUM_PTP_BROKEN_CCC;	//2
		public Integer UDEFNUM_PTP_BROKEN_LF;	//2
		public String UDEFORG_BND_RMN_TRM;	//009
		public String UDEFORG_BND_TRM;	//060
		public Double UDEFORIGINAL_BAL;	//-240236.4
		public String UDEFOVERDRAFT_250;	//N
		public String UDEFOVERDRAFT_DESC;	//NA
		public Integer UDEFOVERDRAFT_INT;	//0
		public Integer UDEFOVERDRAFT_LIMIT;	//0
		public object UDEFOVERDRAFT_REDUCTION_DT;	//-2208996000000
		public String UDEFOVERDRAFT_TYPE;	//NA
		public Integer UDEFOVERLINE_AMT;	//0
		public object UDEFOVERLINE_APPR_DT;	//-2208996000000
		public Integer UDEFOVER_LIMIT_PERC;	//0
		public Integer UDEFOVER_LIMIT_TOT;	//0
		public String UDEFPCF;	//N
		public Integer UDEFPREV_DAY_DLQ_BALANCE;	//0
		public Integer UDEFPREV_DELINQUENT_CYCLE;	//0
		public object UDEFPREV_DELINQUENT_CYCLE_DT;	//-2208996000000
		public Integer UDEFPREV_NDD;	//0
		public object UDEFPREV_NDD_DT;	//1609539459397
		public Integer UDEFPREV_NID;	//0
		public object UDEFPREV_NID_DT;	//1609625338060
		public String UDEFPREV_RISK_TYPE;	//DLQ
		public object UDEFPREV_RISK_TYPE_DT;	//1609625338060
		public String UDEFPREV_STATUS_CODE;	//
		public String UDEFPREV_TRIAD_EXCL_CODE;	//
		public String UDEFPREV_TRIAD_POOL;	//
		public object UDEFPREV_TRIAD_POOL_DT;	//1628979405183
		public Integer UDEFRDN;	//4
		public Double UDEFREQUIRED_AMT;	//13548.11
		public String UDEFRGN_CODE;	//
		public String UDEFRISK_TYPE;	//LEG
		public String UDEFSBU;	//03
		public Double UDEFSETTLEMENT_AMT;	//47855.1
		public object UDEFSETTLEMENT_DT;	//-2208996000000
		public object UDEFSHORT_TERM_PLAN_DATE;	//-2208996000000
		public String UDEFSITE;	//005314
		public String UDEFSITE_SHRTN_AFR;	//PSI GAUTENG EAST REGIONAL
		public String UDEFSITE_SHRTN_ENG;	//PSI GAUTENG EAST REGIONAL
		public String UDEFSTATUS_CODE;	//
		public Integer UDEFSTP_AMT;	//0
		public object UDEFSTP_EXP_DT;	//-2208996000000
		public Integer UDEFTOT_INSTL;	//0
		public String UDEFTRIAD_BEHAV_SCORE;	//0
		public String UDEFTRIAD_EXCL_CODE;	//0485
		public String UDEFTRIAD_EXCL_DESC;	//
		public String UDEFTRIAD_POOL;	//
		public Integer UDEFUNPAID_AMOUNT;	//0
		public object UDEFUNPAID_DATE;	//-2208996000000
		public String UDEFUNPAID_INDICATOR;	//
		public Integer UDEFUTILIZ_DIFF;	//0
		public Integer UDEFUTILIZ_TODAY;	//0
		public Integer UDEFUTILIZ_YESTERDAY;	//0 */
	}
	
}