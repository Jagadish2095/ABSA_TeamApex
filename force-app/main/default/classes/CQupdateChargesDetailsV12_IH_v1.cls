public class CQupdateChargesDetailsV12_IH_v1 {

    public static final String CQ_UPDATE_CHARGES_DETAILS_V12 = 'CQupdateChargesDetailsV12';
    public static final String METHOD_CQ_UPDATE_CHARGES_DETAILS = 'CQupdateChargesDetailsV12_IH_v1.callToCQupdateChargesDetailsV12';
    
    public static Map<CQupdateChargesDetailsV12_Resp_IB_v1, List<Sys_Log_Integration__c>> callToCQupdateChargesDetailsV12(Map<String, Object> requestFieldsValues) {

        //Map<String, Object> responseBean = new Map<String, Object>();
        Sys_Log_Integration__c log = new Sys_Log_Integration__c();
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CQupdateChargesDetailsV12_Resp_IB_v1 responseBean = new CQupdateChargesDetailsV12_Resp_IB_v1();
        Map<CQupdateChargesDetailsV12_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CQupdateChargesDetailsV12_Resp_IB_v1, List<Sys_Log_Integration__c>>(); 

        try {
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, 
                                                                                                            Sys_Utilities_General.getEnvironment(), 
                                                                                                            CQ_UPDATE_CHARGES_DETAILS_V12
                                                                                                            );

            if (integrationSettings != null) {

                CQupdateChargesDetailsV12_Req_IB_v1 requestBean = CQupdateChargesDetailsV12_IU_v1.mapRequestFields(requestFieldsValues);
                System.debug('CQupdateChargesDetailsV12_IH_v1.callToCQupdateChargesDetailsV12 requestBean----> ' + JSON.serialize(requestBean));

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                Map<String, Object> respBodyMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                if (respBodyMap.get('errorMessage') != null) {

                    String message = (String) respBodyMap.get('errorMessage');
                    AuraHandledException e = new AuraHandledException(message);
                    e.setMessage(message);

                    throw e;
                }

                if (response != null) {
                    if (response.getStatusCode() == 200) {

                        responseBean = (CQupdateChargesDetailsV12_Resp_IB_v1) JSON.deserialize(response.getBody(), CQupdateChargesDetailsV12_Resp_IB_v1.class);
                        responseBean.statusCode = response.getStatusCode();
                        responseBean.status = response.getStatus();

                    } else {
                        System.debug('Status Code NOT 200 - FAILURE'); 
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                        responseBean = CQupdateChargesDetailsV12_IU_v1.mapFailedResponseFields(response.getStatus(), response.getStatusCode(), response.getBody());
                    }

                }

            } else {
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.ESP_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = CQupdateChargesDetailsV12_IU_v1.mapFailedResponseFields( StringConstants.STATUS_CODE_500, 500, message);
                log = SystemLogger.createInternalIntegrationLog(METHOD_CQ_UPDATE_CHARGES_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            }

            if (log != null) {
                insert log;
                logList.add(log);
            }

            responseMap.put(responseBean, logList);

        } catch (Exception ex) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + ex.getMessage() + '. ' + ex.getStackTraceString();
            responseBean = CQupdateChargesDetailsV12_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
            log = SystemLogger.createInternalIntegrationLog(METHOD_CQ_UPDATE_CHARGES_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);

            if (log != null) {
                logList.add(log);
            }
            responseMap.put(responseBean, logList);
            
            AuraHandledException e = new AuraHandledException(ex.getMessage());
            e.setMessage(ex.getMessage());

            throw e;

        }

        return responseMap;
    }
    
}