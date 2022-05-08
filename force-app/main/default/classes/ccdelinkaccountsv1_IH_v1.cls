/**
* Descripton: Apex/Integration Handler class for ccdelinkaccountsv1 Complaint service
* Test Class Name: ccdelinkaccountsv1_IH_v1_Test
* @author  srikanth n : Absa
* @since   2020-04-15
*
**/
public class ccdelinkaccountsv1_IH_v1 {
    //@future(callout = true)
    public static ccdelinkaccountsv1_Resp_IB_v1 getccdelinkaccountsv1(String cbNumber, List<String> accountNumberList, boolean insertLogsP){
        ccdelinkaccountsv1_Resp_IB_v1 ccdelinkaccountsv1RespBean;
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        try{
             
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT2, Sys_Utilities_General.getEnvironment(), StringConstants.ccdelinkaccountsv1_STRING);
            System.debug('INTEGRATION SETTINGS'+integrationSettings);   //To be removed
            
            //Check if integration settings were found
            if(integrationSettings != null){                     
                ccdelinkaccountsv1_Req_IB_v1 requestBean = ccdelinkaccountsv1_IU_v1.mapRequestFields(cbNumber, accountNumberList);
                String jsonString = (JSON.serialize(requestBean));
                
                System.debug('requestBean+++'+requestBean);//To be removed
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                System.debug('REQUEST'+request.getBody());    //To be removed
                
                log = SystemLogger.createRequestIntegrationLog(jsonString, StringConstants.METHOD_ccdelinkaccountsv1, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                System.debug('log'+jsonString + '' +request.getEndpoint());
                
                //Make API Callout
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                System.debug('RESPONSE BODY: ' + response.getBody());//To be removed
                
                if(response.getStatusCode() == 200){
                    //Success Response
                    System.debug('Status Code 200 - SUCCESS');//To be removed
                    
                    ccdelinkaccountsv1RespBean = ccdelinkaccountsv1_IU_v1.mapResponseFields(response);
                    System.debug('ccdelinkaccountsv1RespBean+++'+ccdelinkaccountsv1RespBean);//To be removed
                    //Map Response Log
                    log = SystemLogger.mapResponseFields(log, ccdelinkaccountsv1RespBean.StatusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    
                } else{ 
                    System.debug('Status Code NOT 200 - FAILURE');   //To be removed 
                    //Response was not 0
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    ccdelinkaccountsv1RespBean = ccdelinkaccountsv1_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
                    
                }
                
                //update accRec;
                
            } else{
                //No integrationSettings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.ccdelinkaccountsv1_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                ccdelinkaccountsv1RespBean = ccdelinkaccountsv1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_ccdelinkaccountsv1, StringConstants.ccdelinkaccountsv1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
                
            }
            
        } catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            system.debug('**message****'+message+'*******line number***'+e.getLineNumber());
            ccdelinkaccountsv1RespBean = ccdelinkaccountsv1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_ccdelinkaccountsv1, StringConstants.ccdelinkaccountsv1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        //Insert Logs
        if(insertLogsP && log != null){
            insert log;
        }
        return ccdelinkaccountsv1RespBean;
    }   
    
}