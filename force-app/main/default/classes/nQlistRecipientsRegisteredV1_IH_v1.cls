/*
* Integration Handler for NQlistRecipientsRegisteredForCustV1 Service
* @author Muvhuso Nekhubvi
* @created 2020/05/18
*/
public class nQlistRecipientsRegisteredV1_IH_v1 {
	public static Map<nQlistRecipientsRegisteredV1_Resp_IB_v1, List<Sys_Log_Integration__c>> getRecipientsRegisteredDetails(String clientCode , String registeredSite) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        nQlistRecipientsRegisteredV1_Resp_IB_v1 responseBean;
        Map<nQlistRecipientsRegisteredV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<nQlistRecipientsRegisteredV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.NQLISTRECIPIENTSREGISTEREDFORCUSTV1_STRING);

            if (integrationSettings != null) {
                
                nQlistRecipientsRegisteredV1_Req_IB_v1 requestBean = nQlistRecipientsRegisteredV1_IU_v1.mapRequestFields(clientCode ,registeredSite);

                String jsonString = JSON.serialize(requestBean, true);
                
                system.debug('JSON Request ****' + jsonString);
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_NQLISTRECIPIENTSREGISTEREDFORCUSTV1_STRING, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('NQlistRecipientsRegisteredForCustV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = nQlistRecipientsRegisteredV1_IU_v1.mapResponseFields(response);

                System.debug('NQlistRecipientsRegisteredForCustV1 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.EI_maintain_ESD_DetailsV3 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = nQlistRecipientsRegisteredV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_NQLISTRECIPIENTSREGISTEREDFORCUSTV1_STRING, StringConstants.NQLISTRECIPIENTSREGISTEREDFORCUSTV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = nQlistRecipientsRegisteredV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_NQLISTRECIPIENTSREGISTEREDFORCUSTV1_STRING, StringConstants.NQLISTRECIPIENTSREGISTEREDFORCUSTV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
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