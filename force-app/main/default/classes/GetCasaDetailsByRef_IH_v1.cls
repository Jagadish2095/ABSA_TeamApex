/*
* Integration Handler for Get Casa Details By Ref
* @author Jason Quevauvilliers & Danie Booysen
* @created 2019-07-08
*/
public class GetCasaDetailsByRef_IH_v1 {
    
    public static final String GET_CASA_DETAILS_BY_REF_SERVICE = 'Get Casa Details By Ref';
    public static final String GET_CASA_DETAILS_BY_REF_METHOD = 'GetCasaDetailsByRef_IH_v1.getCasaDetailsByRef';
    
    /* Method to retrieve CASA Details by their Reference Number - INSERTS Logs
     * @Param: String Reference Number
     * @Param: String start date
     * @Return: GetCasaDetailsByRef_Resp_IB_v1 Response Bean
     * */
    public static GetCasaDetailsByRef_Resp_IB_v1 getCasaDetailsByRef(String refNoP, String startFromP){
        
        return getCasaDetailsByRef(refNoP, startFromP, true);
    }
    
    /* Method to retrieve CASA Details by their Reference Number
     * @Param: String Reference Number
     * @Param: String start date
     * @Param: Boolean Insert Logs or not
     * @Return: GetCasaDetailsByRef_Resp_IB_v1 Response Bean
     * */
    public static GetCasaDetailsByRef_Resp_IB_v1 getCasaDetailsByRef(String refNoP, String startFromP, Boolean insertLogsP){
        
        GetCasaDetailsByRef_Resp_IB_v1 responseBean;
        Sys_Log_Integration__c log;
        
        try{
            //Get Integration Settings
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), GET_CASA_DETAILS_BY_REF_SERVICE);
            
            //Check If Integration Settings were found
            if(integrationSettings != null){
                
                GetCasaDetailsByRef_Req_IB_v1 requestBean = GetCasaDetailsByRef_IU_v1.mapRequestFields(refNoP, startFromP);
                
                String jsonString = requestBean.serialize(requestBean);
                
                //Create Request
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                
                System.debug('request++'+request.getBody());
                //Create Request Log
                log  = SystemLogger.createRequestIntegrationLog(request.getBody(), GET_CASA_DETAILS_BY_REF_METHOD, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                 
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                System.debug(response.getStatusCode() + ' ' + response.getBody());
                
                //Map Response Log
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                responseBean = GetCasaDetailsByRef_IU_v1.mapResponseFields(response);
                responseBean = translateToInternalValues(responseBean);
                
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  GET_CASA_DETAILS_BY_REF_SERVICE + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(GET_CASA_DETAILS_BY_REF_METHOD, GET_CASA_DETAILS_BY_REF_SERVICE, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = GetCasaDetailsByRef_IU_v1.mapFailedResponseFields(500,StringConstants.STATUS_CODE_500, message); 
                System.debug(message);
            }
        }catch(Exception e){
            //Exception response bean and log
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(GET_CASA_DETAILS_BY_REF_METHOD, GET_CASA_DETAILS_BY_REF_SERVICE, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = GetCasaDetailsByRef_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            System.debug(message);
        }
        //Insert Logs
        if(insertLogsP && log != null){
            insert log;
        }
        return responseBean;
    }
    
    public static GetCasaDetailsByRef_Resp_IB_v1 translateToInternalValues(GetCasaDetailsByRef_Resp_IB_v1  screeningRepBeanP){
        
        String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, 'eCasa Status By Ref', screeningRepBeanP.casaStatus, StringConstants.INBOUND_RECORD_TYPE);
        System.debug('casaStatusTranslated: ' + casaStatusTranslated);
        
        if(casaStatusTranslated != null){
            screeningRepBeanP.casaStatus = casaStatusTranslated;
        }
        
        return screeningRepBeanP;
    }
}