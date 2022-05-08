/**
 * @description Response Integration Bean for SAPGetList Service
 * @author Jason Quevauvilliers
 * @created 2020-11-04
 * @modified 202104-19 by Jason Quevauvilliers (W-011270)
 */
public class AvafVapsGetList_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;

	@AuraEnabled
	public List<BAPI_SF_VAPS> BAPI_SF_VAPS_LIST;
	@AuraEnabled
	public String E_RESPONSE;
	@AuraEnabled
	public String E_RESPONSE_DESC;

	/**
	 * @description inner class
	 */
	public class BAPI_SF_VAPS {
		@AuraEnabled
		public String ACCOUNT;
		@AuraEnabled
		public String ZZPRDCODE;
		@AuraEnabled
		public String ZZPRDDESC;
		@AuraEnabled
		public String ITM_TYPE;
		@AuraEnabled
		public String ZZUNIQUE_ID;
		@AuraEnabled
		public String ZZINSCODE;
		@AuraEnabled
		public String ZZINSCOMP;
		@AuraEnabled
		public String POLICY;
		@AuraEnabled
		public String ZZPOLIDATE;
		@AuraEnabled
		public String ZZPOLEDATE;
		@AuraEnabled
		public String ZZINSAMT;
		@AuraEnabled
		public String ZZINSTRM;
		@AuraEnabled
		public String RESP_DATE_X;
		@AuraEnabled
		public String RESP_DATE;
		@AuraEnabled
		public String RESP_TIME;
		@AuraEnabled
		public String INS_AUTH_REQ; //W-011270
		@AuraEnabled
		public String AUTH_OVERRIDE; //W-011270
	}

	/**
	 * @description replaces the variable names returned in the JSON response
	 */
	public override void setFieldNameSubstitutions() {
		fieldNameSubstitutionMap = new Map<String, String>();
		fieldNameSubstitutionMap.put('ITM_TYPE_', 'ITM_TYPE');
		fieldNameSubstitutionMap.put('ZZINSCODE___', 'ZZINSCODE');
		fieldNameSubstitutionMap.put('ZZINSCOMP_', 'ZZINSCOMP');
		fieldNameSubstitutionMap.put('POLICY______', 'POLICY');
		fieldNameSubstitutionMap.put('ZZPOLEDATE_', 'ZZPOLEDATE');
		fieldNameSubstitutionMap.put('ZZINSAMT_', 'ZZINSAMT');
		fieldNameSubstitutionMap.put('ZZINSTRM__', 'ZZINSTRM');
		fieldNameSubstitutionMap.put('RESP_DATE_', 'RESP_DATE_X');
		fieldNameSubstitutionMap.put('RESP_TIME_', 'RESP_TIME');
	}
}