/*
 * Integration Handler for CPBValidate Service
 * @author Prashant Jain
 * @created 2020-02-06
 */

public class CPBValidate_IH_v1 {
    public static Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> CPBValidate(String idNumber, String surname) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CPBValidate_Resp_IB_v1 responseBean;
        Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CPBValidate_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CPB_VALIDATE);

            if (integrationSettings != null) {
                CPBValidate_Req_IB_v1 requestBean = CPBValidate_IU_v1.mapRequestFields(idNumber, surname);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CPB_VALIDATE, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('CPBValidate Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = CPBValidate_IU_v1.mapResponseFields(response);

                System.debug('CPBValidate Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' + StringConstants.CPB_VALIDATE + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = CPBValidate_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CPB_VALIDATE, StringConstants.CPBVALIDATE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = CPBValidate_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CPB_VALIDATE, StringConstants.CPBVALIDATE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
}