/**
 * @description Controller used by the ClientIDnVPolling lightning component
 *
 * @author  Danie Booysen
 * @version v1.0
 * @since   2021-03-05
 * @updated 2021-10-22 Koketso Mpshane
 */
public class ClientIDnVPollingApex {
	/**
	 * @description Method that returns the session cache for the clients' ID&V status session
	 * @param cifCode - CIF code of the client passed in
	 * @return instance of ClientIDnVSessionObject
	 */
	@AuraEnabled
	public static ClientIDnVSessionObject getSessionCacheValues(String cifCode) {
		ClientIDnVSessionObject clientIDnVSessionObj = (ClientIDnVSessionObject) Cache.Session.get('local.Customer1Cache.clientIDnVSessionObject');
		if (String.isNotBlank(cifCode) && clientIDnVSessionObj?.cifCode == cifCode) {
			clientIDnVSessionObj.matched = true;
        } else if (String.isNotBlank(clientIDnVSessionObj?.cifCode)) {
			clientIDnVSessionObj.matched = false;
			clientIDnVSessionObj.verified = false;
		}

		return clientIDnVSessionObj;
	}

	/**
	 * @description Custom object that represents the session cache
	 */
	public class ClientIDnVSessionObject {
		@AuraEnabled
		public String cifCode;
		@AuraEnabled
		public Boolean identified;
		@AuraEnabled
		public Boolean verified;
		@AuraEnabled
		public Boolean matched;
		@AuraEnabled
		public String ucId;
		@AuraEnabled
		public List<String> authenticationType;
		@AuraEnabled
		public String taskId;
		@AuraEnabled
		public String agentId;
        @AuraEnabled
		public String methodLastUsed;
	}

	/**
	 * @author Koketso Mpshane
	 * @description check if the current user is linked to IDnV Service groups
	 * @return Boolean
	 */
	@AuraEnabled
	public static Boolean checkIDnVPollingUserServiceGroups() {
		Boolean iDnVPolling = false;
		String iDnVServiceGroupslbl = Label.Client_IDnV_Polling_Service_Groups;
		List<String> iDnVServiceGroupList = iDnVServiceGroupslbl.split(';');

		Integer userEntries = new ServiceGroupUserEntriesSelector().countUserRelatedEntries(UserInfo.getUserId(), iDnVServiceGroupList);

		if (userEntries > 0) {
			iDnVPolling = true;
		}

		return iDnVPolling;
	}
}