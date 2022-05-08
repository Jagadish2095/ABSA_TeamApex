/**
* Integration Handler for Get Bank Clearance Codes
* @author Danie Booysen and Jason Quevauvilliers
* @created 2018-09-10
* @Updated by Jason Quevauvilliers
* @Updated Date 2018-09-14
*/
public class GetBankClearanceCodes_IH_v1 {

    public static GetBankClearanceCodes_Resp_IB_v1 getBankClearanceCodes(String channelP, String applicationP, String traceP, String msgLanguageP, String msgTargetP, String ichannelP, String instNameLstP, String clrCodeLstP){
        
        GetBankClearanceCodes_Resp_IB_v1 bankClearanceCodesResponse;
        Sys_Log_Integration__c log;
        
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.GET_BANK_CLEARANCE_CODES);
            
            if(integrationSettings != null){
                //Map Fields
                GetBankClearanceCodes_Req_IB_v1 bankClearanceCodesRequest = GetBankClearanceCodes_IU_v1.mapRequestFields(channelP, applicationP, traceP, msgLanguageP, msgTargetP, ichannelP, instNameLstP, clrCodeLstP);
                
                String jsonString = JSON.serialize( bankClearanceCodesRequest, true );
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCallout(Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString));
                
                ///Map Fields
                response.setBody(response.getBody().replace('Type', 'innerExceptionType'));
                bankClearanceCodesResponse = getBankClearanceCodes_IU_v1.mapResponseFields(response);
                
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_BANK_CLEARANCE_CODES + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_BANK_CLEARANCE_CODES, StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                bankClearanceCodesResponse = getBankClearanceCodes_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            	System.debug(message);
            }
            
        }catch(Exception e){
            //Map a bad response and create a log
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String description = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_BANK_CLEARANCE_CODES, StringConstants.SIEBEL_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
            bankClearanceCodesResponse = getBankClearanceCodes_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, description);
        }
        if(log != null){
            insert log;
        }
        return bankClearanceCodesResponse;
    }
}