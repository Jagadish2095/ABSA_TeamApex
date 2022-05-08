/**
 * @description Request Integration Bean for AICCodeplexGetSessionToken Service
 * @author JQUEV
 * @created 2020-12-10
 */
public class AICCodeplexGetSessionToken_Req_IB_v1 extends Base_IB {
	public SPMPASSessionTokenRequest SPMPASSessionTokenRequest;

	/**
	 * @description inner class
	 */
	public class SPMPASSessionTokenRequest {
		public String sPASystem;
		public String sPassword;
		public String sUserId;
	}

	/**
	 * @description Creates a fake request for Test purposes
	 * @return AICCodeplexGetSessionToken_Req_IB_v1 object
	 */
	public static AICCodeplexGetSessionToken_Req_IB_v1 createDummyRequest() {
		AICCodeplexGetSessionToken_Req_IB_v1 requestBean = new AICCodeplexGetSessionToken_Req_IB_v1();
		requestBean.SPMPASSessionTokenRequest = new AICCodeplexGetSessionToken_Req_IB_v1.SPMPASSessionTokenRequest();

		requestBean.SPMPASSessionTokenRequest.sPASystem = 'ABSSYB';
		requestBean.SPMPASSessionTokenRequest.sPassword = 'p@ssword1';
		requestBean.SPMPASSessionTokenRequest.sUserId = 'SybrinUser';
		return requestBean;
	}
}