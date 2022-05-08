/*
 * Integration Handler for CqUpdAcctDomicileChangev2 Service
 * @author Saurabh Pandey
 * @created 2020-04-07
 */
public class CqUpdAcctDomicileChangev2_IH_v1 {

        public static Map<CqUpdAcctDomicileChangev2_Resp_IB_v1, List<Sys_Log_Integration__c>> CqUpdAcctDomicileChangev2(String accountNbr,String newBranch, String branchCode, String tellerCode, String supervisorCode) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CqUpdAcctDomicileChangev2_Resp_IB_v1 responseBean;
        Map<CqUpdAcctDomicileChangev2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CqUpdAcctDomicileChangev2_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try { //JITTERBIT_API //JITTERBIT_API_WORKAROUND
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API, Sys_Utilities_General.getEnvironment(), StringConstants.CQ_UPDATEACC_DOMICILE_CHANGE);

            if (integrationSettings != null) {
                CqUpdAcctDomicileChangev2_Req_IB_v1 requestBean = CqUpdAcctDomicileChangev2_IU_v1.mapRequestFields(accountNbr,newBranch,branchCode,tellerCode,supervisorCode);

                String jsonString = JSON.serialize(requestBean, true);
                system.debug('JSON String request'+jsonString);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CQ_UPDATEACC_DOMICILE_CHANGE, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('CqUpdAcctDomicileChangev2 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = CqUpdAcctDomicileChangev2_IU_v1.mapResponseFields(response);

                System.debug('CqUpdAcctDomicileChangev2 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' + StringConstants.CQ_UPDATEACC_DOMICILE_CHANGE + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = CqUpdAcctDomicileChangev2_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CQ_UPDATEACC_DOMICILE_CHANGE, StringConstants.CQ_UPDATEACC_DOMICILE_CHANGE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = CqUpdAcctDomicileChangev2_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CQ_UPDATEACC_DOMICILE_CHANGE, StringConstants.CQ_UPDATEACC_DOMICILE_CHANGE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }

}