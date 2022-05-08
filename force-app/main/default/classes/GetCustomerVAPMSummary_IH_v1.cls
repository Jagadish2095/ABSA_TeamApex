/**
* GetCustomerVAPMSummary_IH_v1
*
* @author  Muvhuso Nekhubvi : Absa
* @since   2019-09-13
*
*
*
**/
public class GetCustomerVAPMSummary_IH_v1 {
    
    public static Map<GetCustomerVAPMSummary_Resp_IB_v1, List<Sys_Log_Integration__c>> GetCustomerVapmSummary(String customerKey){
        
        GetCustomerVAPMSummary_Resp_IB_v1 ServiceRespBean;
        
        
		Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        GetCustomerVAPMSummary_Resp_IB_v1 responseBean;
		Map<GetCustomerVAPMSummary_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<GetCustomerVAPMSummary_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;

        try{
            
            String queryString = '';
            
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_CUSTOMER_VAPM_SUMMARY);
                
                
                if(integrationSettings != null){
                    
                    GetCustomerVAPMSummary_Req_IB_v1 requestBean = GetCustomerVAPMSummary_IU_v1.mapRequestdFields(customerKey);
                    
                    queryString = JSON.serialize(requestBean, true);
					//Send request
					HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], queryString);
                    
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.GET_CUSTOMER_VAPM_SUMMARY, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                    
					
					
					log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
					
                    ///Map Response Fields
                    ServiceRespBean = GetCustomerVAPMSummary_IU_v1.mapResponseFields(response);
					
                    
                    
                }else{
                    
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_CLIENT_DETAILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_VAPM_GET_CUSTOMER_SUMMARY, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    ServiceRespBean = GetCustomerVAPMSummary_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                    System.debug(message);
                }
            
        }catch(Exception e){
                //Exception
                
                String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_VAPM_GET_CUSTOMER_SUMMARY, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                ServiceRespBean = GetCustomerVAPMSummary_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
        }
        
		 if (log != null) {
            logList.add(log);
        }

        responseMap.put(ServiceRespBean, logList);
        return responseMap;
		

}
}