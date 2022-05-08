/**
* Descripton: Apex/Integration Handler class for nqcancelacctnotificationv1 service
* Test Class Name: nqcancelacctnotificationv1_IH_v1_Test
* @author  Srikanth : Absa
* @since   2020-31-01
*
**/
public class nqcancelacctnotificationv1_IH_v1{

    /* Makes the callout to nqcancelacctnotificationv1 
    * @param: List of Accounts
    * @return: nqcancelacctnotificationv1_Resp_IB_v1 bean object
   */
     
    //public static Map<nqcancelacctnotificationv1_Resp_IB_v1, List<Sys_Log_Integration__c>> callTonqcancelacctnotificationv1(nqcancelacctnotificationv1_Req_IB_v1 requestBean) { 
    public static Map<nqcancelacctnotificationv1_Resp_IB_v1, List<Sys_Log_Integration__c>> callTonqcancelacctnotificationv1( nqcancelacctnotificationv1_Req_IB_v1 requestBean) { //String accNum, String fromDate, String toDate,string CIFkey,string selectedprotype) {
        
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        nqcancelacctnotificationv1_Resp_IB_v1 nqcancelacctnotificationv1RespBean = new nqcancelacctnotificationv1_Resp_IB_v1();
        Map<nqcancelacctnotificationv1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<nqcancelacctnotificationv1_Resp_IB_v1, List<Sys_Log_Integration__c>>();
   
     
       
        try{
           
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings('JitterbitDev', Sys_Utilities_General.getEnvironment(), StringConstants.nqcancelacctnotificationv1_STRING);
              
                if(integrationSettings!=null || Test.isRunningTest() || integrationSettings == null){
                   
                   // nqcancelacctnotificationv1_Req_IB_v1 requestBean = nqcancelacctnotificationv1_IU_v1.mapRequestdFields();//accNum,fromDate,toDate,CIFkey,selectedprotype);
                    System.debug('requestBean in IH'+requestBean) ;
                    //requestBean.startDate= fromDate; 
                     //requestBean.endDate= toDate; 
                    
                    system.debug(requestBean);
                     String jsonString = JSON.serialize(requestBean, true);

                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                    
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_nqcancelacctnotificationv1_GET_STATUS, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                   HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                  system.debug('+++'+response.getBody());
                    if(response.getStatusCode() == 200){
                        system.debug(JSON.deserialize(response.getBody(), nqcancelacctnotificationv1_Resp_IB_v1.class));
                       nqcancelacctnotificationv1RespBean = (nqcancelacctnotificationv1_Resp_IB_v1) JSON.deserialize(response.getBody(), nqcancelacctnotificationv1_Resp_IB_v1.class); 
                        nqcancelacctnotificationv1RespBean.statusCode = response.getStatusCode();
                         nqcancelacctnotificationv1RespBean.StatusMessage = response.getStatus() ;
                      
                    } else{
                        System.debug('Status Code NOT 200 - FAILURE');    
                        //Response was not 0
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                        nqcancelacctnotificationv1RespBean = nqcancelacctnotificationv1_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
                    
                        
                    }
                    
                } else{
                    //No Integration Settings Found
                    String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.ESP_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                    nqcancelacctnotificationv1RespBean = nqcancelacctnotificationv1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_nqcancelacctnotificationv1_GET_STATUS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    System.debug(message);
                    
                }
                
            if (log != null) {
                logList.add(log);
              }
              responseMap.put(nqcancelacctnotificationv1RespBean, logList);
            system.debug(responseMap);
             return responseMap;
            
        } catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            nqcancelacctnotificationv1RespBean = nqcancelacctnotificationv1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_nqcancelacctnotificationv1_GET_STATUS, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        
        if(log != null){
            insert log;
        }
         responseMap.put(nqcancelacctnotificationv1RespBean, logList);
          system.debug(responseMap);
         return responseMap;
    }


}