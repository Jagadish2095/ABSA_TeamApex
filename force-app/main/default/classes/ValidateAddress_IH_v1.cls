public class ValidateAddress_IH_v1 {
    
    //Validate Address Details and insert logs
    public static ValidateAddress_Resp_IB_v1 validateAddressDetails(String languageP, Integer numberOfAddressP, Integer addressTypeP, String addressLine1P, String addressLine2P, String suburbP, String townP, String postalCodeP){
        
        Map<ValidateAddress_Resp_IB_v1, Sys_Log_Integration__c> validateAddressMap = validateAddressDetailsMap(languageP, numberOfAddressP, addressTypeP, addressLine1P, addressLine2P, suburbP, townP, postalCodeP);
        
        if(validateAddressMap.values().size() > 0){
            insert validateAddressMap.values()[0];
        }
        List<ValidateAddress_Resp_IB_v1> beanList = new List<ValidateAddress_Resp_IB_v1>(validateAddressMap.keySet());
        
        return beanList[0]; 
    }
    
    //Validate Address Details and return the bean and the log
    public static Map<ValidateAddress_Resp_IB_v1, Sys_Log_Integration__c> validateAddressDetailsMap(String languageP, Integer numberOfAddressP, Integer addressTypeP, String addressLine1P, String addressLine2P, String suburbP, String townP, String postalCodeP){
        
        ValidateAddress_Resp_IB_v1 validateAddressResponse;
        Sys_Log_Integration__c log;
        Map<ValidateAddress_Resp_IB_v1, Sys_Log_Integration__c> beanToLogMap = new Map<ValidateAddress_Resp_IB_v1, Sys_Log_Integration__c>();
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.VALIDATE_ADDRESS);
            
            if(integrationSettings != null){
                //Map Request Fields
                ValidateAddress_Req_IB_v1 validateAddressRequest = ValidateAddress_IU_v1.mapRequestFields(languageP, numberOfAddressP, addressTypeP, addressLine1P, addressLine2P, suburbP, townP, postalCodeP);
                
                String jsonString = validateAddressRequest.serialize( validateAddressRequest );
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), 'ValidateAddress_IH_v1.validateAddressDetails', StringConstants.SALESFORCE_STRING, StringConstants.CIF_STRING);
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                ///Map Response Fields
                validateAddressResponse = ValidateAddress_IU_v1.mapResponseFields(response);
                
                if(response.getStatusCode() == 200){
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                }else{
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                }
            }else{
                
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND;
                log = SystemLogger.createInternalIntegrationLog('ValidateAddress_IH_v1.validateAddressDetails', StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                validateAddressResponse = ValidateAddress_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            }
            
        }catch(Exception e){
            //Map bad response and create a log
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog('ValidateAddress_IH_v1.validateAddressDetails', StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            validateAddressResponse = ValidateAddress_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
        }
        beanToLogMap.put(validateAddressResponse, log);
        return beanToLogMap;
    }
}