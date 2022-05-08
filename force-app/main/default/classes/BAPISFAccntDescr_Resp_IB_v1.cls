/**
 * @description Response Integration Bean for BAPISFAccntDescr Service
 * @author  Koketso Mpshane
 * @date    17/05/2021
 */
public class BAPISFAccntDescr_Resp_IB_v1 extends Base_IB {

	@auraEnabled
    public String status;
    @auraEnabled
	public Integer statusCode;
    @auraEnabled
	public String message;
	
    @auraEnabled
    public BAPI_SF_ACCNT_DESCR BAPI_SF_ACCNT_DESCR;
	/**
 	 * @description BAPI_SF_ACCNT_DESCR class
 	 */
	public class BAPI_SF_ACCNT_DESCR {
        @auraEnabled
		public List<ACCOUNT_RESP> ACCOUNT_RESP;
        @auraEnabled
		public Integer E_RESPONSE;
        @auraEnabled
		public String E_RESPONSE_DESC;
	}
	/**
	 * @description ACCOUNT_RESP class
 	 */
	public class ACCOUNT_RESP {
        @auraEnabled
		public String ACCOUNT;
        @auraEnabled
		public String MANUFACTURER;
        @auraEnabled
		public String MODEL;
        @auraEnabled
		public String VIN;
        @auraEnabled
		public String STATUS;
        @auraEnabled
		public String RESPONSE_CODE;
	}

}