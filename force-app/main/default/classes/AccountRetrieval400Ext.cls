/**
 * @description AccountRetrieval400Ext Class to extend the functionality of AccountRetrieval400
 * @author Prashant Jain
 * @created 09/03/2021
 * @updated 2021-10-22 Koketso Mpshane
 */

public class AccountRetrieval400Ext {
	/**
	 * @description getCIFData method to get client data from Chewy
	 * @return List<List<SObject>>
	 */
	public static List<List<SObject>> getCIFData() {
		List<List<SObject>> queryList;
		List<Account> accountList;

		String agentId = getAgentId();
		String cifCode;
		if (String.isNotBlank(agentId)) {
			ChewyAgentStatus_Req_IB_v1 requestBean = new ChewyAgentStatus_Req_IB_v1();
			requestBean.agentId = agentId;
			ChewyAgentStatus_Resp_IB_v1 agentStatusResponseBean = ChewyAgentStatus_IH_v1.ChewyAgentStatus(requestBean);
			if (agentStatusResponseBean?.statusCode == 200 && agentStatusResponseBean.payloadObj?.activeConnections?.size() > 0) {
				ChewyAgentStatus_Resp_IB_v1.ActiveConnections activeConnection = agentStatusResponseBean.payloadObj.activeConnections.get(0);

				if (String.isNotBlank(activeConnection?.servicingCif)) {
					cifCode = activeConnection.servicingCif;
					AccountCreate_CIF_MDM.GIPResponse createdAccount = AccountCreate_CIF_MDM.createAccountFromCIF(cifCode, '0', '009970');
					if (String.isNotBlank(createdAccount.accountId)) {
						accountList = [SELECT Type, AccountNumber, Name, Id FROM Account WHERE Id = :createdAccount.accountId];
						if (accountList?.size() > 0) {
							queryList = new List<List<SObject>>();
							queryList.add(accountList);
							queryList.add(new List<Case>());
							queryList.add(new List<Contact>());
							queryList.add(new List<Lead>());
						}
					}
				}
			}
		}
		return queryList;
	}

	/**
	 * @description maintainSessionCache method to maintain session cache
	 * @param taskId
	 * @param agentId
	 */
	public static void maintainSessionCache(String taskId, String agentId) {
		if (String.isBlank(taskId) || Cache.Session.contains('local.Customer1Cache.clientIDnVSessionObject')) {
			ChewyAgentStatus_Req_IB_v1 requestBean = new ChewyAgentStatus_Req_IB_v1();
			requestBean.agentId = agentId;
			ChewyAgentStatus_Resp_IB_v1 agentStatusResponseBean = ChewyAgentStatus_IH_v1.ChewyAgentStatus(requestBean);
			if (agentStatusResponseBean?.statusCode == 200 && agentStatusResponseBean.payloadObj?.activeConnections?.size() > 0) {
				ClientIDnVPollingApex.ClientIDnVSessionObject sessionObj = new ClientIDnVPollingApex.ClientIDnVSessionObject();
				ChewyAgentStatus_Resp_IB_v1.ActiveConnections activeConnection = agentStatusResponseBean.payloadObj.activeConnections.get(0);

				if (String.isBlank(taskId) && activeConnection != null) {
					sessionObj.agentId = agentStatusResponseBean.agentId;
					sessionObj.authenticationType = activeConnection.authentication?.authenticationType;
					sessionObj.cifCode = activeConnection.servicingCif;
					sessionObj.identified = activeConnection.authentication?.identified;
					sessionObj.verified = activeConnection.authentication?.verified;
					sessionObj.ucId = activeConnection.ucId;
                    sessionObj.methodLastUsed = activeConnection.methodLastUsed;

					Cache.Session.put('local.Customer1Cache.clientIDnVSessionObject', sessionObj);
				}
			} else {
				Cache.Session.remove('local.Customer1Cache.clientIDnVSessionObject');
			}
		}
	}

	/**
	 * @description updateTaskIdInSessionCache method to update taskId in session cache
	 * @param taskId
	 */
	public static void updateTaskIdInSessionCache(String taskId) {
		ClientIDnVPollingApex.ClientIDnVSessionObject sessionObj = (ClientIDnVPollingApex.ClientIDnVSessionObject) Cache.Session.get(
			'local.Customer1Cache.clientIDnVSessionObject'
		);
		if (String.isNotBlank(taskId) && sessionObj != null && String.isBlank(sessionObj.taskId)) {
			sessionObj.taskId = taskId;
			Cache.Session.put('local.Customer1Cache.clientIDnVSessionObject', sessionObj);
		}
	}

	/**
	 * @description getAgentId method to get agent detail from Chewy
	 * @return agentId
	 */
	public static String getAgentId() {
		String agentId;
		User userObj = new UsersSelector().selectById(UserInfo.getUserId());

		if (String.isNotBlank(userObj?.Agent_ID__c)) {
			agentId = userObj.Agent_ID__c;
		} else {
			ChewyAgentLookup_Resp_IB_v1 agentLookupResponseBean = ChewyAgentLookup_IH_v1.getAgentIdFromChewy(userObj.AB_Number__c);
			if (agentLookupResponseBean?.statusCode == 200 && String.isNotBlank(agentLookupResponseBean.agentId)) {
				agentId = agentLookupResponseBean.agentId;
			}
		}
		return agentId;
	}

	/**
	 * @description Method to update the User record with the Agent Id associated with the user AB Number
	 */
	public static void updateAgentIdForUser() {
		User usrRecord = new UsersSelector().selectById(UserInfo.getUserId());
		ChewyAgentLookup_Resp_IB_v1 responseBean = ChewyAgentLookup_IH_v1.getAgentIdFromChewy(usrRecord.AB_Number__c);
		if (responseBean.statusCode == 200 && responseBean.agentId != null) {
			usrRecord.Agent_Id__c = responseBean.agentId;
		}
		update usrRecord;
	}

	/**
	 * @description Method to set UCID in Session Cache
	 * @param globalRefId
	 */
	public static void setUCIDInSessionCache(String globalRefId) {
		if (String.isNotBlank(globalRefId)) {
			ClientIDnVPollingApex.ClientIDnVSessionObject sessionObj = (ClientIDnVPollingApex.ClientIDnVSessionObject) Cache.Session.get(
				'local.Customer1Cache.clientIDnVSessionObject'
			);

			if (sessionObj == null) {
				sessionObj = new ClientIDnVPollingApex.ClientIDnVSessionObject();
			}
			sessionObj.ucId = TaskTriggerFunctions.convertUCID(globalRefId);
			Cache.Session.put('local.Customer1Cache.clientIDnVSessionObject', sessionObj);
		}
	}
}