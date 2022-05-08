/**
 * @description Integration Handler for CIgetAcctLinkedToClientCode Service
 * @author Pitso Sekhu
 * @created 2019-13-01
 */

public class CIgetAcctLinkedToClientCode_IH_v1 {
	/**
	 * @description ciGetAcctLinkedToAccountNumber
	 * @param application
	 * @param accountNo
	 * @return CIgetAcctLinkedToClientCode_Resp_IB_v1
	 */
	public static CIgetAcctLinkedToClientCode_Resp_IB_v1 ciGetAcctLinkedToAccountNumber(String application, String accountNo) {
		CIgetAcctLinkedToClientCode_Req_IB_v1 requestBean = CIgetAcctLinkedToClientCode_IU_v1.mapRequestFields(application, '', accountNo);
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = getClientLinkedAccounts(requestBean);

		return responseBean;
	}

	/**
	 * @description ciGetAcctLinkedToClientCode
	 * @param application
	 * @param clientcd
	 * @return CIgetAcctLinkedToClientCode_Resp_IB_v1
	 */

	public static CIgetAcctLinkedToClientCode_Resp_IB_v1 ciGetAcctLinkedToClientCode(String application, String clientcd) {
		CIgetAcctLinkedToClientCode_Req_IB_v1 requestBean = CIgetAcctLinkedToClientCode_IU_v1.mapRequestFields(application, clientcd, '0');
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean = getClientLinkedAccounts(requestBean);
		return responseBean;
	}

	/**
	 * @description getClientLinkedAccounts
	 * @param requestBean
	 * @return CIgetAcctLinkedToClientCode_Resp_IB_v1
	 */
	public static CIgetAcctLinkedToClientCode_Resp_IB_v1 getClientLinkedAccounts(CIgetAcctLinkedToClientCode_Req_IB_v1 requestBean) {
		Sys_Log_Integration__c log;
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean;
		Integration_API__c integrationSettings;

		try {
			integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(
				StringConstants.API_MANAGER,
				Sys_Utilities_General.getEnvironment(),
				StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE
			);

			if (integrationSettings != null) {
				String jsonString = JSON.serialize(requestBean, true);

				HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

				log = SystemLogger.createRequestIntegrationLog(
					request.getBody(),
					StringConstants.METHOD_CI_GET_ACCT_LINKED_TO_CLIENT_CODE,
					StringConstants.SALESFORCE_STRING,
					request.getEndpoint()
				);

				//Send Request
				HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

				system.debug('reponse: ' + response);

				log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

				responseBean = CIgetAcctLinkedToClientCode_IU_v1.mapResponseFields(response);

				System.debug('CI Get Acct Linked To Client Code Request Bean: ' + responseBean);
			} else {
				String message =
					StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND +
					'API: ' +
					StringConstants.API_MANAGER +
					'. Service: ' +
					StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE +
					'. Environment: ' +
					Sys_Utilities_General.getEnvironment();
				responseBean = CIgetAcctLinkedToClientCode_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
				log = SystemLogger.createInternalIntegrationLog(
					StringConstants.METHOD_CI_GET_ACCT_LINKED_TO_CLIENT_CODE,
					StringConstants.CIGETACCTLINKEDTOCLIENTCODE_STRING,
					500,
					StringConstants.INTEGRATION_STATUS_FAILED,
					message
				);
				System.debug(message);
			}
		} catch (Exception e) {
			//Exception
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
			responseBean = CIgetAcctLinkedToClientCode_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
			log = SystemLogger.createInternalIntegrationLog(
				StringConstants.METHOD_CI_GET_ACCT_LINKED_TO_CLIENT_CODE,
				StringConstants.CIGETACCTLINKEDTOCLIENTCODE_STRING,
				500,
				StringConstants.INTEGRATION_STATUS_FAILED,
				message
			);
			System.debug(message);
		}

		if (log != null) {
			insert log;
		}

		return responseBean;
	}

	/**
	 * @description ciGetAcctLinkedToClientCodeWithOutInsertLog
	 * @param application
	 * @param clientcd
	 * @return Map of response bean and log
	 */
	public static Map<CIgetAcctLinkedToClientCode_Resp_IB_v1, List<Sys_Log_Integration__c>> ciGetAcctLinkedToClientCodeWithOutInsertLog(
		String application,
		String clientcd
	) {
		Sys_Log_Integration__c log;
		CIgetAcctLinkedToClientCode_Resp_IB_v1 responseBean;
		Integration_API__c integrationSettings;
		List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
		Map<CIgetAcctLinkedToClientCode_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CIgetAcctLinkedToClientCode_Resp_IB_v1, List<Sys_Log_Integration__c>>();

		try {
			integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(
				StringConstants.API_MANAGER,
				Sys_Utilities_General.getEnvironment(),
				StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE
			);

			if (integrationSettings != null) {
				CIgetAcctLinkedToClientCode_Req_IB_v1 requestBean = CIgetAcctLinkedToClientCode_IU_v1.mapRequestFields(application, clientcd, '0');

				String jsonString = JSON.serialize(requestBean, true);

				HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

				log = SystemLogger.createRequestIntegrationLog(
					request.getBody(),
					StringConstants.METHOD_CI_GET_ACCT_LINKED_TO_CLIENT_CODE,
					StringConstants.SALESFORCE_STRING,
					request.getEndpoint()
				);

				//Send Request
				HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

				system.debug('reponse: ' + response);
				System.debug('RESPONSEEE: ' + response.getBody());
				log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

				responseBean = CIgetAcctLinkedToClientCode_IU_v1.mapResponseFields(response);

				System.debug('CI Get Acct Linked To Client Code Request Bean: ' + responseBean);
			} else {
				String message =
					StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND +
					'API: ' +
					StringConstants.API_MANAGER +
					'. Service: ' +
					StringConstants.CI_GET_ACCT_LINKED_TO_CLIENT_CODE +
					'. Environment: ' +
					Sys_Utilities_General.getEnvironment();
				responseBean = CIgetAcctLinkedToClientCode_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
				log = SystemLogger.createInternalIntegrationLog(
					StringConstants.METHOD_CI_GET_ACCT_LINKED_TO_CLIENT_CODE,
					StringConstants.CIGETACCTLINKEDTOCLIENTCODE_STRING,
					500,
					StringConstants.INTEGRATION_STATUS_FAILED,
					message
				);
				System.debug(message);
			}
		} catch (Exception e) {
			//Exception
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
			responseBean = CIgetAcctLinkedToClientCode_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
			log = SystemLogger.createInternalIntegrationLog(
				StringConstants.METHOD_CI_GET_ACCT_LINKED_TO_CLIENT_CODE,
				StringConstants.CIGETACCTLINKEDTOCLIENTCODE_STRING,
				500,
				StringConstants.INTEGRATION_STATUS_FAILED,
				message
			);
			System.debug(message);
		}

		if (log != null) {
			logList.add(log);
		}

		responseMap.put(responseBean, logList);

		return responseMap;
	}
}