/*
* Integration Handler for NHUPDATEPAUSECARDV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/23
*/
public class nHupdatePauseCardV1_IH_v1 {
	public static Map<nHupdatePauseCardV1_Resp_IB_v1, List<Sys_Log_Integration__c>> nHupdatePauseardv1(String accessNumber ,String tellerCode, String supervisor, String branchCode, String pauseHold,String iatmHold, String iposHold, String latmHold,String lposHold, String cnpHold, String digwHold, String pauseDate, String language , String action , String cardNbr) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        nHupdatePauseCardV1_Resp_IB_v1 responseBean;
        Map<nHupdatePauseCardV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<nHupdatePauseCardV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.NHUPDATEPAUSECARDV1_STRING);

            if (integrationSettings != null) {
                
                nHupdatePauseCardV1_Req_IB_v1 requestBean = nHupdatePauseCardV1_IU_v1.mapRequestFields(accessNumber, tellerCode, supervisor, branchCode, pauseHold, iatmHold, iposHold, latmHold,lposHold, cnpHold, digwHold, pauseDate, language, action, cardNbr);

                String jsonString = JSON.serialize(requestBean, true);
                
                system.debug('JSON Request ****' + jsonString);
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_NHUPDATEPAUSECARDV1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('NHUPDATEPAUSECARDV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = nHupdatePauseCardV1_IU_v1.mapResponseFields(response);

                System.debug('NHUPDATEPAUSECARDV1 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.NHUPDATEPAUSECARDV1_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = nHupdatePauseCardV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_NHUPDATEPAUSECARDV1, StringConstants.NHUPDATEPAUSECARDV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = nHupdatePauseCardV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_NHUPDATEPAUSECARDV1, StringConstants.NHUPDATEPAUSECARDV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
}