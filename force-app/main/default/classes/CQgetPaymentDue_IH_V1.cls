/*
 * Integration Handler Bean for CQGetPaymentDue Service
 * @author Haritha Police
 * @created 2019-09-14
 */

public class CQgetPaymentDue_IH_V1 {
    
    public static Map<CQgetPaymentDue_Resp_IB_V1, List<Sys_Log_Integration__c>> getCQPaymentDueResponseDetails(String channelP,String applicationP,String traceP,String msgLanguageP,String msgTargetP,String accountNbrP,String agencyCodeP,String siteCodeP,String tellerCodeP,String controllerCodeP){
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CQgetPaymentDue_Resp_IB_V1 responseBean;
        Map<CQgetPaymentDue_Resp_IB_V1, List<Sys_Log_Integration__c>> responseMap = new Map<CQgetPaymentDue_Resp_IB_V1, List<Sys_Log_Integration__c>>();
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_CQ_PaymentDueV1);
			system.debug('integrationSettings****'+integrationSettings);
            if(integrationSettings != null){
                //Map Request Fields
                CQgetPaymentDue_Req_IB_V1 CQgetPaymentDueRequest = CQgetPaymentDue_IU_V5.mapRequestFields(accountNbrP,agencyCodeP,siteCodeP,tellerCodeP,controllerCodeP);
                
                String jsonString = CQgetPaymentDueRequest.serialize( CQgetPaymentDueRequest );
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCallout(Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString));
                
                ///Map Response Fields
                responseBean = CQgetPaymentDue_IU_V5.mapResponseFields(response);
                
            }else{
                system.debug('No Integration Settings Found****'+integrationSettings);
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_CQ_PaymentDueV1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CQ_PAYMENT_DUE, StringConstants.CQ_PAYMENT_DUE_STRING , 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = CQgetPaymentDue_IU_V5.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            	System.debug(message);
            }
            
        }catch(Exception e){
            //Map bad response and create a log
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CQ_PAYMENT_DUE, StringConstants.CQ_PAYMENT_DUE_STRING , 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = CQgetPaymentDue_IU_V5.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
        }
      if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }

}