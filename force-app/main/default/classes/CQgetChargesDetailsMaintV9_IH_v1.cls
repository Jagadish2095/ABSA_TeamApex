public  class CQgetChargesDetailsMaintV9_IH_v1 {
    
    //Techmagic - Igor

    /**
     * Makes the callout to CQgetChargesDetailsMaintV9
     * @param accountNumber
     * @return CQgetChargesDetailsMaintV9_Resp_IB_v1 object
     */
    public static final String CQ_GET_CHARGES_DETAILS_MAINT_V9 = 'CQgetChargesDetailsMaintV9';
    public static final String METHOD_CQ_GET_CHARGES_DETAILS = 'CQgetChargesDetailsMaintV9_IH_v1.callToCQgetChargesDetailsMaintV9';


    public static Map<CQgetChargesDetailsMaintV9_Resp_IB_v1, List<Sys_Log_Integration__c>> callToCQgetChargesDetailsMaintV9(String accountNumber) {
        
        Sys_Log_Integration__c log = new Sys_Log_Integration__c();
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CQgetChargesDetailsMaintV9_Resp_IB_v1 responseBean = new CQgetChargesDetailsMaintV9_Resp_IB_v1();
        Map<CQgetChargesDetailsMaintV9_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CQgetChargesDetailsMaintV9_Resp_IB_v1, List<Sys_Log_Integration__c>>(); 

        try {
        
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, 
                                                                                                        Sys_Utilities_General.getEnvironment(), 
                                                                                                        CQ_GET_CHARGES_DETAILS_MAINT_V9
                                                                                                        );

            if (integrationSettings != null) {
        
                CQgetChargesDetailsMaintV9_Req_IB_v1  requestBean = CQgetChargesDetailsMaintV9_IU_v1.mapRequestFields(accountNumber);

                String jsonString = JSON.serialize(requestBean);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), METHOD_CQ_GET_CHARGES_DETAILS, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                Map<String, Object> respBodyMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                if (respBodyMap.get('errorMessage') != null) {
                    System.debug('111111111');
                    String message = (String) respBodyMap.get('errorMessage');
                    AuraHandledException e = new AuraHandledException(message);
                    e.setMessage(message);

                    throw e;
                }

                if (response != null) {
                    if (response.getStatusCode() == 200) {
                    
                        responseBean = (CQgetChargesDetailsMaintV9_Resp_IB_v1) JSON.deserialize(response.getBody(), CQgetChargesDetailsMaintV9_Resp_IB_v1.class); 
                        responseBean.statusCode = response.getStatusCode();
                        responseBean.status = response.getStatus();
                        
                    } else {
                        System.debug('Status Code NOT 200 - FAILURE'); 
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                        
                        responseBean = CQgetChargesDetailsMaintV9_IU_v1.mapFailedResponseFields(response.getStatus(), response.getStatusCode(), response.getBody());
                        
                    }
                } 

            } else {
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.ESP_STRING + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = CQgetChargesDetailsMaintV9_IU_v1.mapFailedResponseFields( StringConstants.STATUS_CODE_500, 500, message);
                log = SystemLogger.createInternalIntegrationLog(METHOD_CQ_GET_CHARGES_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            }

            if (log != null) {
                insert log;
                logList.add(log);
            }

            responseMap.put(responseBean, logList);

        } catch (Exception ex) {
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + ex.getMessage() + '. ' + ex.getStackTraceString();
            responseBean = CQgetChargesDetailsMaintV9_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
            log = SystemLogger.createInternalIntegrationLog(METHOD_CQ_GET_CHARGES_DETAILS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);

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