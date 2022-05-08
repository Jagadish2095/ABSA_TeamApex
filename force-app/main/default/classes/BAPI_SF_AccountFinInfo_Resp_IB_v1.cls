/**
 * @description Response bean for BAPI_SF_IF42
 * @author Bhanumurty Rayala
 * @created 2021-06-08
 */
public class BAPI_SF_AccountFinInfo_Resp_IB_v1 extends Base_IB{

    @AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;

		@AuraEnabled public BAPI_SF_IF42 BAPI_SF_IF42;
	/**
	 * @description Wrapper inner class for input variables
	 */
	public class BAPI_SF_IF42{
		@AuraEnabled public E_FI_DETAILS E_FI_DETAILS;
		@AuraEnabled public String E_RESPONSE_DESC;
		@AuraEnabled public Integer E_RESPONSE;
	}

	/**
	 * @description Wrapper inner class for input variables
	 */
	public class E_FI_DETAILS{
		@AuraEnabled public String STP_EXP_DATE;
		@AuraEnabled public String INSTAL_DATE;
		@AuraEnabled public Integer STP_AMT;
		@AuraEnabled public String MORE_TRANS;
		@AuraEnabled public Decimal TOT_INST;
		@AuraEnabled public String LAST_DATE_CCYYMM;
		@AuraEnabled public Decimal ARBAL;
		@AuraEnabled public String LAST_DATE_DD;
		@AuraEnabled public Integer AVAIL_BAL;
		@AuraEnabled public String LAST_EVENT_NBR;
		@AuraEnabled public Decimal CURRENT_BAL;
		@AuraEnabled public Decimal OUTST_BAL;
		@AuraEnabled public Integer ACCT_LIMIT;
		@AuraEnabled public String ACCT_NUM;
	}
}