/**
* Descripton: Apex/Integration Handler class for NQcancelAnAcctJVProdNotificationV1 service
* Test Class Name: nQcancelAnAcctJVProdNotifV1_IH_v1
* @author  Muvhuso Nekhubvi : Absa
* @since   2020-16-04
*
**/
public class nQcancelAnAcctJVProdNotifV1_IH_v1 {
	public static Map<nQcancelAnAcctJVProdNotifV1_Resp_IB_v1, List<Sys_Log_Integration__c>> nQcancelAnAcctJVProdNotificationV1(String CIF , String accountNumber,String siteCode) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        nQcancelAnAcctJVProdNotifV1_Resp_IB_v1 responseBean;
        Map<nQcancelAnAcctJVProdNotifV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<nQcancelAnAcctJVProdNotifV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.nqcancelacctnotificationv1_STRING);

            if (integrationSettings != null) {
                nQcancelAnAcctJVProdNotifV1_Req_IB_v1 requestBean = nQcancelAnAcctJVProdNotifV1_IU_v1.mapRequestdFields(CIF, accountNumber, siteCode);

                String jsonString = JSON.serialize(requestBean, true);
                
                system.debug('JSON Request ****' + jsonString);
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_nqcancelacctnotificationv1_GET_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('sMgetAsvSuretyshipsV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = nQcancelAnAcctJVProdNotifV1_IU_v1.mapResponseFields(response);

                System.debug('nQcreateNewOrAddRecipientV2 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API + '. Service: ' + StringConstants.SM_GET_ASV_SURETYSHIPS_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = nQcancelAnAcctJVProdNotifV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_nqcancelacctnotificationv1_GET_STATUS, StringConstants.METHOD_nqcancelacctnotificationv1_GET_STATUS, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = nQcancelAnAcctJVProdNotifV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_nqcancelacctnotificationv1_GET_STATUS, StringConstants.METHOD_nqcancelacctnotificationv1_GET_STATUS, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
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