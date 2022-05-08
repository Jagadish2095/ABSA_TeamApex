public class SVgetAccountHoldsDetailV4_IH_v1 {
     /* Makes the callout to cqgetacctholdsmaintV4
    * @param: accountNumber
    * @return: CQgetAcctHolds_Resp_IB_v1 object 
   */
    
    public static Map<SVgetAccountHoldsDetailV4_Resp_IB_v1, List<Sys_Log_Integration__c>> callTosvgetaccountholdsdetailv4(String accountNo,String teller, String siteCode, String supervisorCode){//(SVgetAccountHoldsDetailV4_Req_IB_v1  requestBean) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        SVgetAccountHoldsDetailV4_Resp_IB_v1 ListRespBean = new SVgetAccountHoldsDetailV4_Resp_IB_v1();
        Map<SVgetAccountHoldsDetailV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<SVgetAccountHoldsDetailV4_Resp_IB_v1, List<Sys_Log_Integration__c>>(); 
 
        try{
            
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.SV_GET_ACCOUNT_HOLDS);
            
            //if(integrationSettings!=null || Test.isRunningTest() || integrationSettings == null){
                if(integrationSettings != null){
                SVgetAccountHoldsDetailV4_Req_IB_v1  requestBean = SVgetAccountHoldsDetailV4_IU_v1.mapRequestdFields(accountNo,teller,siteCode,supervisorCode);
           
                String jsonString = JSON.serialize(requestBean, true);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_SV_GET_ACCOUNT_HOLDS, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                 system.debug('request: ' + request);
                system.debug('response: ' + response);
                system.debug('log: ' + log);
                    
                //   HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);            
                //log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_IB_CANCEL_SERVICE, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                
                if(response!=null){
                if(response.getStatusCode() == 200){
                   
                    ListRespBean = (SVgetAccountHoldsDetailV4_Resp_IB_v1) JSON.deserialize(response.getBody(), SVgetAccountHoldsDetailV4_Resp_IB_v1.class); 
                    ListRespBean.statusCode = response.getStatusCode();
                    ListRespBean.message = response.getStatus() ;
 
                    
                } else{
                    System.debug('Status Code NOT 200 - FAILURE'); 
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    ListRespBean = SVgetAccountHoldsDetailV4_IU_v1.mapFailedResponseFields(response.getStatusCode(),response.getStatus(), response.getBody());

                }
                 
            }
            }else{
                //No Integration Settings Found
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.ESP_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    ListRespBean = SVgetAccountHoldsDetailV4_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_SV_GET_ACCOUNT_HOLDS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                   
            }
                
            if (log != null) {
                logList.add(log);
            }
            responseMap.put(ListRespBean, logList);
            system.debug(responseMap);
            return responseMap;
            
        }
        catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            ListRespBean = SVgetAccountHoldsDetailV4_IU_v1.mapFailedResponseFields( 500,StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_SV_GET_ACCOUNT_HOLDS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }

            
            if (log != null) {
                  insert log;
                logList.add(log);
            }
            responseMap.put(ListRespBean, logList);
            system.debug(responseMap);
            return responseMap;
            
        } 
    


    


}