public class GetXmlWillDraft_IH_v1 
{
	public static GetXmlWillDraft_Resp_IB_v1 GetXmlWillDraft(String willNumberP)
    {        
        GetXmlWillDraft_Resp_IB_v1 responseBean;
        Sys_Log_Integration__c log;
        
        try
        {
            Integration_API__c integrationSettings;
            
            if(willNumberP != null && String.isNotBlank(willNumberP))
            {                
                integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_XML_WILL_DRAFT);
                
                if(integrationSettings != null)
                {                    
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], '');
                    request.setEndpoint(request.getEndpoint() + willNumberP);
                    
                    //System.debug('Request endpoint: ' + request.getEndpoint());
                    
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    
                    //Map response bean
                    responseBean = GetXmlWillDraft_IU_v1.mapResponseFields(response);                    
                }
                else
                {
                    //No Integration Settings Found
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_XML_WILL_DRAFT + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_XML_WILL_DRAFT, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    responseBean = GetXmlWillDraft_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
                    System.debug(message);
                }
            }
            else
            {
                //bad response bean and log for willNumber being null
                String message = StringConstants.ERROR_MSG_NO_WILL_NUMBER;
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_XML_WILL_DRAFT, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = GetXmlWillDraft_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
            } 
        }
        catch(Exception e)
        {
            //Exception response bean and log
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_XML_WILL_DRAFT, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = GetXmlWillDraft_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
        }
        if(log != null)
        {
            insert log;
        }
        return responseBean;
    }        
}