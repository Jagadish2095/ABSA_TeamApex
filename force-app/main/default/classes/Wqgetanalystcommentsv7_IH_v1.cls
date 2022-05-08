/**
* Descripton: Apex/Integration Handler class for Wqgetanalystcommentsv7 Complaint service
* Test Class Name: Wqgetanalystcommentsv7_IH_v1_Test
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class Wqgetanalystcommentsv7_IH_v1 {
   //@future(callout = true)
    public static Map<Wqgetanalystcommentsv7_Resp_IB_v1, Sys_Log_Integration__c> getCasaAnalystComments(Account accRec,Boolean insertLogsP){
        Wqgetanalystcommentsv7_Resp_IB_v1 Wqgetanalystcommentsv7RespBean;
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Map<Wqgetanalystcommentsv7_Resp_IB_v1, Sys_Log_Integration__c> beanToLogMap = new Map<Wqgetanalystcommentsv7_Resp_IB_v1, Sys_Log_Integration__c>();
        try{
            
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.Wqgetanalystcommentsv7_STRING);
            System.debug('INTEGRATION SETTINGS'+integrationSettings);   //To be removed
            
            //Check if integration settings were found
            if(integrationSettings != null){ 
                
                Wqgetanalystcommentsv7_Req_IB_v1 requestBean = Wqgetanalystcommentsv7_IU_v1.mapRequestFields(accRec);
                String jsonString = (JSON.serialize(requestBean));
                
                System.debug('requestBean+++'+requestBean);//To be removed
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                System.debug('REQUEST'+request.getBody());    //To be removed
                
                log = SystemLogger.createRequestIntegrationLog(jsonString, StringConstants.METHOD_Wqgetanalystcommentsv7, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                System.debug('log'+jsonString + '' +request.getEndpoint());
                
                //Make API Callout
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                System.debug('RESPONSE BODY: ' + response.getBody());//To be removed
                
                if(response.getStatusCode() == 200){
                    //Success Response
                    System.debug('Status Code 200 - SUCCESS');//To be removed
                    
                    Wqgetanalystcommentsv7RespBean = Wqgetanalystcommentsv7_IU_v1.mapResponseFields(response,accRec);
                    System.debug('Wqgetanalystcommentsv7RespBean+++'+Wqgetanalystcommentsv7RespBean);//To be removed
                    //Map Response Log
                    log = SystemLogger.mapResponseFields(log, Wqgetanalystcommentsv7RespBean.StatusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    beanToLogMap.put(Wqgetanalystcommentsv7RespBean, log);                       
                } else{
                    System.debug('Status Code NOT 200 - FAILURE');   //To be removed 
                    //Response was not 0
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    Wqgetanalystcommentsv7RespBean = Wqgetanalystcommentsv7_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
                    
                }
                
            } else{
                //No integrationSettings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.Wqgetanalystcommentsv7_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                Wqgetanalystcommentsv7RespBean = Wqgetanalystcommentsv7_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_Wqgetanalystcommentsv7, StringConstants.Wqgetanalystcommentsv7_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
                
            }
            
            
        } catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            system.debug('**message****'+message+'*******line number***'+e.getLineNumber());
            Wqgetanalystcommentsv7RespBean = Wqgetanalystcommentsv7_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_Wqgetanalystcommentsv7, StringConstants.Wqgetanalystcommentsv7_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            beanToLogMap.put(Wqgetanalystcommentsv7RespBean, log);
        }
        //Insert Logs
        if(insertLogsP && log != null){
            insert log;
        }
        return beanToLogMap;
    }   
    
}