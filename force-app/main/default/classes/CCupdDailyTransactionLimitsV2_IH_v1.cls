/*
 * Integration Handler for CCgetDailyLimits Service
 * @author Muvhuso Nekhubvi
 * @created 2019-10-09
 */

public class CCupdDailyTransactionLimitsV2_IH_v1 {
   
     public static Map<CCupdDailyTransactionLimitsV2_Resp_IB_v1, List<Sys_Log_Integration__c>> CCupdateDailyLimits(String telerCode , String workStation, String supervisor , String branchCode, String combiNbr, String cardCshLim, String cardTrfLim, String cardPosLim, String cardCntLim, String cheqNomAcc, String cheqApplNo, String cheqCshLim, String cheqTrfLim, String cheqPosLim,String savsNomAcc,String savsApplNo, String savsCshLim, String savsTrfLim, String savsPosLim) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CCupdDailyTransactionLimitsV2_Resp_IB_v1 responseBean;
        Map<CCupdDailyTransactionLimitsV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CCupdDailyTransactionLimitsV2_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try {
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CC_UPDATE_DAILY_LIMITS);

            if (integrationSettings != null) {
                CCupdDailyTransactionLimitsV2_Req_IB_v1 requestBean = CCupdDailyTransactionLimitsV2_UI_v1.mapRequestFields(telerCode ,workStation,supervisor ,branchCode,combiNbr,cardCshLim,cardTrfLim,cardPosLim,cardCntLim,cheqNomAcc,cheqApplNo,cheqCshLim,cheqTrfLim,cheqPosLim,savsNomAcc,savsApplNo,savsCshLim,savsTrfLim,savsPosLim);

                String jsonString = JSON.serialize(requestBean, true);
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CC_UPDATE_DAILY_LIMITS, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('CCupdateDailyLimits Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                responseBean = CCupdDailyTransactionLimitsV2_UI_v1.mapResponseFields(response);

                System.debug('CCupdateDailyLimits Request Bean: ' + responseBean);
            } else {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' + StringConstants.METHOD_CC_UPDATE_DAILY_LIMITS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = CCupdDailyTransactionLimitsV2_UI_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CC_UPDATE_DAILY_LIMITS, StringConstants.CCGETDAILYLIMITS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        } catch (Exception e) {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = CCupdDailyTransactionLimitsV2_UI_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CC_GET_DAILY_LIMITS, StringConstants.CC_UPDATE_DAILY_LIMITS, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }

}