/**
 * @description Response Integration Bean for AICCodeplexGetSessionToken Service
 * @author JQUEV
 * @created 2020-12-10
 */
public class AICCodeplexGetSessionToken_Resp_IB_v1 extends Base_IB {
	public String status;
	public Integer statusCode;
	public String message;

	public SPMPASSessionTokenResponse SPMPASSessionTokenResponse;

	/**
	 * @description inner class
	 */
	public class SPMPASSessionTokenResponse {
		public String bIsSuccess;
		public String sErrorMessage;
		public String sSessionToken;
	}
}