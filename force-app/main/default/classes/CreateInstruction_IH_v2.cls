/*
 * Integration Handler for CreateInstruction v2 Service
 * @author Rudolf Niehaus
 * @created 2020-05-17
 */
public class CreateInstruction_IH_v2 {
    /*
    * POST Callout to EPS to create Instruction
    * @param: Payment_Plan__c
    * @param: User
    * @param: Asset
    * @param: lastMaintBrnchP
    * @param: targetAccP
    * @return: CreateInstruction_Resp_IB_v2 bean
    * 
    */
    public static CreateInstruction_Resp_IB_v2 createInstruction(String accessAcc, String beneficiaryName,
                                                                String actDate, String endDate, String payDay, String freq, String amount,
                                                                String srcAccNumber,String srcAccType, String srcBranchCode, String srcRef, 
                                                                String trgAccNumber,String trgAccType, String trgBranchCode,String trgRef,
                                                                String siteCode, String teller){
        
        CreateInstruction_Resp_IB_v2 responseBean;
        Sys_Log_Integration__c log;
        
        try{
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CREATE_INSTRUCTION);
            
            if(integrationSettings != null){
                    
                    //Map Request fields
                    CreateInstruction_Req_IB_v2 requestBean = CreateInstruction_IU_v2.mapRequestFields(accessAcc, beneficiaryName,
                                                                                                         actDate,  endDate,  payDay,  freq,  amount,
                                                                                                         srcAccNumber, srcAccType,  srcBranchCode,  srcRef, 
                                                                                                         trgAccNumber, trgAccType,  trgBranchCode, trgRef,
                                                                                                         siteCode,  teller);
                    
                    String jsonString = requestBean.serialize(requestBean);
                    //Create Http Request
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    //Send Request
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CREATE_INSTRUCTION, StringConstants.SALESFORCE_STRING, StringConstants.EPS_STRING);
                    //Map response bean
                    responseBean = CreateInstruction_IU_v2.mapResponseFields(response);
                    if(response.getStatusCode() >= 200 && response.getStatusCode() < 300){
                        //success
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    }else{
                        //failure
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    }
      
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CREATE_INSTRUCTION + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_INSTRUCTION, StringConstants.EPS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = CreateInstruction_IU_v2.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message); 
            }
        }catch(Exception e){
            //Exception response bean and log
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_INSTRUCTION, StringConstants.EPS_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = CreateInstruction_IU_v2.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
        }
        if(log != null){
            insert log;
        }
        return responseBean;
    }
}