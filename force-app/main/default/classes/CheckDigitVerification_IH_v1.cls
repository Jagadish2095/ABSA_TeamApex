/**
* Integration Handler for Check Digit Verification
* @author Danie Booysen and Jason Quevauvilliers
* @created 2018-09-10
* @Updated by Jason Quevauvilliers
* @Updated Date 2018-09-14
*/
public class CheckDigitVerification_IH_v1 {
    
    public static CheckDigitVerification_Resp_IB_v1 checkDigitVerification(String accountNumberP, String branchCodeP, String accountTypeP, String transactionTypeP, String cdvRequiredP, String expiryDateP, String channelP, String applicationP, String msgLanguageP, String msgTargetP, String traceP){
        
        CheckDigitVerification_Resp_IB_v1 checkDigitVerificationResponse;
        Sys_Log_Integration__c log;
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CHECK_DIGIT_VERIFICATION);
			
            if(integrationSettings != null){
                //Map Request Fields
                CheckDigitVerification_Req_IB_v1 checkDigitVerificationRequest = CheckDigitVerification_IU_v1.mapRequestFields(accountNumberP, branchCodeP, accountTypeP, transactionTypeP, cdvRequiredP, expiryDateP, channelP, applicationP, msgLanguageP, msgTargetP, traceP);
                
                String jsonString = JSON.serialize( checkDigitVerificationRequest, true );
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCallout(Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString));
                
                ///Map Response Fields
                response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
                checkDigitVerificationResponse = CheckDigitVerification_IU_v1.mapResponseFields(response);
                
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CHECK_DIGIT_VERIFICATION + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CHECK_DIGIT_VERIFICATION, StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                checkDigitVerificationResponse = CheckDigitVerification_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            	System.debug(message);
            }
        
        }catch(Exception e){
            //Map bad response and create a log
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CHECK_DIGIT_VERIFICATION, StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
            checkDigitVerificationResponse = CheckDigitVerification_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, description);
        }
        if(log != null){
            insert log;
        }
        return checkDigitVerificationResponse;
    }
    
}