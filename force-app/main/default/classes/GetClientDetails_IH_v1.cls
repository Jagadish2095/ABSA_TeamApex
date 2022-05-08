public class GetClientDetails_IH_v1 {
    
    public static GetClientDetails_Resp_IB_v1 getClientDetails(String clientCodeP, String accNumberP, String siteCodeP){
        
        GetClientDetails_Resp_IB_v1 getClientDetailsResponse;
        Sys_Log_Integration__c log;
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_CLIENT_DETAILS);
			
            if(integrationSettings != null){
                //Map Request Fields
                GetClientDetails_Req_IB_v1 getClientDetailsRequest = GetClientDetails_IU_v1.mapRequestFields(clientCodeP, accNumberP, siteCodeP);
                
                String jsonString = getClientDetailsRequest.serialize( getClientDetailsRequest );
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCallout(Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString));
                
                ///Map Response Fields
                getClientDetailsResponse = GetClientDetails_IU_v1.mapResponseFields(response);
                
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_CLIENT_DETAILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CLIENT_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                getClientDetailsResponse = GetClientDetails_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            	System.debug(message);
            }
            
        }catch(Exception e){
            //Map bad response and create a log
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CLIENT_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            getClientDetailsResponse = GetClientDetails_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
        }
        if(log != null){
            insert log;
        }
        return getClientDetailsResponse;
    }
}