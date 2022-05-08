public class GetClientDetailsCIF_IH_v1 {
    
    //Get Client Details from CIF and insert logs
    public static GetClientDetailsCIF_Resp_IB_v1 getClientDetails(String clientCodeP, String accNumberP, String siteCodeP){
        return getClientDetails(clientCodeP, accNumberP, siteCodeP, false);
    }
    
    //Get Client Details from CIF and providing a logs on/off switch
    public static GetClientDetailsCIF_Resp_IB_v1 getClientDetails(String clientCodeP, String accNumberP, String siteCodeP, Boolean insertLogsP){
        
        Map<GetClientDetailsCIF_Resp_IB_v1, Sys_Log_Integration__c> getClientDetailsCIFMap = getClientDetailsMap(clientCodeP, accNumberP, siteCodeP);
        
        if(getClientDetailsCIFMap.values().size() > 0 && insertLogsP){
            //for logs, its gonna be updated
            //insert getClientDetailsCIFMap.values()[0];
        }
        List<GetClientDetailsCIF_Resp_IB_v1> beanList = new List<GetClientDetailsCIF_Resp_IB_v1>(getClientDetailsCIFMap.keySet());
        
        return beanList[0];
    }
    
    //Get Client Details from CIF and return a map of the bean and the log
    public static map<GetClientDetailsCIF_Resp_IB_v1,Sys_Log_Integration__c>  getClientDetailsMap(String clientCodeP, String accNumberP, String siteCodeP){
        
        map<GetClientDetailsCIF_Resp_IB_v1,Sys_Log_Integration__c> responseMap = new map<GetClientDetailsCIF_Resp_IB_v1,Sys_Log_Integration__c>();
        GetClientDetailsCIF_Resp_IB_v1 getClientDetailsResponse;
        Sys_Log_Integration__c log;
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_CLIENT_DETAILS);
            
            if(integrationSettings != null){
                //Map Request Fields
                GetClientDetailsCIF_Req_IB_v1 getClientDetailsRequest = GetClientDetailsCIF_IU_v1.mapRequestFields(clientCodeP, accNumberP, siteCodeP);
                String jsonString = getClientDetailsRequest.serialize(getClientDetailsRequest);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                
                //Send Request
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_GET_CLIENT_DETAILS, StringConstants.SALESFORCE_STRING, StringConstants.CIF_STRING);
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                ///Map Response Fields
                getClientDetailsResponse = GetClientDetailsCIF_IU_v1.mapResponseFields(response);
                
                if(response.getStatusCode() == 200){
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                }else{
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                }
                
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_CLIENT_DETAILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CLIENT_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                getClientDetailsResponse = GetClientDetailsCIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                System.debug(message);
            }
            
        }catch(Exception e){
            //Map bad response and create a log
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CLIENT_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            getClientDetailsResponse = GetClientDetailsCIF_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
        }
        responseMap.put(getClientDetailsResponse, log);
        return responseMap;
    }
}