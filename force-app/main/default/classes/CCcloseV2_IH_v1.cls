/*
* Integration Handler for  CCcloseV2_IH_v1 service
* @author Lulu Rankwe
* @created March 202o
*/
public class CCcloseV2_IH_v1 {
        public static Map<CCcloseV2_Resp_IB_v1, List<Sys_Log_Integration__c>> closeCombiCard(String combiNbr,String reason,String subReason){ 
        // public static Map<CCGetPortfolioDetailV1_Resp_IB_v1, List<Sys_Log_Integration__c>> CCGetPortfolioDetailV1(String combiNbr) {
        Sys_Log_Integration__c log;                                                  
        CCcloseV2_Resp_IB_v1 responseBean;
        Integration_API__c integrationSettings;
         List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Map<CCcloseV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CCcloseV2_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        
       try{       
           
           integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CCCLOSE);
			system.debug('Integration result: ' + integrationSettings);
           if(integrationSettings != null){
                
               String reasonTrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.StopReplaceCard_STRING ,'Reason', reason, StringConstants.OUTBOUND_RECORD_TYPE);
               String subReasonTrans = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.StopReplaceCard_STRING ,'Sub Reason', subReason, StringConstants.OUTBOUND_RECORD_TYPE);  
        
               
                CCcloseV2_Req_IB_v1 requestBean = CCcloseV2_IU_v1.mapRequestFields(combiNbr,reasonTrans,subReasonTrans);
                String jsonString = JSON.serialize(requestBean, true);  
                
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);            	 
                
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CCCLOSE, StringConstants.SALESFORCE_STRING, request.getEndpoint());
               
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);              
               if(response.getStatusCode() == 200){
                   
                   log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());                
                   responseBean = CCcloseV2_IU_v1.mapResponseFields(response); 
                    responseBean = (CCcloseV2_Resp_IB_v1) JSON.deserialize(response.getBody(), CCcloseV2_Resp_IB_v1.class); 
                    responseBean.statusCode = response.getStatusCode();
                    responseBean.message = response.getStatus() ;
                   
                }else{

                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    responseBean = CCcloseV2_IU_v1.mapFailedResponseFields(response.getStatus(),response.getStatusCode(), response.getBody());
                }
                
            }else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CCCLOSE + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CCCLOSE, StringConstants.API_MANAGER, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = CCcloseV2_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
            }
        }catch(Exception e)
        {
            
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = CCcloseV2_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CCCLOSE, StringConstants.CCCLOSE, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
           // System.debug(message);
        }
        if(log != null)
        {
            insert log;
            system.debug('Logs: ' + log);
        }
        
    
        responseMap.put(responseBean, logList);
        system.debug(responseMap);
         
        return responseMap;
    }


}