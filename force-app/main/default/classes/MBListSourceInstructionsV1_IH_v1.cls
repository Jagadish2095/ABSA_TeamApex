/*
 * Integration Handler for MBListSourceInstructionsV1 Service
 * @author Rudolf Niehaus
 * @created 2020-05-12
 */

public class MBListSourceInstructionsV1_IH_v1 {

    public static Map<MBListSourceInstructionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> MBListSourceInstructionsV1(String cif, String acc) {

        Sys_Log_Integration__c log;

        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        MBListSourceInstructionsV1_Resp_IB_v1 responseBean;
        Map<MBListSourceInstructionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBListSourceInstructionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();

        Integration_API__c integrationSettings;

        try {

            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_LIST_SOURCE_INSTRUCTIONS_V1);

            if (integrationSettings != null) {

                MBListSourceInstructionsV1_Req_IB_v1 requestBean = MBListSourceInstructionsV1_IU_v1.mapRequestFields(cif, acc);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_LIST_SOURCE_INSTRUCTIONS_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('MBListSourceInstructionsV1 Response: ' + response);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                insert log;
                responseBean = MBListSourceInstructionsV1_IU_v1.mapResponseFields(response);

                System.debug('MBListSourceInstructionsV1 Response Bean: ' + responseBean);

            }else {

                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.MB_LIST_SOURCE_INSTRUCTIONS_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = MBListSourceInstructionsV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_LIST_SOURCE_INSTRUCTIONS_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                insert log;
                System.debug(message);

            }
        } catch (Exception e) {

            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBListSourceInstructionsV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_LIST_SOURCE_INSTRUCTIONS_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            insert log;
            System.debug(message);

        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
    
    
   
     public static Map<MBListSourceInstructionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> mbListSourceInstructions(String cif, String acc) {

        Sys_Log_Integration__c log;

        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        MBListSourceInstructionsV1_Resp_IB_v1 responseBean;
        Map<MBListSourceInstructionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBListSourceInstructionsV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();

        Integration_API__c integrationSettings;

        try {

            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_LIST_SOURCE_INSTRUCTIONS_V1);

            if (integrationSettings != null) {

                MBListSourceInstructionsV1_Req_IB_v1 requestBean = MBListSourceInstructionsV1_IU_v1.mapRequest(cif, acc);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_LIST_SOURCE_INSTRUCTIONS_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('MBListSourceInstructionsV1 Response: ' + response);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                insert log;
                responseBean = MBListSourceInstructionsV1_IU_v1.mapResponseFields(response);

                System.debug('MBListSourceInstructionsV1 Response Bean: ' + responseBean);

            }else {

                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.MB_LIST_SOURCE_INSTRUCTIONS_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = MBListSourceInstructionsV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_LIST_SOURCE_INSTRUCTIONS_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                insert log;
                System.debug(message);

            }
        } catch (Exception e) {

            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBListSourceInstructionsV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_LIST_SOURCE_INSTRUCTIONS_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            insert log;
            System.debug(message);

        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
}