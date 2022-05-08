/**
* Descripton: Apex/Integration Handler class for nQcreateNewOrAddRecipientV2 service
* Test Class Name: nqcreateneworaddrecipientv2_IH_v1
* @author  Muvhuso Nekhubvi : Absa
* @since   2020-16-04
*
**/
public class nQcreateNewOrAddRecipientV2_IH_v2 {
	public static Map<nQcreateNewOrAddRecipientV2_Resp_IB_v2, List<Sys_Log_Integration__c>> nQcreateNewOrAddRecipientV2(String CIF , String accountNumber,String siteCode, String tellerCode, String sbuCd, String recipName, String contactPref,String language,String email, String cellPhone, String prodArea , boolean payment ,boolean withDrawal,boolean  deposit, boolean  transfer, boolean returned, boolean scheduled,boolean purchase, String notifyTimes, String balanceUpdates, String minimumAmount) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        nQcreateNewOrAddRecipientV2_Resp_IB_v2 responseBean;
        Map<nQcreateNewOrAddRecipientV2_Resp_IB_v2, List<Sys_Log_Integration__c>> responseMap = new Map<nQcreateNewOrAddRecipientV2_Resp_IB_v2, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.nqcreateneworaddrecipientv2_STRING);

            if (integrationSettings != null) {
                nQcreateNewOrAddRecipientV2_Req_IB_v2 requestBean = nQcreateNewOrAddRecipientV2_IU_v2.mapRequestdFields(CIF, accountNumber, siteCode, tellerCode, sbuCd, recipName, contactPref, language, email, cellPhone, prodArea, payment, withDrawal, deposit, transfer, returned, scheduled, purchase, notifyTimes, balanceUpdates, minimumAmount);

                String jsonString = JSON.serialize(requestBean, true);
                
                system.debug('JSON Request ****' + jsonString);
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_nqcreateneworaddrecipientv2_GET_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('sMgetAsvSuretyshipsV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = nQcreateNewOrAddRecipientV2_IU_v2.mapResponseFields(response);

                System.debug('nQcreateNewOrAddRecipientV2 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API + '. Service: ' + StringConstants.SM_GET_ASV_SURETYSHIPS_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = nQcreateNewOrAddRecipientV2_IU_v2.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_nqcreateneworaddrecipientv2_GET_STATUS, StringConstants.nqcreateneworaddrecipientv2_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = nQcreateNewOrAddRecipientV2_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_nqcreateneworaddrecipientv2_GET_STATUS, StringConstants.nqcreateneworaddrecipientv2_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
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