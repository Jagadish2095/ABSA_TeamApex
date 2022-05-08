public class CreateWillRecord_IH_v1 
{
 	/* Action method which synchronously calls the Create Will Record operation with specified parameters
    ** CreateWillRecord_Req_IB_v1
	*/    
    public static CreateWillRecord_Resp_IB_v1 createRecord(String willNo, String cIFKey, Integer domicileSite, String corpCode, Integer transactionSite, Integer tellerNo, Integer effectiveDate)
    {        
        Sys_Log_Integration__c log;
        CreateWillRecord_Resp_IB_v1 createRecordRespBean;
        Integration_API__c integrationSettings;
           
        try
        {           
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CREATE_WILL_RECORD);

            if(integrationSettings != null)
            {
                CreateWillRecord_Req_IB_v1 createRecordRequest = CreateWillRecord_IU_v1.mapRequestFields(willNo, cIFKey, domicileSite, corpCode, transactionSite, tellerNo, effectiveDate);
                
                String jsonString = JSON.serialize(createRecordRequest, true);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);          
            	 
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CREATE_WILL_RECORD, StringConstants.SALESFORCE_STRING, request.getEndpoint());
          
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                createRecordRespBean = CreateWillRecord_IU_v1.mapResponseFields(response);
                
                System.debug('Create Will Record Request Bean: ' + createRecordRespBean);
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CREATE_WILL_RECORD + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                createRecordRespBean = CreateWillRecord_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_WILL_RECORD, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            createRecordRespBean = CreateWillRecord_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_WILL_RECORD, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        if(log != null)
        {
            insert log;
        }
         
        return createRecordRespBean;
    }
}