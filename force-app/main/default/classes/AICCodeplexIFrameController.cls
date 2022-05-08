/**
 * @description Controller class for the AICCodeplexIFrame component
 * @author Jason Quevauvilliers / Prashant Jain
 * @created 2020-12-10
 */
public class AICCodeplexIFrameController {
	@AuraEnabled
    /**
	 * @description retrieves the Session Token and constructs the URL for the IFrame
	 * @param claimNumber
	 * @return IFrame URL
	 */
	public static String getIFrameURL(String claimNumber) {
		User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
		String currentUserABNumber = currentUser?.AB_Number__c;
		String sessionToken = getSessionToken();
		String iFrameURL = String.format(Label.AIC_Codeplex_IFrame_URL, new List<String>{ claimNumber, currentUserABNumber, sessionToken });
		return iFrameURL;
	}

	/**
	 * @description Private Method to call the getSessionToken Service
	 * @return Session Token
	 */
	private static String getSessionToken() {
		AICCodeplexGetSessionToken_Resp_IB_v1 responseBean = AICCodeplexGetSessionToken_IH_v1.getSessionToken();
		if (String.isNotBlank(responseBean?.SPMPASSessionTokenResponse?.sSessionToken)) {
			String sessionToken = responseBean.SPMPASSessionTokenResponse.sSessionToken;
			return sessionToken;
		} else if (String.isNotBlank(responseBean?.SPMPASSessionTokenResponse?.sErrorMessage)) {
			throw new AuraHandledException(
				'Error received from AICCodeplexGetSessionToken service. Message: ' + responseBean.SPMPASSessionTokenResponse.sErrorMessage
			);
		} else {
			throw new AuraHandledException('Could not get Session token using AICCodeplexGetSessionToken service. Response: ' + JSON.serialize(responseBean));
		}
	}
}