/*
 * Integration Handler for GBcreateCmsContOffLinkV1 Service
 * @author Diksha Wasekar
 * @created 2020-04-03
 */

public class GBcreateCmsContOffLinkV1_IH_v1 {
    public static Map<GBcreateCmsContOffLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> GBcreateCmsContOffLinkV1(String clientCode,String branchCode,String bankingSector,String indvGroup,String contOffType,String contOffNum,String capByEmployee,String appByEmployee,String overallControl,String businessSeg,String businessSubSeg,String franchisorCode) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        GBcreateCmsContOffLinkV1_Resp_IB_v1 responseBean;
        Map<GBcreateCmsContOffLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<GBcreateCmsContOffLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.GB_CREATE_CMS_CONTOFFLINK_V1);

            if (integrationSettings != null) {

                GBcreateCmsContOffLinkV1_Req_IB_v1 requestBean = GBcreateCmsContOffLinkV1_IU_v1.mapRequestFields(clientCode,branchCode,bankingSector,indvGroup,contOffType,contOffNum,capByEmployee,appByEmployee,overallControl,businessSeg,businessSubSeg,franchisorCode);
                
                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_GB_CREATE_CMS_CONTOFFLINK_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('GBcreateCmsContOffLinkV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = GBcreateCmsContOffLinkV1_IU_v1.mapResponseFields(response);

                System.debug('GBcreateCmsContOffLinkV1 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' + StringConstants.GB_CREATE_CMS_CONTOFFLINK_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = GBcreateCmsContOffLinkV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GB_CREATE_CMS_CONTOFFLINK_V1, StringConstants.GBCREATECMSCONTOFFLINKV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = GBcreateCmsContOffLinkV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GB_CREATE_CMS_CONTOFFLINK_V1, StringConstants.GBCREATECMSCONTOFFLINKV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }


}