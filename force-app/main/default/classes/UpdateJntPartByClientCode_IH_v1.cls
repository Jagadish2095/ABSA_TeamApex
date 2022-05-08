/**
* Integration Handler for Update Joint Participant By Client Code
* @author Jason Quevauvilliers
* @created 2019-02-18
* @modified 2019-06-06
*/

public class UpdateJntPartByClientCode_IH_v1 {
    
    /* Generic method to Update the Joint Participant By Client Code (Inserts logs)
	* @Param: Boolean insertLogsP - choose to insert logs or not
	* @Return: UpdateJntPartByClientCode_Resp_IB_v1 bean */
    public static UpdateJntPartByClientCode_Resp_IB_v1 updateJointParticipantByClientCode(String clientCodeP, String appliactionP, String branchP, String actionCodeP, List<Account>relatedPartyListP, String userIdP, CvsValidationService_Resp_IB_v1 addressBeanP){
        
        Map<UpdateJntPartByClientCode_Resp_IB_v1, Sys_Log_Integration__c> beanToLogMap = updateJointParticipantByClientCodeMap(clientCodeP, appliactionP, branchP, actionCodeP, relatedPartyListP,userIdP, addressBeanP, true);
        List<UpdateJntPartByClientCode_Resp_IB_v1> beanList = new List<UpdateJntPartByClientCode_Resp_IB_v1>(beanToLogMap.keySet());
        return beanList[0];
    }
    
    public static UpdateJntPartByClientCode_Resp_IB_v1 updateJointParticipantByClientCode(String clientCodeP, String appliactionP, String branchP, String actionCodeP, List<Account>relatedPartyListP, String userIdP, CvsValidationService_Resp_IB_v1 addressBeanP, Boolean insertLogsP){
        
        Map<UpdateJntPartByClientCode_Resp_IB_v1, Sys_Log_Integration__c> beanToLogMap = updateJointParticipantByClientCodeMap(clientCodeP, appliactionP, branchP, actionCodeP, relatedPartyListP, userIdP, addressBeanP, insertLogsP);
        List<UpdateJntPartByClientCode_Resp_IB_v1> beanList = new List<UpdateJntPartByClientCode_Resp_IB_v1>(beanToLogMap.keySet());
        return beanList[0];
        
    }
    /* Updates the Joint Participant By Client Code
	* @Param: Boolean insertLogsP - choose to insert logs or not
	* @Return: UpdateJntPartByClientCode_Resp_IB_v1 bean */
    public static Map<UpdateJntPartByClientCode_Resp_IB_v1, Sys_Log_Integration__c> updateJointParticipantByClientCodeMap(String clientCodeP, String appliactionP, String branchP, String actionCodeP, List<Account>relatedPartyListP, String userIdP, CvsValidationService_Resp_IB_v1 addressBeanP, Boolean insertLogsP){
        
        UpdateJntPartByClientCode_Resp_IB_v1 responseBean;
        Sys_Log_Integration__c log;
        Map<UpdateJntPartByClientCode_Resp_IB_v1, Sys_Log_Integration__c> responseMap = new Map<UpdateJntPartByClientCode_Resp_IB_v1, Sys_Log_Integration__c>();
        try{
            //Query Integration Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.UPD_JNT_PART_BY_CLIENT_CODE);
            List<User> userList = new UsersSelector().selectById(new Set<Id>{userIdP});
            
            if(integrationSettings != null && userList.size() == 1){
                
                //Map Fields
                UpdateJntPartByClientCode_Req_IB_v1 requestBean = UpdateJntPartByClientCode_IU_v1.mapRequestFields(clientCodeP, appliactionP, branchP, actionCodeP, relatedPartyListP, userList[0], addressBeanP);
                
                if(String.isBlank(requestBean.errorMessage)){
                    
                    String jsonString = requestBean.serialize(requestBean);
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    
                    //Send Request
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_UPD_JNT_PART_BY_CLIENT_CODE, StringConstants.SALESFORCE_STRING, StringConstants.CIF_STRING);
                    
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    //Map Response
                    responseBean = UpdateJntPartByClientCode_IU_v1.mapResponseFields(response);
                    
                    if(response.getStatusCode() == 200){
                        //populate log;
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    }else{
                        //populate log;
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    }
                }else{
                    //Error with Translation
                    System.debug('CVS Validate Translation Error: ' + requestBean.errorMessage);
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_UPD_JNT_PART_BY_CLIENT_CODE, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, requestBean.errorMessage);
                    responseBean = UpdateJntPartByClientCode_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, requestBean.errorMessage);
                }
            }else{
                //No Integration Settings or User Found
                String message = '';
                if(integrationSettings == null){
                    message += StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.UPD_JNT_PART_BY_CLIENT_CODE + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                }
                if(userList.size() == 0){
                    message += StringConstants.ERROR_MSG_UNABLE_TO_FIND_USER + userIdP;
                }
                
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_UPD_JNT_PART_BY_CLIENT_CODE, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = UpdateJntPartByClientCode_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
                System.debug(message);
            }
        }catch(Exception e){
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_UPD_JNT_PART_BY_CLIENT_CODE, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = UpdateJntPartByClientCode_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
            System.debug(message);
        }
        responseMap.put(responseBean, log);
        if(log != null && insertLogsP){
            List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
            logList.add(log);
            
            Sys_Log_Integration__c dummylog = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_UPD_JNT_PART_BY_CLIENT_CODE, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, String.valueOf(responseBean));
            logList.add(dummylog);
            insert logList;
        }
        System.debug('UpdateJntPartByClientCode Response Bean: ' + responseBean);
        return responseMap;
    }
}