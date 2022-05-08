/*
 * Test Integration Handler for NQreplaceRecipientsAcrossAllAcntsV1 Service
 * @author Muvhuso Nekhubvi
 * @created 2020-05-18
 */
public class nQreplaceRecipientsV1_IH_v1 {
	public static Map<nQreplaceRecipientsV1_Resp_v1, List<Sys_Log_Integration__c>> updateRecipients(String clientCode,String registrationSite ,String recipNm, String contactPref, String language, String email , String cellphone) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        nQreplaceRecipientsV1_Resp_v1 responseBean;
        Map<nQreplaceRecipientsV1_Resp_v1, List<Sys_Log_Integration__c>> responseMap = new Map<nQreplaceRecipientsV1_Resp_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.NQREPLACERECIPIENTSACROSSALLACNTSV1_STRING);

            if (integrationSettings != null) {
                
                nQreplaceRecipientsV1_Req_v1 requestBean = nQreplaceRecipientsV1_IU_v1.mapRequestFields(clientCode, recipNm , registrationSite, contactPref, language, email, cellphone);

                String jsonString = JSON.serialize(requestBean, true);
                
                system.debug('JSON Request ****' + jsonString);
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_NQREPLACERECIPIENTSACROSSALLACNTSV1_STRING, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('NQlistRecipientsRegisteredForCustV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = nQreplaceRecipientsV1_IU_v1.mapResponseFields(response);

                System.debug('NQlistRecipientsRegisteredForCustV1 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.EI_maintain_ESD_DetailsV3 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = nQreplaceRecipientsV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_NQREPLACERECIPIENTSACROSSALLACNTSV1_STRING, StringConstants.NQREPLACERECIPIENTSACROSSALLACNTSV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = nQreplaceRecipientsV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_NQREPLACERECIPIENTSACROSSALLACNTSV1_STRING, StringConstants.NQREPLACERECIPIENTSACROSSALLACNTSV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
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