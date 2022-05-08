public with sharing class CvsValidationService_IH_v1 
{
    public static CvsValidationService_Resp_IB_v1 validateClient(CvsValidationService_Req_IB_v1 cvsValidate){
        
        Map<CvsValidationService_Resp_IB_v1, Sys_Log_Integration__c> beanToLogMap = validateClientMap(cvsValidate, true);
        List<CvsValidationService_Resp_IB_v1> beanList = new List<CvsValidationService_Resp_IB_v1>(beanToLogMap.keySet());
        return beanList[0];
    }
    
    public static CvsValidationService_Resp_IB_v1 validateClient(CvsValidationService_Req_IB_v1 cvsValidate, Boolean insertLogsP){
        
        Map<CvsValidationService_Resp_IB_v1, Sys_Log_Integration__c> beanToLogMap = validateClientMap(cvsValidate, insertLogsP);
        List<CvsValidationService_Resp_IB_v1> beanList = new List<CvsValidationService_Resp_IB_v1>(beanToLogMap.keySet());
        return beanList[0];
    }
    
 	/* Action method which synchronously calls the Validate Client Details operation with specified parameters
    ** CvsValidationService_Req_IB_v1
	*/    
    public static Map<CvsValidationService_Resp_IB_v1, Sys_Log_Integration__c> validateClientMap(CvsValidationService_Req_IB_v1 cvsValidate, Boolean insertLogsP)
    {        
        Sys_Log_Integration__c log;
        CvsValidationService_Resp_IB_v1 validateClientRespBean;
        Map<CvsValidationService_Resp_IB_v1, Sys_Log_Integration__c> beanToLogMap = new Map<CvsValidationService_Resp_IB_v1, Sys_Log_Integration__c>();   
        try
        {        
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.VALIDATE_CLIENT_DETAILS);
            
            if(integrationSettings != null)
            {
                //CvsValidationService_Req_IB_v1 validateclientRequest = CvsValidationService_IU_v1.mapRequestFields(cvsValidate);
                
                String jsonString = cvsValidate.serialize(cvsValidate);
                
                System.debug('jsonString++++'+jsonString);
               
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);
                              
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_VALIDATE_CLIENT_DETAILS, StringConstants.SALESFORCE_STRING, StringConstants.CIF_STRING);
          
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                validateClientRespBean = CvsValidationService_IU_v1.mapResponseFields(response);
                
                if(response.getStatusCode() == 200)
                {
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    System.debug('log1'+log);
                }
                else
                {
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                }
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.VALIDATE_CLIENT_DETAILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                validateClientRespBean = CvsValidationService_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_CLIENT_DETAILS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            validateClientRespBean = CvsValidationService_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_VALIDATE_CLIENT_DETAILS, StringConstants.VALIDATE_CLIENT_DETAILS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        beanToLogMap.put(validateClientRespBean, log);
        
        if(log != null && insertLogsP)
        {
            insert log;
            System.debug('insert log++'+log);
        }
        return beanToLogMap;
    }
    
    public static String getCVSVersion(){   
        //Get Version from Custom Setting
        CVS_Validation_Settings__c cvsValSettings = CVS_Validation_Settings__c.getOrgDefaults();
        String version = '4.0';
        if(cvsValSettings.Version_Number__c != null){
            version = cvsValSettings.Version_Number__c;
        }
        return version;
    } 
    
    public static List<String> getCVSValidatorSet(){   
        //Get Version from Custom Setting
        CVS_Validation_Settings__c cvsValSettings = CVS_Validation_Settings__c.getOrgDefaults();
        List<String> validatorSetList = new List<String>();
        
        if(cvsValSettings.Validator_Set__c != null){
            validatorSetList.addAll(cvsValSettings.Validator_Set__c.split(';'));
        }
        return validatorSetList;
    }
    
    // Onboarding simplex By Anka Ganta - 2020-02-05
     public static List<String> getCVSValidatorSetNonIndividual(){   
        //Get Version from Custom Setting
        CVS_Validation_Settings__c cvsValSettings = CVS_Validation_Settings__c.getOrgDefaults();
        List<String> validatorSetList = new List<String>();
        
        if(cvsValSettings.Validator_Set_NonIndividual__c != null){
            validatorSetList.addAll(cvsValSettings.Validator_Set_NonIndividual__c.split(';'));
        }
        return validatorSetList;
    }
    
    // TdB - Individual and Sole Prop nboarding for RBB
     public static List<String> getCVSValidatorSetRbbIndividual(){   
        //Get Version from Custom Setting
        CVS_Validation_Settings__c cvsValSettings = CVS_Validation_Settings__c.getOrgDefaults();
        List<String> validatorSetList = new List<String>();
        
        if(cvsValSettings.Validator_Set_RBB_Individual__c != null){
            validatorSetList.addAll(cvsValSettings.Validator_Set_RBB_Individual__c.split(';'));
        }
        return validatorSetList;
    }
    
    // TdB - Mini Individual for RBB
     public static List<String> getCVSValidatorSetRbbMiniIndividual(){   
        //Get Version from Custom Setting
        CVS_Validation_Settings__c cvsValSettings = CVS_Validation_Settings__c.getOrgDefaults();
        List<String> validatorSetList = new List<String>();
        
        if(cvsValSettings.Validator_Set_RBB_Mini_Individual__c != null){
            validatorSetList.addAll(cvsValSettings.Validator_Set_RBB_Mini_Individual__c.split(';'));
        }
        return validatorSetList;
    }
}