/*
 * Integration Handler for CCgetDailyLimits Service
 * @author Prashant Jain
 * @created 2019-09-11
 */

public class CCgetDailyLimits_IH_v1 {
    public static Map<CCgetDailyLimits_Resp_IB_v1, List<Sys_Log_Integration__c>> CCgetDailyLimits(String combiNbr) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CCgetDailyLimits_Resp_IB_v1 responseBean;
        Map<CCgetDailyLimits_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CCgetDailyLimits_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CC_GET_DAILY_LIMITS);

            if (integrationSettings != null) {
                CCgetDailyLimits_Req_IB_v1 requestBean = CCgetDailyLimits_IU_v1.mapRequestFields(combiNbr);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CC_GET_DAILY_LIMITS, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('CCgetDailyLimits Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = CCgetDailyLimits_IU_v1.mapResponseFields(response);

                System.debug('CCgetDailyLimits Request Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' + StringConstants.CC_GET_DAILY_LIMITS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = CCgetDailyLimits_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CC_GET_DAILY_LIMITS, StringConstants.CCGETDAILYLIMITS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = CCgetDailyLimits_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CC_GET_DAILY_LIMITS, StringConstants.CCGETDAILYLIMITS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
}