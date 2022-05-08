/*
* Integration Handler for  MBcomplEpSpaymentV4 service
* @author Lulu Rankwe
* @created March 2020
*/
public class MBcomplEpSpaymentV4_IH_v1 {
    
    public static MBcomplEpSpaymentV4_Resp_IB_v1 mBcomplEpSpaymentV4(String uniqueEft){ 
        
        Sys_Log_Integration__c log;                                                  
        MBcomplEpSpaymentV4_Resp_IB_v1 responseBean;
        Integration_API__c integrationSettings;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Map<MBcomplEpSpaymentV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBcomplEpSpaymentV4_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        
        try{       
            
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_COMPL_EPS_PAYMENT);
            system.debug('Integration result: ' + integrationSettings);
            if(integrationSettings != null){
                
                MBcomplEpSpaymentV4_Req_IB_v1 requestBean = MBcomplEpSpaymentV4_IU_v1.mapRequestFields(uniqueEft);
                String jsonString = JSON.serialize(requestBean, true);  
                
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);            	 
                
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_COMPL_EPS_PAYMENT, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);              
                if(response.getStatusCode() == 200){
                    
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());                
                    responseBean = MBcomplEpSpaymentV4_IU_v1.mapResponseFields(response); 
                    system.debug('obj: ' + responseBean);
                    
                    
                }else{
                    
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());                    
                }
                
            }else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' +  StringConstants.MB_COMPL_EPS_PAYMENT + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_COMPL_EPS_PAYMENT, StringConstants.JITTERBIT_API_RB_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = MBcomplEpSpaymentV4_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
            }
        }catch(Exception e)
        {
            
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBcomplEpSpaymentV4_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_COMPL_EPS_PAYMENT, StringConstants.MB_COMPL_EPS_PAYMENT, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            // System.debug(message);
        }
        if(log != null)
        {
            insert log;
            system.debug('Logs: ' + log);
        }
        
        
        responseMap.put(responseBean, logList);
        system.debug(responseMap);
        
        return responseBean;
    }
    
    public static MBcomplEpSpaymentV4_Resp_IB_v1 payBeneficiary(String uniqueEft, String paymNo){ 
        
        Sys_Log_Integration__c log;                                                  
        MBcomplEpSpaymentV4_Resp_IB_v1 responseBean;
        Integration_API__c integrationSettings;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Map<MBcomplEpSpaymentV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBcomplEpSpaymentV4_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        
        try{       
            
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_COMPL_EPS_PAYMENT);
            system.debug('Integration result: ' + integrationSettings);
            if(integrationSettings != null){
                
                MBcomplEpSpaymentV4_Req_IB_v1 requestBean = MBcomplEpSpaymentV4_IU_v1.mapPayBeneficiaryRequestFields(uniqueEft,paymNo);
                String jsonString = JSON.serialize(requestBean, true);  
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);            	 
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_COMPL_EPS_PAYMENT, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);              
                if(response.getStatusCode() == 200){
                    
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());                
                    responseBean = MBcomplEpSpaymentV4_IU_v1.mapResponseFields(response); 
                    system.debug('obj: ' + responseBean);
                           
                }else{
                    
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());                    
                }
                
            }else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' +  StringConstants.MB_COMPL_EPS_PAYMENT + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_COMPL_EPS_PAYMENT, StringConstants.JITTERBIT_API_RB_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = MBcomplEpSpaymentV4_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
            }
        }catch(Exception e)
        {
            
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBcomplEpSpaymentV4_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_COMPL_EPS_PAYMENT, StringConstants.MB_COMPL_EPS_PAYMENT, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        
        if(log != null)
        {
            insert log;
            system.debug('Logs: ' + log);
        }
        responseMap.put(responseBean, logList);
        system.debug(responseMap);
        
        return responseBean;
    }
    
    
    
}