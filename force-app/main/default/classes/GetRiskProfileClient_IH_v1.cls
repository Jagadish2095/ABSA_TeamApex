public class GetRiskProfileClient_IH_v1 {
    
    public static GetRiskProfileClient_Resp_IB_v1 getRiskProfileClient(Account accountP, String userIdP, List<String> productCodeListP, List<String> subProductCodeListP, List<String> countriesListP, String sbu){
        
        GetRiskProfileClient_Resp_IB_v1 riskProfileClientResponse;
        Sys_Log_Integration__c log;
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_RISK_PROFILE_CLIENT);
            
            List<General_Virtual_Advisor_Rules__mdt> metaDataList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
            
            if(integrationSettings != null && metaDataList.size() > 0 && accountP != null){
                
                String occupationStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_OCCUPATION_STATUS_STRING, accountP.Occupation_Status__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String occupationCategoryTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_OCCUPATION_CATEGORY_STRING, accountP.Occupation_Category__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                String incomeSourceTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.ECASA_STRING, StringConstants.FIELD_SOURCE_OF_INCOME_STRING, accountP.Income_Source__pc, StringConstants.OUTBOUND_RECORD_TYPE);
                
                if(occupationStatusTranslated != null && occupationCategoryTranslated != null && incomeSourceTranslated != null){
                    
                    //Map Fields
                    GetRiskProfileClient_Req_IB_v1 getRiskProfileClientRequest = GetRiskProfileClient_IU_v1.mapRequestFields(accountP, userIdP, occupationStatusTranslated, occupationCategoryTranslated, incomeSourceTranslated, metaDataList, productCodeListP, subProductCodeListP, countriesListP,sbu);
                    if(String.isBlank(getRiskProfileClientRequest.errorMessage)){
                        
                        String jsonString = JSON.serialize( getRiskProfileClientRequest, true );
                        HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                        System.debug('request: ' + request.getBody());
                        //Send Request
                        HttpResponse response = Sys_Utilities_Integration.serviceCallout(request);
                        
                        if(response.getBody() == StringConstants.ERROR_MSG_READ_TIMED_OUT){
                            
                            riskProfileClientResponse = GetRiskProfileClient_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, StringConstants.ERROR_MSG_READ_TIMED_OUT);
                        }else{
                            
                            ///Map Fields
                            response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
                            riskProfileClientResponse = GetRiskProfileClient_IU_v1.mapResponseFields(response);
                        }
                    }else{
                        System.debug('Request Bean Error: ' + getRiskProfileClientRequest.errorMessage);
                        log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_RISK_PROFILE, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, getRiskProfileClientRequest.errorMessage);
                        riskProfileClientResponse = GetRiskProfileClient_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, getRiskProfileClientRequest.errorMessage);
                    }
                }else{
                    String message = '';
                    if(occupationStatusTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_OCCUPATION_STATUS + accountP.Occupation_Status__pc + '. ';
                    }
                    if(occupationCategoryTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_OCCUPATION_CATEGORY + accountP.Occupation_Category__pc + '. ';
                    }
                    if(incomeSourceTranslated == null){
                        message += StringConstants.ERROR_MSG_UNABLE_TO_MAP_ECASA_INCOME_SOURCE + accountP.Income_Source__pc + '. ';
                    }
                    
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_RISK_PROFILE, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    riskProfileClientResponse = GetRiskProfileClient_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                    System.debug('message: ' + message);
                    
                }
            }else{
                //No Integration Settings
                String message = '';
                message += integrationSettings == null ? StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_RISK_PROFILE_CLIENT + '. Environment: ' + Sys_Utilities_General.getEnvironment() + '. ' : '';
                message += metaDataList.size() == 0 ? StringConstants.ERROR_MSG_NO_GENERAL_ADVISOR_MDT_FOUND : '';
                message += accountP == null ? StringConstants.ERROR_MSG_UNABLE_TO_FIND_ACCOUNT : '';
                System.debug(message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_RISK_PROFILE, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                riskProfileClientResponse = GetRiskProfileClient_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                
            }
        }catch(Exception e){
            
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_RISK_PROFILE, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
            riskProfileClientResponse = GetRiskProfileClient_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, description);
        }
        if(log != null){
            insert log;
        }
        return riskProfileClientResponse;
    }
}