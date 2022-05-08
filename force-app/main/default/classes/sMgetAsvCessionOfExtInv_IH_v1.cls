/**
 * @description       : sMgetAsvCessionOfExtInv_IH_v1 integration class to call the service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/
public class sMgetAsvCessionOfExtInv_IH_v1 {
	/**
	* @description 
	* @author Prashant Jain | 2021-06-11 
	* @param clcd 
	* @return Map<sMgetAsvCessionOfExtInv_Resp_IB_v1, List<Sys_Log_Integration__c>> 
	**/
	public static Map<sMgetAsvCessionOfExtInv_Resp_IB_v1, List<Sys_Log_Integration__c>> getAsvCessionOfExtInvestment(String clcd) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        sMgetAsvCessionOfExtInv_Resp_IB_v1 responseBean;
        Map<sMgetAsvCessionOfExtInv_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<sMgetAsvCessionOfExtInv_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API, Sys_Utilities_General.getEnvironment(), StringConstants.SM_GET_ASV_EXTERNAL_INVESTMENTS_SESSION_V1);

            if (integrationSettings != null) {
                sMgetAsvCessionOfExtInv_Req_IB_v1 requestBean = sMgetAsvCessionOfExtInv_IU_v1.mapRequestFields(clcd);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_SM_GET_ASV_EXTERNAL_INVESTMENTS_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('sMgetAsvLettersV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = sMgetAsvCessionOfExtInv_IU_v1.mapResponseFields(response);

                System.debug('sMgetAsvLettersV1 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API + '. Service: ' + StringConstants.SM_GET_ASV_EXTERNAL_INVESTMENTS_SESSION_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = sMgetAsvCessionOfExtInv_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_SM_GET_ASV_EXTERNAL_INVESTMENTS_V1, StringConstants.SM_GET_ASV_EXTERNAL_INVESTMENTS_SESSION_V1, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = sMgetAsvCessionOfExtInv_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.SM_GET_ASV_EXTERNAL_INVESTMENTS_SESSION_V1, StringConstants.SM_GET_ASV_EXTERNAL_INVESTMENTS_SESSION_V1, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }

}