/*
* Integration Handler for EImaintainESDDetailsV3 Service
* @author Muvhuso Nekhubvi
* @created 2020/04/07
*/
public class EImaintainESDDetailsV3_IH_v1 {
	public static Map<EImaintainESDDetailsV3_Resp_IB_v1, List<Sys_Log_Integration__c>> sImaintainESDDetailsV3(String requests , String site , String teller, String accountNumber, String product , String email) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        EImaintainESDDetailsV3_Resp_IB_v1 responseBean;
        Map<EImaintainESDDetailsV3_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<EImaintainESDDetailsV3_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.EI_maintain_ESD_DetailsV3);

            if (integrationSettings != null) {
                
                EImaintainESDDetailsV3_Req_IB_v1 requestBean = EImaintainESDDetailsV3_IU_v1.mapRequestFields(requests ,site ,teller,accountNumber,product,email);

                String jsonString = JSON.serialize(requestBean, true);
                
                system.debug('JSON Request ****' + jsonString);
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_EI_MAINTAIN_ESD_DETAILSV3, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('EImaintainESDDetailsV3 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = EImaintainESDDetailsV3_IU_v1.mapResponseFields(response);

                System.debug('EImaintainESDDetailsV3 Response Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API + '. Service: ' + StringConstants.EI_maintain_ESD_DetailsV3 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = EImaintainESDDetailsV3_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_EI_MAINTAIN_ESD_DETAILSV3, StringConstants.EI_maintain_ESD_DetailsV3, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = EImaintainESDDetailsV3_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_EI_MAINTAIN_ESD_DETAILSV3, StringConstants.EI_maintain_ESD_DetailsV3, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
}