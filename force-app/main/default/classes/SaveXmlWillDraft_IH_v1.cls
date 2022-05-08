public class SaveXmlWillDraft_IH_v1 
{
    /* Action method which synchronously calls the Save Xml Will Draft operation with specified parameters
    ** SaveXmlWillDraft_Req_IB_v1
	*/    
    public static SaveXmlWillDraft_Resp_IB_v1 saveXmlWillDraft(List<SaveXmlWillDraft_Req_IB_v1> draftFields)
    {        
        Sys_Log_Integration__c log;
        SaveXmlWillDraft_Resp_IB_v1 responseBean;
        Integration_API__c integrationSettings;
           
        try
        {           
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.SAVE_XML_WILL_DRAFT);

            if(integrationSettings != null)
            {
                String jsonString = JSON.serialize(draftFields, true);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);          
            	 
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_SAVE_XML_WILL_DRAFT, StringConstants.SALESFORCE_STRING, request.getEndpoint());
          
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                responseBean = SaveXmlWillDraft_IU_v1.mapResponseFields(response);
                
                System.debug('Save Xml Will Draft Request Bean: ' + responseBean);
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.SAVE_XML_WILL_DRAFT + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = SaveXmlWillDraft_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_SAVE_XML_WILL_DRAFT, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = SaveXmlWillDraft_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_SAVE_XML_WILL_DRAFT, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        if(log != null)
        {
            //insert log;
        }
         
        return responseBean;
    }    
}