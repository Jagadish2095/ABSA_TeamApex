/**
 * @description Account Holds Service
 */
public class SVupdateAccountHoldsV4_IH_v1 {

	/**
     * @description Makes the callout to cqgetacctholdsmaintV4
	 * @param accountNumberP
     * @param frozenInd
     * @param stoppedInd
     * @param dormantInd
     * @param semiDormantInd
     * @param exclEstateInd
     * @param exclInslvntInd
     * @param courtOrderInd
     * @param signingAuthInd
     * @param monitorActivityInd
     * @param potBadDebtInd
     * @param legalActionInd
     * @param nonResidentInd
     * @param lostBookInd
     * @param blockedInd
     * @param offlineEnqInd
     * @param securityMessageInd
     * @param restricHoldInd
     * @param exceedMaxBalInd
     * @param wtiCountry
     * @param rbaEddHold
     * @param siteCode
     * @param teller
     * @param supervisor
	 * @return Map<SVupdateAccountHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>>
	 */

	public static Map<SVupdateAccountHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> callTosvupdateaccountholdsV4(
		String accountNumberP,
		String frozenInd,
		String stoppedInd,
		String dormantInd,
		String semiDormantInd,
		String exclEstateInd,
		String exclInslvntInd,
		String courtOrderInd,
		String signingAuthInd,
		String monitorActivityInd,
		String potBadDebtInd,
		String legalActionInd,
		String nonResidentInd,
		String lostBookInd,
		String blockedInd,
		String offlineEnqInd,
		String securityMessageInd,
		String restricHoldInd,
		String exceedMaxBalInd,
		String wtiCountry,
		String rbaEddHold,
		String siteCode,
		String teller,
		String supervisor
	) {
		Sys_Log_Integration__c log;
		List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
		SVupdateAccountHoldsV4_Resp_IB_v1 ListRespBean = new SVupdateAccountHoldsV4_Resp_IB_v1();

		Map<SVupdateAccountHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<SVupdateAccountHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>>();

		try {
			Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(
				StringConstants.JITTERBIT_API_RB_STRING,
				Sys_Utilities_General.getEnvironment(),
				StringConstants.SV_UPDATE_ACCOUNT_HOLDS
			);
			//|| Test.isRunningTest() || integrationSettings == null
			if (integrationSettings != null) {
				SVupdateAccountHoldsV4_Req_IB_v1 requestBean = SVupdateAccountHoldsV4_IU_v1.mapRequestdFields(
					accountNumberP,
					frozenInd,
					stoppedInd,
					dormantInd,
					semiDormantInd,
					exclEstateInd,
					exclInslvntInd,
					courtOrderInd,
					signingAuthInd,
					monitorActivityInd,
					potBadDebtInd,
					legalActionInd,
					nonResidentInd,
					lostBookInd,
					blockedInd,
					offlineEnqInd,
					securityMessageInd,
					restricHoldInd,
					exceedMaxBalInd,
					wtiCountry,
					rbaEddHold,
					siteCode,
					teller,
					supervisor
				);

				String jsonString = JSON.serialize(requestBean, true);

				HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
				system.debug('Request  : ' + request);
				log = SystemLogger.createRequestIntegrationLog(
					request.getBody(),
					StringConstants.METHOD_SV_UPDATE_ACCOUNT_HOLDS,
					StringConstants.SALESFORCE_STRING,
					request.getEndpoint()
				);
				HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

				if (response != null) {
					if (response.getStatusCode() == 200) {
						ListRespBean = (SVupdateAccountHoldsV4_Resp_IB_v1) JSON.deserialize(response.getBody(), SVupdateAccountHoldsV4_Resp_IB_v1.class);
						ListRespBean.statusCode = response.getStatusCode();
						ListRespBean.message = response.getStatus();
					} else {
						System.debug('Status Code NOT 200 - FAILURE');
						log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
						ListRespBean = SVupdateAccountHoldsV4_IU_v1.mapFailedResponseFields(response.getStatus(), response.getStatusCode(), response.getBody());
					}
				}
			}
		} catch (Exception e) {
			//Exception
			System.debug(e.getMessage() + '.' + e.getStackTraceString());
			String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
			ListRespBean = SVupdateAccountHoldsV4_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
			log = SystemLogger.createInternalIntegrationLog(
				StringConstants.METHOD_SV_UPDATE_ACCOUNT_HOLDS,
				StringConstants.ESP_STRING,
				500,
				StringConstants.INTEGRATION_STATUS_FAILED,
				message
			);
		}

		if (log != null) {
			//insert log;
			logList.add(log);
		}
		responseMap.put(ListRespBean, logList);
		system.debug(responseMap);
		return responseMap;
	}
}