public class CQvalAcctHoldsV4_IH_v1 {
    
    public static Map<CQvalAcctHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> callTocqvalacctholdsv4( String accountNumberP,String blocked, String courtOrder, String mandateRequired,
                                                                                                         String dormant, String semiDormant, String confiscated, String externalTransfer,
                                                                                                         String staff, String creditAccount, String excludeFromEstate, String blockAdhocDbt,
                                                                                                         String blockAdhocCrd, String specialRqpRedirect, String commercialPropFin,
                                                                                                         String misHold, String genSecMsg, String genSecNum, String wapWildAccPickup, 
                                                                                                         String exclFromInsolvent, String digitalHold, String odSwitchInd) {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CQvalAcctHoldsV4_Resp_IB_v1 ListRespBean = new CQvalAcctHoldsV4_Resp_IB_v1();
        Map<CQvalAcctHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CQvalAcctHoldsV4_Resp_IB_v1, List<Sys_Log_Integration__c>>();
 
        try{
            
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_DEV, Sys_Utilities_General.getEnvironment(), StringConstants.CQ_VAL_ACCOUNT_HOLDS);
            
            if(integrationSettings!=null || Test.isRunningTest() || integrationSettings == null){
                CQvalAcctHoldsV4_Req_IB_v1  requestBean = CQvalAcctHoldsV4_IU_v1.mapRequestdFields(accountNumberP,blocked,courtOrder,mandateRequired,
                                                                                                   dormant,semiDormant,confiscated,externalTransfer,
                                                                                                   staff,creditAccount,excludeFromEstate,blockAdhocDbt,
                                                                                                   blockAdhocCrd,specialRqpRedirect,commercialPropFin,
                                                                                                   misHold,genSecMsg,genSecNum,wapWildAccPickup, 
                                                                                                   exclFromInsolvent,digitalHold,odSwitchInd);
           
                String jsonString = JSON.serialize(requestBean, true);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0],jsonString);
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CQ_VAL_ACCOUNT_HOLDS, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                if(response!=null){
                if(response.getStatusCode() == 200){
                   
                    ListRespBean = (CQvalAcctHoldsV4_Resp_IB_v1) JSON.deserialize(response.getBody(), CQvalAcctHoldsV4_Resp_IB_v1.class); 
                    ListRespBean.statusCode = response.getStatusCode();
                    ListRespBean.message = response.getStatus() ; 

                    
                } else{
                    System.debug('Status Code NOT 200 - FAILURE'); 
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    ListRespBean = CQvalAcctHoldsV4_IU_v1.mapFailedResponseFields(response.getStatus(),response.getStatusCode(), response.getBody());

                }
                } 
            }
        }
            catch(Exception e){
            //Exception
            System.debug(e.getMessage() + '.' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            ListRespBean = CQvalAcctHoldsV4_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CQ_VAL_ACCOUNT_HOLDS,'JitterbitServices', 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
          
            
            if (log != null) {
                logList.add(log);
            }
            responseMap.put(ListRespBean, logList);
            system.debug(responseMap);
            return responseMap;
            
        } 
        

    

}