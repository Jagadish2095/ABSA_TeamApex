/**
* Descripton: Apex/Integration Handler class for WQacknowledgeDocumentsV1 Complaint service
* Test Class Name: WQacknowledgeDocumentsV1_IH_v1_Test
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class WQacknowledgeDocumentsV1_IH_v1 {
     public static Map<WQacknowledgeDocumentsV1_Resp_IB_v1, Sys_Log_Integration__c> acknowledgeDocuments(Account acc,List<String> docCodes,String docNo,String VersionNo,Boolean insertLogsP){
        WQacknowledgeDocumentsV1_Resp_IB_v1 WQacknowledgeDocumentsV1RespBean;
        Sys_Log_Integration__c log;
        Map<WQacknowledgeDocumentsV1_Resp_IB_v1, Sys_Log_Integration__c> beanToLogMap = new Map<WQacknowledgeDocumentsV1_Resp_IB_v1, Sys_Log_Integration__c>();
        try{
                
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.WQacknowledgedocumentsv1_STRING);
                System.debug('INTEGRATION SETTINGS'+integrationSettings);   //To be removed
               
            //Check if integration settings were found
            if(integrationSettings != null){ 
                
                WQacknowledgeDocumentsV1_Req_IB_v1 requestBean = WQacknowledgeDocumentsV1_IU_v1.mapRequestFields(acc,docCodes,docNo,VersionNo);
                String jsonString = (JSON.serialize(requestBean));
                
                System.debug('requestBean+++'+requestBean);//To be removed
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                System.debug('REQUEST'+request.getBody());    //To be removed
                
                log = SystemLogger.createRequestIntegrationLog(jsonString, StringConstants.METHOD_WQacknowledgeDocumentsV1, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                System.debug('log'+jsonString + '' +request.getEndpoint());
                
                //Make API Callout
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                System.debug('RESPONSE BODY: ' + response.getBody());//To be removed
                
                if(response.getStatusCode() == 200){
                    //Success Response
                    System.debug('Status Code 200 - SUCCESS');//To be removed
                    
                    WQacknowledgeDocumentsV1RespBean =  WQacknowledgeDocumentsV1_IU_v1.mapResponseFields(response,acc);
                    System.debug('WQacknowledgeDocumentsV1RespBean+++'+ WQacknowledgeDocumentsV1RespBean);//To be removed
                    //Map Response Log
                    log = SystemLogger.mapResponseFields(log,  WQacknowledgeDocumentsV1RespBean.StatusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    beanToLogMap.put(WQacknowledgeDocumentsV1RespBean, log);
                    
                } else{
                    System.debug('Status Code NOT 200 - FAILURE');   //To be removed 
                    //Response was not 0
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    WQacknowledgeDocumentsV1RespBean =  WQacknowledgeDocumentsV1_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
                    
                }
                
            } else{
                //No integrationSettings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.WQacknowledgeDocumentsV1_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                WQacknowledgeDocumentsV1RespBean =  WQacknowledgeDocumentsV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_WQacknowledgeDocumentsV1, StringConstants.WQacknowledgeDocumentsV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
                
            }
             
            
        } catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            system.debug('**message****'+message+'*******line number***'+e.getLineNumber());
             WQacknowledgeDocumentsV1RespBean =  WQacknowledgeDocumentsV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_WQacknowledgeDocumentsV1, StringConstants.WQacknowledgeDocumentsV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            beanToLogMap.put(WQacknowledgeDocumentsV1RespBean, log);
        }
        //Insert Logs
        if(insertLogsP && log != null){
            insert log;
        }
        return beanToLogMap;
    }   
}