/**
 * @description Integration Utility class for AICCodeplexGetSessionToken Service
 * @author JQUEV
 * @created 2020-12-10
 */
public class AICCodeplexGetSessionToken_IU_v1 {

	/**
	 * @description Method to map the response to the AICCodeplexGetSessionToken_Req_IB_v1 Object
	 * @return AICCodeplexGetSessionToken_Req_IB_v1 object
	 */
	public static AICCodeplexGetSessionToken_Req_IB_v1 mapRequestFields() {
		AICCodeplexGetSessionToken_Req_IB_v1 requestBean;
		String aicCodeplexCredentials = Label.AIC_Codeplex_Credentials;

		if (String.isNotBlank(aicCodeplexCredentials)) {
			List<String> aicCodeplexCredentialsSplit = aicCodeplexCredentials.split(';');
			if (aicCodeplexCredentialsSplit?.size() == 3) {
				requestBean = new AICCodeplexGetSessionToken_Req_IB_v1();
				requestBean.SPMPASSessionTokenRequest = new AICCodeplexGetSessionToken_Req_IB_v1.SPMPASSessionTokenRequest();

				requestBean.SPMPASSessionTokenRequest.sPASystem = aicCodeplexCredentialsSplit[0];
				requestBean.SPMPASSessionTokenRequest.sPassword = aicCodeplexCredentialsSplit[1];
				requestBean.SPMPASSessionTokenRequest.sUserId = aicCodeplexCredentialsSplit[2];
			} else {
				throw new AuraHandledException('Could not find sPASystem, sPassword & sUserId in Label.AIC_Codeplex_Credentials');
			}
		} else {
			throw new AuraHandledException('Label.AIC_Codeplex_Credentials is blank');
		}
		return requestBean;
	}
}