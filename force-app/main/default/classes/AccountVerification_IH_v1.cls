/*
* Integration Handler to Verify Account Details
* @author Danie Booysen
* @created 2019-01-21
* @updated 2019-03-08
*/
public class AccountVerification_IH_v1 {
    
/*
* POST Callout to AVS to Validate Account Details
* @param: Account Number
* @param: Branch Code
* @param: Bank Name
* @param: Account Type
* @param: Account Object
* @param: AVSR User Code
* @param: Channel
* @param: Application
* @return: Response Bean of type AccountVerification_Resp_IB_v1
*/
    
    public static AccountVerification_Resp_IB_v1 accountVerification(String accountNumberP, String branchCodeP, String bankName, String accountType, Account accountP, String avsruserP, String channelP, String applicationP){
        
        AccountVerification_Resp_IB_v1 responseBean;
        Sys_Log_Integration__c log;
        
        try{
            
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.ACCOUNT_VERIFICATION_DETAILS);

            System.debug('integrationSettings: ' + integrationSettings);
            if(integrationSettings != null){
                
                //Value Translations
                String bankTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('AVS', 'Bank Name', bankName, StringConstants.OUTBOUND_RECORD_TYPE);
                String accTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('AVS', 'Account Type', accountType, StringConstants.OUTBOUND_RECORD_TYPE);
                
                if(bankTranslated != null && accTypeTranslated != null){
                    
                    //Map Fields
                    AccountVerification_Req_IB_v1 requestBean = AccountVerification_IU_v1.mapRequestFields(accountNumberP, branchCodeP, accountP, bankTranslated, accTypeTranslated, avsruserP, channelP, applicationP);
                    
                    String jsonString = requestBean.serialize(requestBean);
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    
                    //Send Request
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_ACCOUNT_VERIFICATION, StringConstants.SALESFORCE_STRING, StringConstants.AVS_STRING);
                    
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    //Map Response
                    responseBean = AccountVerification_IU_v1.mapResponseFields(response);
                    
                    if(response.getStatusCode() == 200){
                        //populate log;
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    }else{
                        //populate log;
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    }
                }else{
                    //Integration Translations Value IF
                    String message = '';
                    if(bankTranslated == null){
                        message += 'Unable to map Bank Name to the external value for: ' + bankName + '. ';
                    }
                    if(accTypeTranslated == null){
                        message += 'Unable to map Account Type to the external value for: ' + accountType + '. ';
                    }
                    System.debug(message);
                    responseBean = AccountVerification_IU_v1.mapFailedResponseFields(StringConstants.INTEGRATION_STATUS_FAILED, 500, message);
                }
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.ACCOUNT_VERIFICATION_DETAILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_ACCOUNT_VERIFICATION, StringConstants.AVS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = AccountVerification_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
            }
        }catch(Exception e){
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_ACCOUNT_VERIFICATION, StringConstants.AVS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = AccountVerification_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
        }
        if(log != null){
            //insert log;
        }
        
        return responseBean;
    }
}