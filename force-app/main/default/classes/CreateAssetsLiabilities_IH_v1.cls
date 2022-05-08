public class CreateAssetsLiabilities_IH_v1 
{
	/* Action method which synchronously calls the Create Assets Liabilities operation with specified parameters
    ** CreateAssetsLiabilities_Req_IB_v1
	*/    
    public static CreateAssetsLiabilities_Resp_IB_v1 createAssetsLiability(CreateAssetsLiabilities_Req_IB_v1 assetsFields)
    {        
        Sys_Log_Integration__c log;
        CreateAssetsLiabilities_Resp_IB_v1 createRecordRespBean;
        Integration_API__c integrationSettings;
           
        try
        {           
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CREATE_ASSETS_LIABILITIES);

            if(integrationSettings != null)
            {
                CreateAssetsLiabilities_Req_IB_v1 createRecordRequest = CreateAssetsLiabilities_IU_v1.mapRequestFields(assetsFields);
                
                String jsonString = JSON.serialize(createRecordRequest, true);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);          
            	 
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CREATE_ASSETS_LIABILITIES, StringConstants.SALESFORCE_STRING, request.getEndpoint());
          
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                createRecordRespBean = CreateAssetsLiabilities_IU_v1.mapResponseFields(response);
                
                System.debug('Create Assets Liabilities Request Bean: ' + createRecordRespBean);
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CREATE_ASSETS_LIABILITIES + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                createRecordRespBean = CreateAssetsLiabilities_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_ASSETS_LIABILITIES, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            createRecordRespBean = CreateAssetsLiabilities_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_ASSETS_LIABILITIES, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        if(log != null)
        {
            insert log;
        }
         
        return createRecordRespBean;
    }
    
}