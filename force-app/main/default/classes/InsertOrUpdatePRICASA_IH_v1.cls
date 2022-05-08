/**
 * @description insertOrUpdatePRICASA_IH_v1 Description for PRI
 *
 */

public class InsertOrUpdatePRICASA_IH_v1 {
	/**Request Integration Bean for InsertOrUpdatePRICASA Service
	 * @description insertOrUpdatePRICASA
	 * @param accountP (Account)
	 * @param opportunityIdP (Id)
	 * @param userIdP (Id)
	 * @param quoteP (Quote)
	 * @return Return InsertOrUpdatePRICASA_Resp_IB_v1
	 */
	public static InsertOrUpdatePRICASA_Resp_IB_v1 insertOrUpdatePRICASA(Account accountP, Id opportunityIdP, Id userIdP, Quote quoteP) {
		InsertOrUpdatePRICASA_Resp_IB_v1 responseBean;
		Sys_Log_Integration__c log;

		try {
			//Query Objects
			List<Opportunity> opportunityList = new OpportunitiesSelector().selectByOpportunityId(opportunityIdP, 1);
			List<User> userList = new UsersSelector().selectById(new Set<Id>{ userIdP });
			Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(
				StringConstants.API_MANAGER,
				Sys_Utilities_General.getEnvironment(),
				StringConstants.INSERT_OR_UPDATE_PRI
			);

			if (accountP != null && opportunityList.size() == 1 && userList.size() == 1 && integrationSettings != null) {
				//Map Request Fields
				InsertOrUpdatePRICASA_Req_IB_v1 requestBean = InsertOrUpdatePRICASA_IU_v1.mapRequestFields(accountP, opportunityList[0], userList[0], quoteP);
				String jsonString = JSON.serialize(requestBean, true);
				HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
				request.setTimeout(120000);

				//Send Request
				HttpResponse response = Sys_Utilities_Integration.serviceCallout(request);

				if (response.getBody() == StringConstants.ERROR_MSG_READ_TIMED_OUT) {
					responseBean = InsertOrUpdatePRICASA_IU_v1.mapFailedResponseFields(
						500,
						StringConstants.STATUS_CODE_500,
						StringConstants.ERROR_MSG_READ_TIMED_OUT
					);
				} else {
					//Map Response
					response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
					responseBean = InsertOrUpdatePRICASA_IU_v1.mapResponseFields(response);
				}
			} else {
				//Map Bad Response and log
				String message = '';
				if (accountP == null) {
					message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_ACCOUNT;
				}
				if (opportunityList.size() == 0) {
					message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_OPP + opportunityIdP;
				}
				if (userList.size() == 0) {
					message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_USER + userIdP;
				}
				if (integrationSettings == null) {
					message +=
						StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND +
						'API: ' +
						StringConstants.API_MANAGER +
						'. Service: ' +
						StringConstants.INSERT_OR_UPDATE_PRI +
						'. Environment: ' +
						Sys_Utilities_General.getEnvironment();
				}
				log = SystemLogger.createInternalIntegrationLog(
					StringConstants.METHOD_INSERT_UPDATE_PRI,
					StringConstants.SIEBEL_STRING,
					500,
					StringConstants.INTEGRATION_STATUS_FAILED,
					message
				);
				responseBean = InsertOrUpdatePRICASA_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
			}
		} catch (Exception e) {
			//Map bad response with an unhandled exception and Log
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
			log = SystemLogger.createInternalIntegrationLog(
				StringConstants.METHOD_INSERT_UPDATE_PRI,
				StringConstants.SIEBEL_STRING,
				500,
				StringConstants.INTEGRATION_STATUS_FAILED,
				message
			);
			responseBean = InsertOrUpdatePRICASA_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
			system.debug('InsertOrUpdatePRICASA_IH_v1 Exception: ' + e.getMessage());
		}
		if (log != null) {
			insert log;
		}
		return responseBean;
	}
}