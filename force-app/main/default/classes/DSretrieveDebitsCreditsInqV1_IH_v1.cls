/*
 * Integration Handler for DSretrieveDebitsCreditsInq Service
 * @author Prasanna Patwardhan
 * @created 2019-10-30
 */
public class DSretrieveDebitsCreditsInqV1_IH_v1 {
    /* Makes the callout to DSretrieveDebitsCreditsInq
    * @param: acctNo
    * @param: frmdate
    * @return: DSretrieveDebitsCreditsInqV1_Resp_IB_v1 bean object
    * */
    public static Map<DSretrieveDebitsCreditsInqV1_Resp_IB_v1, List<Sys_Log_Integration__c>> DSretrieveDebitsCreditsInqV1Details(String acctNo, String frmDate){
               
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        DSretrieveDebitsCreditsInqV1_Resp_IB_v1 responseBean;
        Map<DSretrieveDebitsCreditsInqV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<DSretrieveDebitsCreditsInqV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;
        
        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.DEBIT_RETRI_DETAILS_CARD_V1);
            if (integrationSettings != null) {
                DSretrieveDebitsCreditsInqV1_Req_IB_v1 requestBean = DSretrieveDebitsCreditsInqV1_IU_v1.mapRequestFields(acctNo, frmDate);
                String jsonString = JSON.serialize(requestBean, true);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_RETRI_DEBIT_CARD_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());
				//Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                System.debug('DSretrieveDebitsCreditsInq Response: ' + response);
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                responseBean = DSretrieveDebitsCreditsInqV1_IU_v1.mapResponseFields(response);
				System.debug('DSretrieveDebitsCreditsInq Request Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' + StringConstants.DEBIT_RETRI_DETAILS_CARD_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = DSretrieveDebitsCreditsInqV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_RETRI_DEBIT_CARD_V1, StringConstants.DEBIT_RETRI_DETAILS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = DSretrieveDebitsCreditsInqV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_RETRI_DEBIT_CARD_V1, StringConstants.DEBIT_RETRI_DETAILS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }

}