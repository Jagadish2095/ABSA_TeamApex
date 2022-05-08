public class SMSGateway_IH_v1 {
    
    public static SMSGateway_Resp_IB_v1 submit(String phoneNumberP, String messageTextP, String recipientP, String whatIdP, String ownerIdP){
        
        return submit(phoneNumberP, messageTextP, 'iTouch SMS Submit - WILLS', true);
    }
    public static SMSGateway_Resp_IB_v1 submit(String phoneNumberP, String messageTextP, String integrationServiceP){
        return submit(phoneNumberP, messageTextP, integrationServiceP, true);
    }
    
    /* SUBMIT service to send an SMS
* @Param: Phone Number - String
* @Param Message - String
* @Return resonse bean - SMSGateway_Resp_IB_v1 */
    public static SMSGateway_Resp_IB_v1 submit(String phoneNumberP, String messageTextP, String integrationServiceP, Boolean insertLogsP){
        
        SMSGateway_Resp_IB_v1 responseBean = new SMSGateway_Resp_IB_v1();
        Sys_Log_Integration__c log;
        try{
            //Query Objects
            //Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.ITOUCH_SUBMIT);
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), integrationServiceP);
                
                
            if(integrationSettings != null){
                //Concatenate message body
                String body = 'PhoneNumber=' + phoneNumberP + '&MessageText=' + messageTextP + '&UserId=' + integrationSettings.Integration_Services__r[0].Username__c + '&Password=' + integrationSettings.Integration_Services__r[0].Password__c;
                //Create Request Log
                log = SystemLogger.createRequestIntegrationLog(body, StringConstants.METHOD_SMS_SUBMIT, StringConstants.SALESFORCE_STRING, StringConstants.ITOUCH_STRING);
                //Creates Http Request
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], body);
                //perform callout
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                //Map response bean
                responseBean = SMSGateway_IU_v1.mapSubmitResponseFields(response);
                
                if(responseBean.statusCode == 200){
                    //Map response log
                    log = SystemLogger.mapResponseFields(log, responseBean.statusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, responseBean.message);
                }else{
                    //Map response log
                    log = SystemLogger.mapResponseFields(log, responseBean.statusCode, StringConstants.INTEGRATION_STATUS_FAILED, responseBean.message);
                }
            }else{
                //No Integration Settings found - Create negative log and response bean with error message
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  integrationServiceP + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_SMS_SUBMIT, StringConstants.ITOUCH_STRING, 500, StringConstants.STATUS_CODE_500, message);
                responseBean = SMSGateway_IU_v1.mapFailedResponseFields(responseBean, StringConstants.STATUS_CODE_500, 500, message);
            }
        }catch(Exception e){
            //Create negative log and response bean with error message
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_SMS_SUBMIT, StringConstants.ITOUCH_STRING, 500, StringConstants.STATUS_CODE_500, description);
            responseBean = SMSGateway_IU_v1.mapFailedResponseFields(responseBean, StringConstants.STATUS_CODE_500, 500, description);
            
        }
        System.debug(responseBean);
        if(log != null && insertLogsP == true){
            insert log;
        }
        return responseBean;
    }
    
    /* NOTIFICATION service for updating the status of the SMS
* @Param Message - String
* @Return resonse bean - SMSGateway_Resp_IB_v1 */
    public static SMSGateway_Resp_IB_v1 notification(SMSGateway_Resp_IB_v1 responseBeanP){
        
        try{
            //Validate that all the required parameters were sent
            String errorMessage = responseBeanP.validate();
            
            if(String.isNotBlank(errorMessage)){
                //return bad response
                return SMSGateway_IU_v1.mapFailedResponseFields(responseBeanP, StringConstants.STATUS_CODE_400, 400, errorMessage);
            }
            
            if(responseBeanP.StatusDescription != null){
                
                //Query Task
                List<Task> taskList = [SELECT Id, Delivery_Status__c
                                       FROM Task 
                                       WHERE Message_Reference__c =: responseBeanP.MessageReference 
                                       AND Related_Task_ID__c = null ORDER BY CreatedDate DESC];
                
                if(taskList.size() > 0){
                    //Populate Task Fields
                    taskList[0].Delivery_Status__c = SMSGateway_IU_v1.getDeliveryStatus(responseBeanP.statusNumber);
                    update taskList;
                    //Map positive response bean
                    responseBeanP = SMSGateway_IU_v1.mapResponseFields(responseBeanP, StringConstants.STATUS_CODE_200, 200, 'Notification ' + StringConstants.INTEGRATION_STATUS_SUCCESS);
                }else{
                    //Map negative response bean - Unable to find task by reference id
                    responseBeanP = SMSGateway_IU_v1.mapFailedResponseFields(responseBeanP, StringConstants.STATUS_CODE_500, 500, StringConstants.ERROR_MSG_CANT_FIND_TASK_REF_ID + responseBeanP.MessageReference);
                }
            }else{
                responseBeanP = SMSGateway_IU_v1.mapFailedResponseFields(responseBeanP, StringConstants.STATUS_CODE_400, 400, StringConstants.ERROR_MSG_REQUIRED_FIELD_MISSING + 'StatusDescription');
            }
        }catch(Exception e){
            //Map failed response bean
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanP = SMSGateway_IU_v1.mapFailedResponseFields(responseBeanP, StringConstants.STATUS_CODE_500, 500, description);
        }
        return responseBeanP;
    }
    
    /* REPLY service for updating the reply of the SMS
* @Param Message - String
* @Return resonse bean - SMSGateway_Resp_IB_v1 */
    public static SMSGateway_Resp_IB_v1 reply(SMSGateway_Resp_IB_v1 responseBeanP){
        
        try{
            //Validate that all the required parameters were sent
            String errorMessage = responseBeanP.validate();
            
            if(String.isNotBlank(errorMessage)){
                //return bad response
                return SMSGateway_IU_v1.mapFailedResponseFields(responseBeanP, StringConstants.STATUS_CODE_400, 400, errorMessage);
            }
            
            if(responseBeanP.MessageText != null){
                //Query Task
                List<Task> taskList = [SELECT Id, Subject, Message_Reference__c, WhatId, OwnerId
                                       FROM Task 
                                       WHERE Message_Reference__c =: responseBeanP.MessageReference ORDER BY CreatedDate DESC];
                
                if(taskList.size() > 0){
                    Task tsk = new Task();
                    tsk.Related_Task_Id__c = taskList[0].Id;
                    tsk.Related_Task_Subject__c = taskList[0].Subject;
                    tsk.Message_Reference__c = taskList[0].Message_Reference__c;
                    //tsk.WhatId = taskList[0].WhatId;
                    tsk.OwnerId = taskList[0].OwnerId;
                    tsk.Description = responseBeanP.MessageText;
                    tsk.Delivery_Status__c = 'Delivered';
                    tsk.status = 'Completed';
                    tsk.Subject = taskList[0].Subject + ' Reply';
                    tsk.RecordTypeId = Sys_Utilities_General.getRecordTypeId(StringConstants.TASK_RECORD_TYPE_SMS);
                    insert tsk;
                    //Map positive response bean
                    responseBeanP = SMSGateway_IU_v1.mapResponseFields(responseBeanP, StringConstants.STATUS_CODE_200, 200, 'Reply ' + StringConstants.INTEGRATION_STATUS_SUCCESS);
                }else{
                    //Map negative response bean - Unable to find task by reference id
                    responseBeanP = SMSGateway_IU_v1.mapFailedResponseFields(responseBeanP, StringConstants.STATUS_CODE_500, 500, StringConstants.ERROR_MSG_CANT_FIND_TASK_REF_ID + responseBeanP.MessageReference);
                }
            }else{
                responseBeanP = SMSGateway_IU_v1.mapFailedResponseFields(responseBeanP, StringConstants.STATUS_CODE_400, 400, StringConstants.ERROR_MSG_REQUIRED_FIELD_MISSING + 'MessageText');
            }
        }catch(Exception e){
            //Map failed response bean
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBeanP = SMSGateway_IU_v1.mapFailedResponseFields(responseBeanP, StringConstants.STATUS_CODE_500, 500, description);
        }
        return responseBeanP;
    }
}