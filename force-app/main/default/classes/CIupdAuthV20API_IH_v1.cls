/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @last modified on  : 2021-10-18
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   2021-08-05   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 **/
public without sharing class CIupdAuthV20API_IH_v1 
{
	public static final String CI_AUTH_RELATEDPARTY_V20 = 'CI_AUTH_RELATEDPARTY_V20';
	/**
	 * @description ciauthRelateParties
	 *
	 * @param requestBean
	 * @return responseBean
	 */ public static CIupdAuthV20API_Resp_IB_v1 ciauthRelateParties(CIupdtAuthV20API_Req_IB_v1 requestBean) {
		string usr = System.UserInfo.getUserId();
		User userInfo = [SELECT Teller_Operator_Code__c, SiteCode__c FROM User WHERE Id = :usr WITH SECURITY_ENFORCED];
		Map<String, String> headers = new Map<String, String>();
		headers.put('tellerId', String.valueOf(userInfo.Teller_Operator_Code__c));
		headers.put('branch', String.valueOf(userInfo.SiteCode__c));

		headers.put('DeviceId', 'laptop');
		headers.put('Devicetype', 'laptop');
		headers.put('ApplicationId', 'BDP');
		headers.put('userid', String.valueOf(userInfo.SiteCode__c));

		CIupdAuthV20API_Resp_IB_v1 responseBean = (CIupdAuthV20API_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			Headers,
			CI_AUTH_RELATEDPARTY_V20,
			CIupdAuthV20API_Resp_IB_v1.class
		);
		return responseBean;
	}
}