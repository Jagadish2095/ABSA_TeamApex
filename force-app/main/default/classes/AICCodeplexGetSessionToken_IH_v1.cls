/**
 * @description Integration Handler class for AICCodeplexGetSessionToken Service
 * @author JQUEV
 * @created 2020-12-11
 */
public class AICCodeplexGetSessionToken_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'AIC Codeplex Get Session Token';

	/**
	 * @description Method to get Session Token for AICCodeplexIFrame
	 * @return AICCodeplexGetSessionToken_Resp_IB_v1 object
	 */
	public static AICCodeplexGetSessionToken_Resp_IB_v1 getSessionToken() {
		AICCodeplexGetSessionToken_Req_IB_v1 requestBean = AICCodeplexGetSessionToken_IU_v1.mapRequestFields();
		AICCodeplexGetSessionToken_Resp_IB_v1 responseBean = (AICCodeplexGetSessionToken_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			AICCodeplexGetSessionToken_Resp_IB_v1.class
		);
		return responseBean;
	}
}