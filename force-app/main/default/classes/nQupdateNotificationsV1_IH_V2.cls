/**
* Descripton: Apex/Integration Handler class for nQcreateNewOrAddRecipientV2 service
* Test Class Name: nQupdateNotificationsV1_IH_v1
* @author  Muvhuso Nekhubvi : Absa
* @since   2020-16-04
*
**/
public class nQupdateNotificationsV1_IH_V2 {
    
    public static Map<nQupdateNotificationsV1_Resp_IB_v2, List<Sys_Log_Integration__c>> nQupdateNotificationsV1(String CIF , String accountNumber,String siteCode, String tellerCode , String prodArea , boolean payment ,boolean withDrawal,boolean  deposit, boolean  transfer, boolean returned, boolean scheduled,boolean purchase, String notifyTimes, String balanceUpdates, String minimumAmount) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        nQupdateNotificationsV1_Resp_IB_v2 responseBean;
        Map<nQupdateNotificationsV1_Resp_IB_v2, List<Sys_Log_Integration__c>> responseMap = new Map<nQupdateNotificationsV1_Resp_IB_v2, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.nqupdatenotificationsv1_STRING);

            if (integrationSettings != null) {
                nQupdateNotificationsV1_Req_IB_v2 requestBean = nQupdateNotificationsV1_IU_V2.mapRequestdFields(CIF, accountNumber, siteCode, tellerCode,prodArea, payment, withDrawal, deposit, transfer, returned, scheduled, purchase, notifyTimes, balanceUpdates, minimumAmount);

                String jsonString = JSON.serialize(requestBean, true);
                
                system.debug('JSON Request ****' + jsonString);
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_nqupdatenotificationsv1_GET_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('sMgetAsvSuretyshipsV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = nQupdateNotificationsV1_IU_V2.mapResponseFields(response);

                System.debug('nQcreateNewOrAddRecipientV2 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API + '. Service: ' + StringConstants.SM_GET_ASV_SURETYSHIPS_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = nQupdateNotificationsV1_IU_V2.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_nqupdatenotificationsv1_GET_STATUS, StringConstants.nqupdatenotificationsv1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = nQupdateNotificationsV1_IU_V2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_nqupdatenotificationsv1_GET_STATUS, StringConstants.nqupdatenotificationsv1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
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