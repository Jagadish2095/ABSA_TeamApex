/*
* Integration Handler for Get Joint Participant Compliance
* @author Tshego Lesejane
* @created 2019-01-30
* @updated Danie Booysen
* @updated 2019-02-07
*/
public class RetrieveTrackerStatus_IH_v1 
{

     /* Action method which synchronously calls the Retrieve Tracker Status operation with specified parameters
    ** channel, application, trace, msgLanguage, msgTarget, willNo
	*/    
    public static RetrieveTrackerStatus_Resp_IB_v1 getRetrieveTrackerStatus(String channel, String application, String trace, 
    			String msgLanguage, String msgTarget, String willNo)
    {        
        Sys_Log_Integration__c log;
        RetrieveTrackerStatus_Resp_IB_v1 retrieveTrackerStatusRespBean;
           
        try
        {           
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.LIST_TRACKER_HISTORY);
            
            if(integrationSettings != null)
            {
                RetrieveTrackerStatus_Req_IB_v1 retrieveTrackerStatusRequest = RetrieveTrackerStatus_IU_v1.mapRequestFields(channel, application, trace, 
    			msgLanguage, msgTarget, willNo);
                
                String jsonString = JSON.serialize(retrieveTrackerStatusRequest, true);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);
                              
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_LIST_TRACKER_HISTORY, StringConstants.SALESFORCE_STRING, request.getEndpoint());
          
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCallout(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                retrieveTrackerStatusRespBean = RetrieveTrackerStatus_IU_v1.mapResponseFields(response);
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.LIST_TRACKER_HISTORY + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                retrieveTrackerStatusRespBean = RetrieveTrackerStatus_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_LIST_TRACKER_HISTORY, StringConstants.LISTTRACKERHISTORY_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            retrieveTrackerStatusRespBean = RetrieveTrackerStatus_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_LIST_TRACKER_HISTORY, StringConstants.LISTTRACKERHISTORY_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        if(log != null)
        {
            insert log;
        }
         
        return retrieveTrackerStatusRespBean;
    }
}