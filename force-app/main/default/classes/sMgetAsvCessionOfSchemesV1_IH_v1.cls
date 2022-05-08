/**
 * @description       : Integration Handler for sMgetAsvCessionOfSchemesV1 Service
 * @author            : Prashant Jain
 * @last modified on  : 2021-06-11
 * @last modified by  : Prashant Jain
 * Modifications Log 
 * Ver   Date         Author          Modification
 * 1.0   2021-06-11   Prashant Jain   Initial Version
**/


public class sMgetAsvCessionOfSchemesV1_IH_v1 {
    /**
    * @description 
    * @author Prashant Jain | 2021-06-11 
    * @param clcdData 
    * @return Map<sMgetAsvCessionOfSchemesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> 
    **/
    public static Map<sMgetAsvCessionOfSchemesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> sMgetAsvCessionOfSchemesV1(String clcdData) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        sMgetAsvCessionOfSchemesV1_Resp_IB_v1 responseBean;
        Map<sMgetAsvCessionOfSchemesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<sMgetAsvCessionOfSchemesV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API, Sys_Utilities_General.getEnvironment(), StringConstants.SM_GET_ASV_CESSION_OF_SCHEMES_V1);

            if (integrationSettings != null) {
                sMgetAsvCessionOfSchemesV1_Req_IB_v1 requestBean = sMgetAsvCessionOfSchemesV1_IU_v1.mapRequestFields(clcdData);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_SM_GET_ASV_CESSION_OF_SCHEMES_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('sMgetAsvCessionOfSchemesV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = sMgetAsvCessionOfSchemesV1_IU_v1.mapResponseFields(response);

                System.debug('sMgetAsvCessionOfSchemesV1 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API + '. Service: ' + StringConstants.SM_GET_ASV_CESSION_OF_SCHEMES_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = sMgetAsvCessionOfSchemesV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_SM_GET_ASV_CESSION_OF_SCHEMES_V1, StringConstants.SMGETASVCESSIONOFSCHEMESV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = sMgetAsvCessionOfSchemesV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_SM_GET_ASV_CESSION_OF_SCHEMES_V1, StringConstants.SMGETASVCESSIONOFSCHEMESV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
}