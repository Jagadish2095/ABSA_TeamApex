/**
 * @description Response Integration Bean for BAPISFContrDetails Service
 * @author Humbelani Denge
 * @created 2021-01-27
 **/
public class BAPISFContrDetails_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;

	@AuraEnabled
	public List<BAPI_SF_CONTR_DETAILS> BAPI_SF_CONTR_DETAILS;
	/**
	 * @description E_CONTR_DETAILS
	 * @author Humbelani Denge
	 * @created 2021-01-27
	 **/
	public class E_CONTR_DETAILS {
		@AuraEnabled
		public String CONTRACT;
		@AuraEnabled
		public Double OUTSTANDING_CAPITAL;
		@AuraEnabled
		public Double AR_BALANCE;
		@AuraEnabled
		public Double AMOUNT_FINANCED;
		@AuraEnabled
		public Double RATE;
		@AuraEnabled
		public Integer TERM;
		@AuraEnabled
		public Double RESIDUAL;
		@AuraEnabled
		public Integer REMAINING_TERM;
		@AuraEnabled
		public Double ANNUITY;
		@AuraEnabled
		public String INSTALMENT_DATE;
		@AuraEnabled
		public String CORP_CODE;
		@AuraEnabled
		public Integer E_RESPONSE;
		@AuraEnabled
		public String E_RESPONSE_DESC;
	}

	/**
	 * @description BAPI_SF_CONTR_DETAILS
	 * @author Humbelani Denge
	 * @created 2021-01-27
	 **/
	public class BAPI_SF_CONTR_DETAILS {
		@AuraEnabled
		public E_CONTR_DETAILS E_CONTR_DETAILS;
	}
	/**
	 * @description setIntegrationTranslations
	 * @author Humbelani Denge
	 * @created 2021-01-27
	 **/
	public override void setIntegrationTranslations() {
		integrationTranslationsMap = new Map<String, String>();
		integrationTranslationsMap.put('BAPI_SF_CONTR_DETAILS.E_CONTR_DETAILS.CORP_CODE', 'SAP;Corporate Code');
		integrationTranslationsMap.put('BAPI_SF_CONTR_DETAILS.E_CONTR_DETAILS.CORP_CODE', 'SAP;Corporate Code');
	}
}