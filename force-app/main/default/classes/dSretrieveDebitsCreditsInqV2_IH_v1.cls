/**
* Descripton: Apex/Integration Handler class for dSretrieveDebitsCreditsInqV2 service
* Test Class Name: dSretrieveDebitsCreditsInqV2_IH_v1_Test
* @author  Srikanth : Absa
* @since   2020-31-01
*
**/
public class dSretrieveDebitsCreditsInqV2_IH_v1{

    /* Makes the callout to dSretrieveDebitsCreditsInqV
    * @param: List of Accounts
    * @return: dSretrieveDebitsCreditsInqV2_Resp_IB_v1 bean object
   */
     
    //public static Map<dSretrieveDebitsCreditsInqV2_Resp_IB_v1, List<Sys_Log_Integration__c>> callTodSretrieveDebitsCreditsInqV2(dSretrieveDebitsCreditsInqV2_Req_IB_v1 requestBean) { 
    public static Map<dSretrieveDebitsCreditsInqV2_Resp_IB_v1, List<Sys_Log_Integration__c>> callTodSretrieveDebitsCreditsInqV2(String accountId, String fromDate) { //String accNum, String fromDate, String toDate,string CIFkey,string selectedprotype) {
        
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        dSretrieveDebitsCreditsInqV2_Resp_IB_v1 dSretrieveDebitsCreditsInqV2RespBean = new dSretrieveDebitsCreditsInqV2_Resp_IB_v1();
        Map<dSretrieveDebitsCreditsInqV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<dSretrieveDebitsCreditsInqV2_Resp_IB_v1, List<Sys_Log_Integration__c>>();
   
     
       
        try{
           
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.dSretrieveDebitsCreditsInqV2_STRING);
              
                if(integrationSettings!=null || Test.isRunningTest() || integrationSettings == null){
                   
                    dSretrieveDebitsCreditsInqV2_Req_IB_v1 requestBean = dSretrieveDebitsCreditsInqV2_IU_v1.mapRequestdFields(accountId,fromDate);//accNum,fromDate,toDate,CIFkey,selectedprotype);
                    System.debug('requestBean in IH'+requestBean) ;
                    //requestBean.startDate= fromDate; 
                     //requestBean.endDate= toDate; 
                    
                    system.debug(requestBean);
                     String jsonString = JSON.serialize(requestBean, true);

                    system.debug(requestBean);
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                    System.debug('endpoint'+request.getEndpoint());
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_dSretrieveDebitsCreditsInqV2_GET_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                   HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                  system.debug('+++'+response.getBody());
                    if(response.getStatusCode() == 200){
                        system.debug(JSON.deserialize(response.getBody(), dSretrieveDebitsCreditsInqV2_Resp_IB_v1.class));
                       dSretrieveDebitsCreditsInqV2RespBean = (dSretrieveDebitsCreditsInqV2_Resp_IB_v1) JSON.deserialize(response.getBody(), dSretrieveDebitsCreditsInqV2_Resp_IB_v1.class); 
                        dSretrieveDebitsCreditsInqV2RespBean.statusCode = response.getStatusCode();
                         dSretrieveDebitsCreditsInqV2RespBean.StatusMessage = response.getStatus() ;
                      
                    } else{
                        System.debug('Status Code NOT 200 - FAILURE');    
                        //Response was not 0
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                        dSretrieveDebitsCreditsInqV2RespBean = dSretrieveDebitsCreditsInqV2_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
                    
                        
                    }
                    
                } else{
                    //No Integration Settings Found
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.ESP_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    dSretrieveDebitsCreditsInqV2RespBean = dSretrieveDebitsCreditsInqV2_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MLgetAcctBalanceIF42V1_GET_STATUS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    System.debug(message);
                    
                }
                
            if (log != null) {
                logList.add(log);
              }
              responseMap.put(dSretrieveDebitsCreditsInqV2RespBean, logList);
            system.debug(responseMap);
             return responseMap;
            
        } catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            dSretrieveDebitsCreditsInqV2RespBean = dSretrieveDebitsCreditsInqV2_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_dSretrieveDebitsCreditsInqV2_GET_STATUS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        
        if(log != null){ 
            insert log;
        }
         responseMap.put(dSretrieveDebitsCreditsInqV2RespBean, logList);
          system.debug(responseMap);
         return responseMap;
    }


}