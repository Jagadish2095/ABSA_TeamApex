/**
 * @description Response Integration Bean for SAPCancel Service
 * @author Jason Quevauvilliers
 * @created 2020-11-05
 */
public class AvafVapsCancel_Resp_IB_v1 extends Base_IB {
	@AuraEnabled
	public String status;
	@AuraEnabled
	public Integer statusCode;
	@AuraEnabled
	public String message;

	@AuraEnabled
	public List<BAPI_SF_VAPS> BAPI_SF_VAPS_CANCEL;

	/**
	 * @description inner class
	 */
	public class BAPI_SF_VAPS {
		@AuraEnabled
		public String E_RESPONSE;
		@AuraEnabled
		public String E_RESPONSE_DESC;
	}
}