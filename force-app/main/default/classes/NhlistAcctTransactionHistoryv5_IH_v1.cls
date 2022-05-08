/**
* Descripton: Apex/Integration Handler class for nhlistAccTransactionHistoryv5 service
* Test Class Name: NhlistAcctTransactionHistoryv5_IH_v1_Test
* @author  Mashudu Raidimi
* @since   2020-03-01
*
**/
public class NhlistAcctTransactionHistoryv5_IH_v1 {
    
    /* Makes the callout to nhlistAccTransactionHistoryv5
    * @param: accountNumber,fromDate,toDate
    * @return: NhlistAccTransactionHistoryv5_Resp_IB_v1 object
   */
    
    public static Map<NhlistAccTransactionHistoryv5_Resp_IB_v1, List<Sys_Log_Integration__c>> callTonhlistaccttransactionhistoryv5( String accountNumberP,String fromDateP,String toDateP) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        NhlistAccTransactionHistoryv5_Resp_IB_v1 ListRespBean = new NhlistAccTransactionHistoryv5_Resp_IB_v1();
        Map<NhlistAccTransactionHistoryv5_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<NhlistAccTransactionHistoryv5_Resp_IB_v1, List<Sys_Log_Integration__c>>();
 
        try{
            
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings( StringConstants.JITTERBIT2, Sys_Utilities_General.getEnvironment(), StringConstants.GET_TRANSACTION_HISTORY);
            
            if(integrationSettings != null){
                NhlistAcctTransactionHistoryv5_Req_IB_v1  requestBean = NhlistAcctTransactionHistoryv5_IU_v1.mapRequestdFields(accountNumberP,fromDateP,toDateP);
           
                String jsonString = JSON.serialize(requestBean, true);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_GET_TRANSACTION_HISTORY, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                if(response.getStatusCode() == 200){
                   
                    ListRespBean = (NhlistAccTransactionHistoryv5_Resp_IB_v1) JSON.deserialize(response.getBody(), NhlistAccTransactionHistoryv5_Resp_IB_v1.class); 
                    ListRespBean.statusCode = response.getStatusCode();
                    ListRespBean.message = response.getStatus() ;

                    
                } else{
                    System.debug('Status Code NOT 200 - FAILURE'); 
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    ListRespBean = NhlistAcctTransactionHistoryv5_IU_v1.mapFailedResponseFields(response.getStatus(),response.getStatusCode(), response.getBody());

                }
                
            }
        }catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            ListRespBean = NhlistAcctTransactionHistoryv5_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_TRANSACTION_HISTORY, StringConstants.ESP_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }

            
            if (log != null) {
                logList.add(log);
            }
            responseMap.put(ListRespBean, logList);
            system.debug(responseMap);
            return responseMap;
            
        } 

    }