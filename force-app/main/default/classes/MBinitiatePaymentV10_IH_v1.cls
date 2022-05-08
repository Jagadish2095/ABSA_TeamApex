/**
* Descripton: Apex/Integration Handler class for MBinitiatePaymentV10 service
* Test Class Name: MBinitiatePaymentV10_IH_v1_Test
* @author  Srikanth : Absa 
* @since   2020-31-01
*
**/
public class MBinitiatePaymentV10_IH_v1{

    /* Makes the callout to MBinitiatePaymentV10 
    * @param: List of Accounts
    * @return: MBinitiatePaymentV10_Resp_IB_v1 bean object
   */
     
    public static Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> callToMBinitiatePaymentV10(MBinitiatePaymentV10_Req_IB_v1 requestBean) { //String accNum, String fromDate, String toDate,string CIFkey,string selectedprotype) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        MBinitiatePaymentV10_Resp_IB_v1 MBinitiatePaymentV10RespBean = new MBinitiatePaymentV10_Resp_IB_v1();
        Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>>();
   
     
       
        try{
           
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.MBinitiatePaymentV10_STRING);
              
                if(integrationSettings!=null || Test.isRunningTest()){
                    System.debug('requestBean in IH'+requestBean) ;
                   String jsonString = JSON.serialize(requestBean, true);
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MBinitiatePaymentV10_GET_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                   	HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                  	system.debug('+++'+response.getBody());
                    if(response.getStatusCode() == 200){
                        system.debug(JSON.deserialize(response.getBody(), MBinitiatePaymentV10_Resp_IB_v1.class));
                       	MBinitiatePaymentV10RespBean = (MBinitiatePaymentV10_Resp_IB_v1) JSON.deserialize(response.getBody(), MBinitiatePaymentV10_Resp_IB_v1.class); 
                        MBinitiatePaymentV10RespBean.statusCode = response.getStatusCode();
                        MBinitiatePaymentV10RespBean.StatusMessage = response.getStatus() ;
                      
                    } else{
                        System.debug('Status Code NOT 200 - FAILURE');    
                        //Response was not 0
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                        MBinitiatePaymentV10RespBean = MBinitiatePaymentV10_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
                    
                        
                    }
                    
                } 	else{
                    //No Integration Settings Found
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.ESP_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    MBinitiatePaymentV10RespBean = MBinitiatePaymentV10_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MLgetAcctBalanceIF42V1_GET_STATUS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    System.debug(message);
                    
                }
                
                if (log != null) {
                    logList.add(log);
                  }
                  responseMap.put(MBinitiatePaymentV10RespBean, logList);
                system.debug(responseMap);
                 return responseMap;
            
        } catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            MBinitiatePaymentV10RespBean = MBinitiatePaymentV10_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MBinitiatePaymentV10_GET_STATUS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        
        if(log != null){
            insert log;
        }
         responseMap.put(MBinitiatePaymentV10RespBean, logList);
          system.debug(responseMap);
         return responseMap;
    }
    
    public static Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> callMBinitiatePayment(String payTime,String actDate, String amount,String srcAcc,String srcAccType, String srcStmtRef,String trgAcc,String trgClrCode,String trgAccType,String trgStmtRef,String paymIipInd,String instrRefName,String tieb){
        Sys_Log_Integration__c log;                                                  
        MBinitiatePaymentV10_Resp_IB_v1 responseBean;
        Integration_API__c integrationSettings;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        
        try{       
            
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.MBinitiatePaymentV10_STRING);
            system.debug('Integration result: ' + integrationSettings);
            if(integrationSettings != null){
                
                MBinitiatePaymentV10_Req_IB_v1 requestBean = MBinitiatePaymentV10_IU_v1.mbInitiateRequestdFields(payTime,actDate,amount,srcAcc,srcAccType,srcStmtRef,trgAcc,trgClrCode,trgAccType,trgStmtRef,paymIipInd,instrRefName,tieb);
                String jsonString = JSON.serialize(requestBean, true);  

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);            
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MBinitiatePaymentV10_GET_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);   
                system.debug('Response : '+response);
                if(response.getStatusCode() == 200){
                    
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());                
                    responseBean = MBinitiatePaymentV10_IU_v1.mapResponseFields(response); 
                    system.debug('MBinitiatePaymentV10 resp: ' + responseBean);
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    
                }else{
                    
                    
                    System.debug('Status Code NOT 200 - FAILURE'); 
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    responseBean = MBinitiatePaymentV10_IU_v1.mapFailedResponseFields (response.getStatusCode(), response.getStatus(), response.getBody());
                }
            } 
            
        }catch(Exception e)
        {
            
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBinitiatePaymentV10_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MBinitiatePaymentV10_GET_STATUS, StringConstants.MBinitiatePaymentV10_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            
        }
        if(log != null)
        {
            insert log;
            
        }  
        
        responseMap.put(responseBean, logList);
        return responseMap;
        
    }
    
    
     public static Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> payBeneficiary(String paymTime,String accessAcc,String cifKey,String instrRefName,String actDate,String amount,String instrNo,String srcAcc,String srcAccType,String srcStmtRef,String trgAcc,String trgClrCode,String trgAccType,String trgStmtRef,String paymIipInd,String tieb){ 
        
        Sys_Log_Integration__c log;                                                  
        MBinitiatePaymentV10_Resp_IB_v1 responseBean;
        Integration_API__c integrationSettings;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBinitiatePaymentV10_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        
        try{       
            
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.MBinitiatePaymentV10_STRING);
            system.debug('Integration result: ' + integrationSettings);
            if(integrationSettings != null){
                
                MBinitiatePaymentV10_Req_IB_v1 requestBean = MBinitiatePaymentV10_IU_v1.mapRequestdFieldsPayBeneficiary(paymTime,accessAcc,cifKey,instrRefName,actDate,amount,instrNo,srcAcc,srcAccType,srcStmtRef,trgAcc,trgClrCode,trgAccType,trgStmtRef,paymIipInd,tieb);
                    
                String jsonString = JSON.serialize(requestBean, true);  
                
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);            
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MBinitiatePaymentV10_GET_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);   
                system.debug('Response : '+response);
                if(response.getStatusCode() == 200){
                    
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());                
                    responseBean = MBinitiatePaymentV10_IU_v1.mapResponseFields(response); 
                    system.debug('MBinitiatePaymentV10 resp: ' + responseBean);
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    
                }else{
                    
                    
                    System.debug('Status Code NOT 200 - FAILURE'); 
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    responseBean = MBinitiatePaymentV10_IU_v1.mapFailedResponseFields (response.getStatusCode(), response.getStatus(), response.getBody());
                                         
                     // MBinitiatePaymentV10RespBean = MBinitiatePaymentV10_IU_v1.mapFailedResponseFields
                     // (response.getStatusCode(), response.getStatus(), response.getBody());
                    
                }
            } 
            
        }catch(Exception e)
        {
            
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBinitiatePaymentV10_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MBinitiatePaymentV10_GET_STATUS, StringConstants.MBinitiatePaymentV10_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            
        }
        if(log != null)
        {
            insert log;
            
        }  
        
        responseMap.put(responseBean, logList);
        return responseMap;
        
    }




}