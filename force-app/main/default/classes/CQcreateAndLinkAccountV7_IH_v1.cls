/*
 * Integration Handler for CQcreateAndLinkAccountV7 Service
 * @author Prashant Jain
 * @created 2020-02-21
 */

public class CQcreateAndLinkAccountV7_IH_v1 {
    public static Map<CQcreateAndLinkAccountV7_Resp_IB_v1, List<Sys_Log_Integration__c>> CQcreateAndLinkAccountV7(String accountNbr, String openSite, String controlSite, String cifKey, String tellerNbr, String controllerNbr, String workstationNbr, String product, String applicationNbr, String controlSiteType, String openSiteType, String effectiveDate, String marketersCode, String provChqBookInd, String cbpSchemeCode, String cbpPrimaryAccount, String srcOfFnds1, String srcOfFnds2, String srcOfFnds3, String srcOfFnds4, String srcOfFnds5, String digitalChannel, String rbaEdd) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CQcreateAndLinkAccountV7_Resp_IB_v1 responseBean;
        Map<CQcreateAndLinkAccountV7_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CQcreateAndLinkAccountV7_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CQ_CREATE_AND_LINK_ACCOUNT_V7);

            if (integrationSettings != null) {
                CQcreateAndLinkAccountV7_Req_IB_v1 requestBean = CQcreateAndLinkAccountV7_IU_v1.mapRequestFields(accountNbr, openSite, controlSite, cifKey, tellerNbr, controllerNbr, workstationNbr, product, applicationNbr, controlSiteType, openSiteType, effectiveDate, marketersCode, provChqBookInd, cbpSchemeCode, cbpPrimaryAccount, srcOfFnds1, srcOfFnds2, srcOfFnds3, srcOfFnds4, srcOfFnds5, digitalChannel, rbaEdd);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CQ_CREATE_AND_LINK_ACCOUNT_V7, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('CQcreateAndLinkAccountV7 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = CQcreateAndLinkAccountV7_IU_v1.mapResponseFields(response);

                System.debug('CQcreateAndLinkAccountV7 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' + StringConstants.CQ_CREATE_AND_LINK_ACCOUNT_V7 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = CQcreateAndLinkAccountV7_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CQ_CREATE_AND_LINK_ACCOUNT_V7, StringConstants.CQCREATEANDLINKACCOUNTV7_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = CQcreateAndLinkAccountV7_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CQ_CREATE_AND_LINK_ACCOUNT_V7, StringConstants.CQCREATEANDLINKACCOUNTV7_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
}