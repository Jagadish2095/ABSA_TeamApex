/*
 * Integration Handler for CAgetAccountDetails Service
 * @author Prashant Jain
 * @created 2019-09-27
 */

public class CAgetAccountDetails_IH_v1 {
    public static Map<CAgetAccountDetails_Resp_IB_v1, List<Sys_Log_Integration__c>> CAgetAccountDetails(String accountNumber) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CAgetAccountDetails_Resp_IB_v1 responseBean;
        Map<CAgetAccountDetails_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CAgetAccountDetails_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CA_GET_ACCOUNT_DETAILS);

            if (integrationSettings != null) {
                CAgetAccountDetails_Req_IB_v1 requestBean = CAgetAccountDetails_IU_v1.mapRequestFields(accountNumber);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CA_GET_ACCOUNT_DETAILS, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('CAgetAccountDetails Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = CAgetAccountDetails_IU_v1.mapResponseFields(response);

                System.debug('CAgetAccountDetails Request Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' + StringConstants.CA_GET_ACCOUNT_DETAILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = CAgetAccountDetails_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CA_GET_ACCOUNT_DETAILS, StringConstants.CAGETACCOUNTDETAILS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = CAgetAccountDetails_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CA_GET_ACCOUNT_DETAILS, StringConstants.CAGETACCOUNTDETAILS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
}