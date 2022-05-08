public class DebitOrderInstruction_IH_v1 
{
    /* Action method which synchronously calls the Debit Order Instruction operation with specified parameters
    ** String WillNo, Integer FeeCode, Decimal Amount, String PaymentDate, String BankName, Integer BranchCode, String BranchName, Integer AccountNumber, String AccountType
	*/    
    public static DebitOrderInstruction_Resp_IB_v1 debitOrderInstruction(String WillNo, Integer FeeCode, Decimal Amount, String PaymentDate, String BankName, Integer BranchCode, String BranchName, String AccountNumber, String AccountType)
    {        
        Sys_Log_Integration__c log;
        DebitOrderInstruction_Resp_IB_v1 responseBean;
        Integration_API__c integrationSettings;
           
        try
        {           
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.DEBIT_ORDER_INSTRUCTION);

            if(integrationSettings != null)
            {
                DebitOrderInstruction_Req_IB_v1 createRecordRequest = DebitOrderInstruction_IU_v1.mapRequestFields(WillNo, FeeCode, Amount, PaymentDate, BankName, BranchCode, BranchName, AccountNumber, AccountType);
                
                String jsonString = JSON.serialize(createRecordRequest, true);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);          
            	 
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_DEBIT_ORDER_INSTRUCTION, StringConstants.SALESFORCE_STRING, request.getEndpoint());
          
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                responseBean = DebitOrderInstruction_IU_v1.mapResponseFields(response);
                
                System.debug('Debit Order Instruction Request Bean: ' + responseBean);
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.DEBIT_ORDER_INSTRUCTION + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = DebitOrderInstruction_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_DEBIT_ORDER_INSTRUCTION, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = DebitOrderInstruction_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_DEBIT_ORDER_INSTRUCTION, StringConstants.WILLS_SYSTEM, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        if(log != null)
        {
            insert log;
        }
         
        return responseBean;
    }
}