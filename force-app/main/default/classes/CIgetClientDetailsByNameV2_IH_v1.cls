/*
 * Integration Handler for CIgetClientDetailsByNameV2 Service
 * @author Rudolf Niehaus 
 * @created 2020-04-07
 */

public class CIgetClientDetailsByNameV2_IH_v1 {

    public static Map<CIgetClientDetailsByNameV2_Resp_IB_v1, List<Sys_Log_Integration__c>> CIgetClientDetailsByNameV2(String cifSurname, String cifInitials, String clntGroup, 
                                                                                                                    String clntGender, String clntBirthDate, String maxRecsToRtrv, 
                                                                                                                    String startAfterSearchPos, String siteCode, String clntTitle) {

        Sys_Log_Integration__c log;

        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CIgetClientDetailsByNameV2_Resp_IB_v1 responseBean;
        Map<CIgetClientDetailsByNameV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CIgetClientDetailsByNameV2_Resp_IB_v1, List<Sys_Log_Integration__c>>();

        Integration_API__c integrationSettings;

        try {

            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.CI_GET_CLIENTDETAILS_BY_NAME_V2);

            if (integrationSettings != null) {

                CIgetClientDetailsByNameV2_Req_IB_v1 requestBean = CIgetClientDetailsByNameV2_IU_v1.mapRequestFields(cifSurname, cifInitials, clntGroup, 
                                                                                                                    clntGender, clntBirthDate, maxRecsToRtrv, 
                                                                                                                    startAfterSearchPos, siteCode, clntTitle);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CI_GET_CLIENTDETAILS_BY_NAME_V2, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('CIgetClientDetailsByNameV2 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = CIgetClientDetailsByNameV2_IU_v1.mapResponseFields(response);

                System.debug('CIgetClientDetailsByNameV2 Response Bean: ' + responseBean);

            }else {

                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.CI_GET_CLIENTDETAILS_BY_NAME_V2 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = CIgetClientDetailsByNameV2_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CI_GET_CLIENTDETAILS_BY_NAME_V2, StringConstants.CIGETCLIENTDETAILSBYNAMEV2_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);

            }
        } catch (Exception e) {

            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = CIgetClientDetailsByNameV2_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CI_GET_CLIENTDETAILS_BY_NAME_V2, StringConstants.CIGETCLIENTDETAILSBYNAMEV2_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);

        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
}