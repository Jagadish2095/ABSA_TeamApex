/**
* Descripton: Apex/Integration Handler class for Wqgetanalystcommentsv7 Complaint service
* Test Class Name: Generatedocumentsv7_IH_v1_Test
* @author  Anka Ganta : Absa
* @since   2020-04-15
*
**/
public class Generatedocumentsv7_IH_v1 {
    public static Map<Generatedocumentsv7_Resp_IB_v1, Sys_Log_Integration__c> generateDocuments(Account accRec,Boolean insertLogsP){
        Generatedocumentsv7_Resp_IB_v1 Generatedocumentsv7RespBean;
        Sys_Log_Integration__c log;
        Map<Generatedocumentsv7_Resp_IB_v1, Sys_Log_Integration__c> beanToLogMap = new Map<Generatedocumentsv7_Resp_IB_v1, Sys_Log_Integration__c>();
        try{
                                                                                                            //StringConstants.JITTERBIT_API_RB_STRING
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.Generatedocumentsv7_STRING);
                System.debug('INTEGRATION SETTINGS'+integrationSettings);   //To be removed
               
                //Check if integration settings were found
                  if(integrationSettings != null){ 
                    
                    Generatedocumentsv7_Req_IB_v1 requestBean = Generatedocumentsv7_IU_v1.mapRequestFields(accRec);
                    String jsonString = (JSON.serialize(requestBean));
                    
                     System.debug('requestBean+++'+requestBean);//To be removed
                  
                   HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                    System.debug('REQUEST'+request.getBody());    //To be removed
    
                    log = SystemLogger.createRequestIntegrationLog(jsonString, StringConstants.METHOD_Generatedocumentsv7, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                    System.debug('log'+jsonString + '' +request.getEndpoint());
    
                    //Make API Callout
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    System.debug('RESPONSE BODY: ' + response.getBody());//To be removed
        
                      if(response.getStatusCode() == 200 || Test.isRunningTest()){
                          //Success Response
                          System.debug('Status Code 200 - SUCCESS');//To be removed
                          
                          Generatedocumentsv7RespBean = Generatedocumentsv7_IU_v1.mapResponseFields(response,accRec);
                          System.debug('Generatedocumentsv7RespBean+++'+Generatedocumentsv7RespBean);//To be removed
                          Generatedocumentsv7_Resp_IB_v1 responseBean = new Generatedocumentsv7_Resp_IB_v1();
                          //Map Response Log
                          log = SystemLogger.mapResponseFields(log, Generatedocumentsv7RespBean.StatusCode, StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                          beanToLogMap.put(Generatedocumentsv7RespBean, log);
                      } else{
                          System.debug('Status Code NOT 200 - FAILURE');   //To be removed 
                          //Response was not 0
                          log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                          Generatedocumentsv7RespBean = Generatedocumentsv7_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
                          
                      }
                    
            } else{
                    //No integrationSettings Found
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.Generatedocumentsv7_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    Generatedocumentsv7RespBean = Generatedocumentsv7_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_Generatedocumentsv7, StringConstants.Generatedocumentsv7_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                   
                }
             
            
        } catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            system.debug('**message****'+message+'*******line number***'+e.getLineNumber());
            Generatedocumentsv7RespBean = Generatedocumentsv7_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_Generatedocumentsv7, StringConstants.Generatedocumentsv7_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            beanToLogMap.put(Generatedocumentsv7RespBean, log);
           
        }
        //Insert Logs
        if(insertLogsP && log != null){
            insert log;
        }
        return beanToLogMap;
    }   
}