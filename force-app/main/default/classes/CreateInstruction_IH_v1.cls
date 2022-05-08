/*
* Integration Handler for EPS Create Instruction
* @author Jason Quevauvilliers
* @created 2019-01-21
* @modified by muvhuso nekhubvi
* @created 2019-02-13
*/

public class CreateInstruction_IH_v1 {
    /*
* POST Callout to EPS to create Instruction
* @param: Payment_Plan__c
* @param: User
* @param: Asset
* @param: lastMaintBrnchP
* @param: targetAccP
* @return: CreateInstruction_Resp_IB_v1 bean
* 
*/
    public static CreateInstruction_Resp_IB_v1 createInstruction(String  accountNumberP, String  accountTypeP, String branchCodeP, String amountP, User userP, String lastMaintBrnchP, String targetAccP){
        
        CreateInstruction_Resp_IB_v1 responseBean;
        Sys_Log_Integration__c log;
        
        try{
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CREATE_INSTRUCTION);
            
            if(integrationSettings != null){
                String accTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue('EPS', 'Account Type', accountTypeP, StringConstants.OUTBOUND_RECORD_TYPE);
                if(accTypeTranslated != null){
                    
                    //Map Request fields
                    CreateInstruction_Req_IB_v1 requestBean = CreateInstruction_IU_v1.mapRequestFields(accountNumberP, branchCodeP, amountP, userP, lastMaintBrnchP, targetAccP, accTypeTranslated);
                    
                    String jsonString = requestBean.serialize(requestBean);
                    //Create Http Request
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    //Send Request
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CREATE_INSTRUCTION, StringConstants.SALESFORCE_STRING, StringConstants.EPS_STRING);
                    //Map response bean
                    responseBean = CreateInstruction_IU_v1.mapResponseFields(response);
                    if(response.getStatusCode() >= 200 && response.getStatusCode() < 300){
                        //success
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    }else{
                        //failure
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    }
                }else{
                    String message = '';
                    message += accTypeTranslated == null ? 'Unable to Translate Account Type: ' + accountTypeP : '';
                    System.debug(message);
                    responseBean = CreateInstruction_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
                }
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CREATE_INSTRUCTION + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_INSTRUCTION, StringConstants.EPS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = CreateInstruction_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
            }
        }catch(Exception e){
            //Exception response bean and log
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_INSTRUCTION, StringConstants.EPS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = CreateInstruction_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
        }
        if(log != null){
            insert log;
        }
        return responseBean;
    }
    
    public static CreateInstruction_Resp_IB_v1 MBcreateInstruction(String  productTypeP, String beneficiaryName ,String targetAccP, String branchCodeP, String accountNumberP,String accountTypeP,String accessAccountP,String beneficiaryReferenceP,String ownReferenceP){
        
        CreateInstruction_Resp_IB_v1 responseBean;
        Sys_Log_Integration__c log;
        
        try{
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CREATE_INSTRUCTION);
            
            if(integrationSettings != null){
                
                //Map Request fields
                CreateInstruction_Req_IB_v1 requestBean = CreateInstruction_IU_v1.MBmapRequestFields(productTypeP, beneficiaryName,targetAccP, branchCodeP,accountNumberP,accountTypeP,accessAccountP,beneficiaryReferenceP,ownReferenceP);
                
                String jsonString = requestBean.serialize(requestBean);
                //Create Http Request
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MBCREATE_INSTRUCTION, StringConstants.SALESFORCE_STRING, StringConstants.EPS_STRING);
                //Map response bean
                responseBean = CreateInstruction_IU_v1.mapResponseFields(response);
                if(response.getStatusCode() >= 200 && response.getStatusCode() < 300){
                    //success
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                }else{
                    //failure
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    // responseBean = CreateInstruction_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
                }
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CREATE_INSTRUCTION + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MBCREATE_INSTRUCTION, StringConstants.EPS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = CreateInstruction_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
            }
        }catch(Exception e){
            //Exception response bean and log
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MBCREATE_INSTRUCTION, StringConstants.EPS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = CreateInstruction_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
        }
        if(log != null){
            insert log;
        }
        return responseBean;
    }
    
    
    public static CreateInstruction_Resp_IB_v1 MBCreateInstructionFuture(String srcAccountNumber,String srcAccountType ,String amount, String trgAccNumberP, String trgBranchCodeP, String trgAccReferenceP, String trgAccType,String futureDateP,String futureSourceRef,String accessAcc){
        
        CreateInstruction_Resp_IB_v1 responseBean;
        Sys_Log_Integration__c log;
        
        try{
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CREATE_INSTRUCTION);
            
            if(integrationSettings != null){
                //Added by chandra dated 01/02/2022 for target account type translation
                String accTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue('EPS', 'Account Type', trgAccType, StringConstants.OUTBOUND_RECORD_TYPE);
                if(accTypeTranslated != null){
                    
                    //Map Request fields
                    CreateInstruction_Req_IB_v1 requestBean = CreateInstruction_IU_v1.MBFutureMapRequestFields(srcAccountNumber,srcAccountType,amount,trgAccNumberP,trgBranchCodeP,trgAccReferenceP,trgAccType,futureDateP,futureSourceRef,accessAcc);
                    
                    String jsonString = requestBean.serialize(requestBean);
                    //Create Http Request
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    //Send Request
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CREATE_INSTRUCTION, StringConstants.SALESFORCE_STRING, StringConstants.EPS_STRING);
                    //Map response bean
                    responseBean = CreateInstruction_IU_v1.mapResponseFields(response);
                    if(response.getStatusCode() >= 200 && response.getStatusCode() < 300){
                        //success
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    }else{
                        //failure
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                        // responseBean = CreateInstruction_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
                    }
                }else{
                    String message = '';
                    message += accTypeTranslated == null ? 'Unable to Translate Account Type: ' + trgAccType : '';
                    System.debug(message);
                    responseBean = CreateInstruction_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
                }
                
                
                
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CREATE_INSTRUCTION + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_INSTRUCTION, StringConstants.EPS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = CreateInstruction_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
            }
        }catch(Exception e){
            //Exception response bean and log
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_INSTRUCTION, StringConstants.EPS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = CreateInstruction_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
        }
        if(log != null){
            insert log;
        }
        return responseBean;
    }
}