/*
* Integration Handler for  IBCancelService service
* @author Lulu Rankwe
* @created 05 May 2020 CancelElectronicBankingController.cancelService('4048276744','4','test','N','N','N','N','N','Y');

*/
public class IBCancelService_IH_v1 {

    public static IBCancelServicev1_Res_IB_v1 cancelService(String accessAccount,String cancellationReason,String cancellationDesc,String replacedByTelBankin, String replacedByAtm, String replacedByMobile,String replacedByVendor,String replacedByDebitOrde, String replacedByPicknpay, String replacedByNothing,String siteCode, String teller,String supervisor){
        Sys_Log_Integration__c log;                                                  
        IBCancelServicev1_Res_IB_v1 responseBean;
        Integration_API__c integrationSettings;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        Map<IBCancelServicev1_Res_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<IBCancelServicev1_Res_IB_v1, List<Sys_Log_Integration__c>>();
       
        try{       
            
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.IBCANCELSERVICE);
            system.debug('Integration result: ' + integrationSettings);
            if(integrationSettings != null){
                
                IBCancelServicev1_Req_IB_v1 requestBean = IBCancelServicev1_IU_v1.mapRequestFields(accessAccount,cancellationReason,cancellationDesc,replacedByTelBankin,replacedByAtm,replacedByMobile,replacedByVendor,replacedByDebitOrde,replacedByPicknpay,replacedByNothing,siteCode,teller,supervisor);
                String jsonString = JSON.serialize(requestBean, true);  
                
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);            
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_IB_CANCEL_SERVICE, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);   
                system.debug('Response : '+response);
                if(response.getStatusCode() == 200){
                    
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());                
                    responseBean = IBCancelServicev1_IU_v1.mapResponseFields(response); 
                    system.debug('IBCancelServicev1 resp: ' + responseBean);
                     log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                   
                }else{
                    
                    
                    System.debug('Status Code NOT 200 - FAILURE'); 
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    responseBean = IBCancelServicev1_IU_v1.mapFailedResponseFields(response.getStatus(),response.getStatusCode(), response.getBody());
                    
                }
            } 
            
        }catch(Exception e)
        {
            
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = IBCancelServicev1_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_IB_CANCEL_SERVICE, StringConstants.IBCANCELSERVICE, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
          
        }
        if(log != null)
        {
            insert log;
            
        }  
        
        responseMap.put(responseBean, logList);
        system.debug(responseMap);
        return responseBean;
        
        
        
    }
    


}