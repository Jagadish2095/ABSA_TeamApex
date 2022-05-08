/**
 * @description       : Integration Handler for CIgetClientDetailsV12 Service
 * @author Prudence Shirindzi
 * @created 2020-10-07
 * @last modified on  : 2021-11-30
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/

public class CIgetClientDetailsV12_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'CIgetClientDetailsV12';

	/**
	 * @description Get Client details
	 * @param cifCode
	 * @param accountNumber
	 * @return CIgetClientDetailsV12_Resp_IB_v1
	 */
	public static CIgetClientDetailsV12_Resp_IB_v1 CIgetClientDetailsV12(String cifCode, String accountNumber) {
		string usr = System.UserInfo.getUserId();
		User userInfo = [SELECT EmployeeNumber, Profile.Name, SiteCode__c, AB_Number__c FROM User WHERE Id = :usr];
		if (accountNumber == '') {
			accountNumber = '0';
		}
		return CIgetClientDetailsV12(userInfo.SiteCode__c, cifCode, accountNumber, 'BRANCH');
	}

	/**
	 * @description Get Client details
	 * @param siteCode
	 * @param cifCode
	 * @param accountNumber
	 * @return CIgetClientDetailsV12_Resp_IB_v1
	 */
	public static CIgetClientDetailsV12_Resp_IB_v1 CIgetClientDetailsV12(String siteCode, String cifCode, Integer accountNumber) {
		string accountNumberString = string.valueOf(accountNumber);
		return CIgetClientDetailsV12(siteCode, cifCode, accountNumberString, 'BRANCH');
	}

	/**
	 * @description Get Client details
	 * @param siteCode
	 * @param cifCode
	 * @param accountNumber
	 * @param channel
	 * @return CIgetClientDetailsV12_Resp_IB_v1
	 */
	public static CIgetClientDetailsV12_Resp_IB_v1 CIgetClientDetailsV12(String siteCode, String cifCode, string accountNumber, String channel) {
		return CIgetClientDetailsV12(siteCode, cifCode, accountNumber, channel, 'SFRET');
	}

	/**
	 * @description Get Client details
	 * @param siteCode
	 * @param cifCode
	 * @param accountNumber
	 * @param channel
	 * @param application
	 * @return CIgetClientDetailsV12_Resp_IB_v1
	 */
	public static CIgetClientDetailsV12_Resp_IB_v1 CIgetClientDetailsV12(
		String siteCode,
		String cifCode,
		string accountNumber,
		String channel,
		String application
	) {
		CIgetClientDetailsV12_Req_IB_v1 requestClass = new CIgetClientDetailsV12_Req_IB_v1();
		CIgetClientDetailsV12_Req_IB_v1 requestBean = requestClass.getNewInstance();
		requestBean.CIgetClientDetailsV12.nbsapdpi.channel = channel;
		requestBean.CIgetClientDetailsV12.nbsapdpi.application = application;
		requestBean.CIgetClientDetailsV12.cip002i.siteCode = siteCode;
		requestBean.CIgetClientDetailsV12.cip002i.inpClientCode = cifCode;
		requestBean.CIgetClientDetailsV12.cip002i.clntAcctNbr = accountNumber;
		CIgetClientDetailsV12_Resp_IB_v1 responseBean = (CIgetClientDetailsV12_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			CIgetClientDetailsV12_Resp_IB_v1.class
		);
		return responseBean;
	}
}