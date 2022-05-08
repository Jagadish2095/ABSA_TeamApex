/**
* RESTful API to consume SMS Data from iTouch.
* Used to update information in Salesforce regarding the reply to an SMS
* @author Danie Booysen and Jason Quevauvilliers
* @created 2018-12-03
*/
@RestResource(urlMapping='/iTouch/Reply/v01/*')
global Without Sharing class SMSGateway_ApiRest_v1 {
    
    @HttpPost
    global static String smsInbound(){
        
        String response = '';
        Sys_Log_Integration__c log;
        Integer statusCode;
        SMSGateway_Resp_IB_v1 responseBean = new SMSGateway_Resp_IB_v1();
        
        try{
            //Extract Body and Headers
            String inboundMessage = RestContext.request.requestBody.toString();
            Map<String, String> headers = RestContext.request.headers;
            String transactionId = headers.get(StringConstants.FIELD_TRANSACTION_ID);
            String initiator = headers.get(StringConstants.FIELD_INITIATOR);
            String sender = headers.get(StringConstants.FIELD_SENDER);
            
            if(sender == null || sender == ''){
                sender = StringConstants.ITOUCH_STRING;
            }
            
            //Create Request Log
            log = SystemLogger.createRequestIntegrationLog(inboundMessage, StringConstants.METHOD_SMS_REPLY, sender, StringConstants.SALESFORCE_STRING);
            //Map Audit Header fields to log
            log = SystemLogger.mapAuditFields(log, transactionId, initiator, sender);
            //Call the handler to perform the logic
            
            if(String.isNotBlank(inboundMessage) && inboundMessage != null){
                //Split message body into a list of values e.g.(MessageReference=123456789)
                inboundMessage = inboundMessage.replace('\n', '');
                List<String> dataList = new List<String>();
                dataList = inboundMessage.split('&');
                
                SMSGateway_Resp_IB_v1 bean = SMSGateway_IU_v1.mapResponseFields(dataList);
                
                if(bean.smsType == 'Notification' || bean.smsType == 'notification' || bean.smsType == 'NOTIFICATION'){
                    
                    responseBean = SMSGateway_IH_v1.notification(bean);
                }else if(bean.smsType == 'Replies' || bean.smsType == 'replies' || bean.smsType == 'REPLIES'){
                    
                    responseBean = SMSGateway_IH_v1.reply(bean);
                }else if(bean.smsType == null){
                    
                    responseBean = SMSGateway_IU_v1.mapResponseFields(bean, StringConstants.STATUS_CODE_400, 400, 'Unable To Identify Message Type');
                }else{
                    
                    responseBean = SMSGateway_IU_v1.mapResponseFields(bean, StringConstants.STATUS_CODE_400, 400, 'Unsupported Message Type: ' + bean.smsType);
                }
                //Map responses
                statusCode = responseBean.statusCode;
                if(responseBean.message != null){
                    response = responseBean.message;
                }
                //Map response to log
                if(statusCode == 200){
                    log =  SystemLogger.mapResponseFields(log, 200, StringConstants.INTEGRATION_STATUS_SUCCESS, JSON.serialize(responseBean, true));
                }else{
                    log =  SystemLogger.mapResponseFields(log, statusCode, StringConstants.INTEGRATION_STATUS_FAILED, JSON.serialize(responseBean, true));
                }
            }else{
                statusCode = 400;
                log =  SystemLogger.mapResponseFields(log, 400, StringConstants.INTEGRATION_STATUS_FAILED, StringConstants.ERROR_MSG_REQUEST_BODY_BLANK);
                responseBean = SMSGateway_IU_v1.mapFailedResponseFields(responseBean, StringConstants.STATUS_CODE_400, 400, StringConstants.ERROR_MSG_REQUEST_BODY_BLANK);
            }
        }catch(Exception e){
            //Create Error message with exception
            response = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            statusCode = 500;
            System.debug(response);
            //Create Request Integration Log
            String requestBody = RestContext.request != null ? RestContext.request.requestBody.toString() : '';
            log = SystemLogger.createRequestIntegrationLog(requestBody, StringConstants.METHOD_SMS_REPLY, null, StringConstants.SALESFORCE_STRING);
            //map negative response to log
            log =  SystemLogger.mapResponseFields(log, 500, StringConstants.INTEGRATION_STATUS_FAILED, response);
        }
        //Set the status code
        if(!test.isRunningTest()){
            RestContext.response.statusCode = statusCode;
        }
        if(log != null){
            insert log;
        }
        return response;
    }
}