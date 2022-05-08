/*
* Integration Handler for Get Joint Participant Compliance
* @author Englarmerdge Mongwe
* @created 2018-11-30
*/
public class GetJointParticipant_IH_v1 
{
     /* Action method which synchronously calls the Get Joint Participant operation with specified parameters
    ** clientCodeP
	*/    
    public static GetJointParticipant_Resp_IB_v1 getJointParticipant(String clientCodeP){
        return getJointParticipant(clientCodeP, true);
    }
    
    public static GetJointParticipant_Resp_IB_v1 getJointParticipant(String clientCodeP, Boolean insertLogsP){
        //Call getAnalystCommentsMap
        Map<GetJointParticipant_Resp_IB_v1, Sys_Log_Integration__c> responseMap = getJointParticipantMap(clientCodeP);
        
        //Check for logs and insert if specified 
        if(responseMap.values().size() > 0){
            
            if(responseMap.values()[0] != null && insertLogsP){
                //Insert Logs
                insert responseMap.values()[0];
            }
        }
        //Get Response Bean from Map
        List<GetJointParticipant_Resp_IB_v1> responseList = new List<GetJointParticipant_Resp_IB_v1>(responseMap.keySet());
        
        return responseList[0];
    }
    
    public static Map<GetJointParticipant_Resp_IB_v1, Sys_Log_Integration__c> getJointParticipantMap(String clientCodeP)
    {        
        Sys_Log_Integration__c log;
        GetJointParticipant_Resp_IB_v1 jointParticipantRespBean;
        Integration_API__c integrationSettings;
        Map<GetJointParticipant_Resp_IB_v1, Sys_Log_Integration__c> responseMap = new Map<GetJointParticipant_Resp_IB_v1, Sys_Log_Integration__c>();
           
        try
        {           
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_JOINT_PARTICIPANT);
			
            if(integrationSettings != null)
            {
                GetJointParticipant_Req_IB_v1 jointParticipantRequest = GetJointParticipant_IU_v1.mapRequestFields(clientCodeP);
                
                String jsonString = JSON.serialize(jointParticipantRequest, true);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r, jsonString);          
            	              
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_JOINT_PARTICIPANT_GET, StringConstants.SALESFORCE_STRING, request.getEndpoint());
          
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                jointParticipantRespBean = GetJointParticipant_IU_v1.mapResponseFields(response);
                
                System.debug('Get Joint Participant Request Bean: ' + jointParticipantRespBean);
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_JOINT_PARTICIPANT + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                jointParticipantRespBean = GetJointParticipant_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_JOINT_PARTICIPANT_GET, StringConstants.JOINTPARTICIPANT_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(e.getMessage());
            jointParticipantRespBean = GetJointParticipant_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_JOINT_PARTICIPANT_GET, StringConstants.JOINTPARTICIPANT_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        responseMap.put(jointParticipantRespBean, log);
         
        return responseMap;
    }
}