public class GetAccountDetailsViaRef_IH_v1 
{
	/* Action method which synchronously calls the Get Account Details Via Ref operation with specified parameters
    ** String channel, String application, String trace, String avsruser, String reference, Integer reqDate, Integer reqTime, Integer reqCount
	*/    
    public static GetAccountDetailsViaRef_Resp_IB_v1 getAccountDetailsViaRef(String channel, String application, String trace, String avsruser, String reference, Integer reqDate, Integer reqTime, Integer reqCount)
    {        
        Sys_Log_Integration__c log;
        GetAccountDetailsViaRef_Resp_IB_v1 responseBean;
        Integration_API__c integrationSettings;
           
        try
        {           
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_ACCOUNT_DETAILS_VIA_REFERENCE);

            if(integrationSettings != null)
            {
                GetAccountDetailsViaRef_Req_IB_v1 requestBean = GetAccountDetailsViaRef_IU_v1.mapRequestFields(channel, application, trace, avsruser, reference, reqDate, reqTime, reqCount);
                
                String jsonString = JSON.serialize(requestBean, true);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);          
            	 
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_GET_ACCOUNT_DETAILS_VIA_REFERENCE, StringConstants.SALESFORCE_STRING, request.getEndpoint());
          
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                responseBean = GetAccountDetailsViaRef_IU_v1.mapResponseFields(response);
                
                System.debug('Get Account Details Via Reference Request Bean: ' + responseBean);
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_ACCOUNT_DETAILS_VIA_REFERENCE + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = GetAccountDetailsViaRef_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_ACCOUNT_DETAILS_VIA_REFERENCE, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = GetAccountDetailsViaRef_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_ACCOUNT_DETAILS_VIA_REFERENCE, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        if(log != null)
        {
            insert log;
        }
         
        return responseBean;
    }
    
}