public class UpdateWillBankingDetails_IH_v1 {
	
    /* Updates the client Details in CIF
    * @Param:
    * @Return: UpdateClientDetailsCIF_Resp_IB_v1 bean */
    public static WillBankingDetails_IB_v1 updateWillBankingDetails(String willNoP, String branchCodeP, String bankNameP, String siteCodeP, String branchNameP, String accountTypeP, String accountNumberP, String clientNameP, String effectiveDateP){
        
        WillBankingDetails_IB_v1 responseBean;
        Sys_Log_Integration__c log;
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.UPDATE_WILL_BANKING_DETAILS);
            
            if(integrationSettings != null){
                
                //Map Fields
                WillBankingDetails_IB_v1 requestBean = UpdateWillBankingDetails_IU_v1.mapRequestFields(willNoP, branchCodeP, bankNameP, siteCodeP, branchNameP, accountTypeP, accountNumberP, clientNameP, effectiveDateP);
                
                String jsonString = requestBean.serialize(requestBean.BankingDetailsRequest);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                
                //Send Request
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.UPDATE_WILL_BANKING_DETAILS, StringConstants.SALESFORCE_STRING, StringConstants.CIF_STRING);
                
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                //Map Response
                responseBean = UpdateWillBankingDetails_IU_v1.mapResponseFields(response);
                
                if(response.getStatusCode() == 200){
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                }else{
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                }
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.UPDATE_WILL_BANKING_DETAILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.UPDATE_WILL_BANKING_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = UpdateWillBankingDetails_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
                System.debug(message);
            }
        }catch(Exception e){
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.UPDATE_WILL_BANKING_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = UpdateWillBankingDetails_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
            System.debug(message);
        }
        if(log != null){
            insert log;
        }
        return responseBean;
    }
}