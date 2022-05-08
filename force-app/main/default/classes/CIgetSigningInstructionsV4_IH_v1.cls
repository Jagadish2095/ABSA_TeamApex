/**
 * @description get all signing auth
 * Integration Handler for CIgetSigningInstructionsV4 Service
 * @author Prashant Jain
 * @created 2020-03-05
 */

public with sharing class CIgetSigningInstructionsV4_IH_v1 {
	public static final String INTEGRATION_AUTHSERVICE_NAME = 'CIGetSigningInstructionsV4';
	/**
	 * @description getRelatedPartiesDetails description	 *
	 * @param accountNumber
	 * @param siteCode
	 * @param  maxRetrieve
	 * @return CIgetSigningInstructionsV4
	 */
	public static Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> CIgetSigningInstructionsV4(
		String accountNumber,
		String siteCode,
		String maxRetrieve
	) {
		Sys_Log_Integration__c log;
		List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
		CIgetSigningInstructionsV4_Resp_IB_v1 responseBean;
		Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>>();
		Integration_API__c integrationSettings;

		try {
			integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(
				StringConstants.JITTERBIT_API,
				Sys_Utilities_General.getEnvironment(),
				StringConstants.CI_GET_SIGNING_INSTRUCTIONS_V4
			);

			if (integrationSettings != null) {
				CIgetSigningInstructionsV4_Req_IB_v1 requestBean = CIgetSigningInstructionsV4_IU_v1.mapRequestFields(accountNumber, siteCode, maxRetrieve);

				String jsonString = JSON.serialize(requestBean, true);

				HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

				log = SystemLogger.createRequestIntegrationLog(
					request.getBody(),
					StringConstants.METHOD_CI_GET_SIGNING_INSTRUCTIONS_V4,
					StringConstants.SALESFORCE_STRING,
					request.getEndpoint()
				);

				//Send Request
				HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

				//JitterbitAuthResponse auth = JitterbitAuth_IH_V1.authenticate2();

				//response.setHeader('Authorization', 'Bearer ' + auth.token);

				// system.debug('CIgetSigningInstructionsV4 Response: ' + response);

				log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

				responseBean = CIgetSigningInstructionsV4_IU_v1.mapResponseFields(response);

				//  System.debug('CIgetSigningInstructionsV4 Response Bean: ' + responseBean);
			} else {
				String message =
					StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND +
					'API: ' +
					StringConstants.JITTERBIT_API +
					'. Service: ' +
					StringConstants.CI_GET_SIGNING_INSTRUCTIONS_V4 +
					'. Environment: ' +
					Sys_Utilities_General.getEnvironment();
				responseBean = CIgetSigningInstructionsV4_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
				log = SystemLogger.createInternalIntegrationLog(
					StringConstants.METHOD_CI_GET_SIGNING_INSTRUCTIONS_V4,
					StringConstants.CIGETSIGNINGINSTRUCTIONSV4_STRING,
					500,
					StringConstants.INTEGRATION_STATUS_FAILED,
					message
				);
				//System.debug(message);
			}
		} catch (Exception e) {
			//Exception
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
			responseBean = CIgetSigningInstructionsV4_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
			log = SystemLogger.createInternalIntegrationLog(
				StringConstants.METHOD_CI_GET_SIGNING_INSTRUCTIONS_V4,
				StringConstants.CIGETSIGNINGINSTRUCTIONSV4_STRING,
				500,
				StringConstants.INTEGRATION_STATUS_FAILED,
				message
			);
			// System.debug(message);
		}

		if (log != null) {
			logList.add(log);
		}

		responseMap.put(responseBean, logList);
		return responseMap;
	}
	/**
	 * @description get all signing auth
	 * @param accountNumber
	 * @param siteCode
	 * @param  maxRetrieve
	 * @return CIgetAllSigningInstructionsV4
	 */
	public static CIgetSigningInstructionsV4_Resp_IB_v2 CIgetAllSigningInstructionsV4(String accountNumber, String siteCode, String maxRetrieve) {
		CIgetSigningInstructionsV4_Req_IB_v1 requestBean = CIgetSigningInstructionsV4_IU_v1.mapRequestFields(accountNumber, siteCode, maxRetrieve);

		CIgetSigningInstructionsV4_Resp_IB_v2 responseBean = (CIgetSigningInstructionsV4_Resp_IB_v2) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_AUTHSERVICE_NAME,
			CIgetSigningInstructionsV4_Resp_IB_v2.class
		);

		return responseBean;
	}
}