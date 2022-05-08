/*
* Integration Handler for Prediction Service
* @author Muvhuso Nekhubvi
* @created 2020/06/26
*/
public class Prediction_IH_v1 {

     public static Map<Prediction_Resp_IB_v1, List<Sys_Log_Integration__c>> Prediction(String caseId , String caseNo, String status , String serviceTypeId, String suppliedEmail,String subject,String description,String serviceGroup) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Prediction_Resp_IB_v1 responseBean;
        Map<Prediction_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<Prediction_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.PREDICTION_STRING);

            if (integrationSettings != null) {
                Prediction_Req_IB_v1 requestBean = Prediction_IU_v1.mapRequestFields(caseId,caseNo, status, serviceTypeId, suppliedEmail, subject, description, serviceGroup);

                String jsonString = JSON.serialize(requestBean, true);

                system.debug('JSON Request ****' + jsonString);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_PREDICTION_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('Prediction Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = Prediction_IU_v1.mapResponseFields(response);

                System.debug('Prediction Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API + '. Service: ' + StringConstants.SM_GET_ASV_SURETYSHIPS_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = Prediction_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_PREDICTION_V1, StringConstants.PREDICTION_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = Prediction_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_PREDICTION_V1, StringConstants.PREDICTION_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            insert log;
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }

}