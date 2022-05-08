/*
 * Integration Handler for MBdeleteInstructionV2 Service
 * @author Rudolf Niehaus
 * @created 2020-03-21
 */

public class MBdeleteInstructionV2_IH_v1 {

    public static Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> MBdeleteInstructionV2(String cif, String instrNo, String siteCode, String teller, String tieb) {

        Sys_Log_Integration__c log;

        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        MBdeleteInstructionV2_Resp_IB_v1 responseBean;
        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>>();

        Integration_API__c integrationSettings;

        try {

            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_DELETE_BENEFICIARIES_V2);

            if (integrationSettings != null) {

                MBdeleteInstructionV2_Req_IB_v1 requestBean = MBdeleteInstructionV2_IU_v1.mapRequestFields(cif, instrNo, siteCode, teller,tieb);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('MBdeleteInstructionV2 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                insert log;

                responseBean = MBdeleteInstructionV2_IU_v1.mapResponseFields(response);

                System.debug('MBdeleteInstructionV2 Response Bean: ' + responseBean);

            }else {

                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.MB_DELETE_BENEFICIARIES_V2 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = MBdeleteInstructionV2_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                insert log;
                System.debug(message);

            }
        } catch (Exception e) {

            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBdeleteInstructionV2_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            insert log;
            System.debug(message);

        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
    
    public static Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> MBdeleteInstructionForIVR(String cif, String tieb, String instrNo) {

        Sys_Log_Integration__c log;

        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        MBdeleteInstructionV2_Resp_IB_v1 responseBean;
        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>>();

        Integration_API__c integrationSettings;

        try {

            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_DELETE_BENEFICIARIES_V2);

            if (integrationSettings != null) {

                MBdeleteInstructionV2_Req_IB_v1 requestBean = MBdeleteInstructionV2_IU_v1.mapRequestFieldsIVR(cif,tieb, instrNo);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('MBdeleteInstructionV2 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                insert log;

                responseBean = MBdeleteInstructionV2_IU_v1.mapResponseFields(response);

                System.debug('MBdeleteInstructionV2 Response Bean: ' + responseBean);

            }else {

                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.MB_DELETE_BENEFICIARIES_V2 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = MBdeleteInstructionV2_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                insert log;
                System.debug(message);

            }
        } catch (Exception e) {

            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBdeleteInstructionV2_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            insert log;
            System.debug(message);

        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
    
     public static Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> MBdeleteInstructionV2Forpayment(String cif, String instrNo, String siteCode, String teller) {//String cif, String instrNo, String siteCode, String teller
        
        Sys_Log_Integration__c log;
        
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        MBdeleteInstructionV2_Resp_IB_v1 responseBean;
        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        
        Integration_API__c integrationSettings;
        
        try {
            
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_DELETE_BENEFICIARIES_V2);
            
            if (integrationSettings != null) {
                
                MBdeleteInstructionV2_Req_IB_v1 requestBean = MBdeleteInstructionV2_IU_v1.mapRequestForPayment(cif, instrNo, siteCode, teller);
                
                String jsonString = JSON.serialize(requestBean, true);
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                system.debug('MBdeleteInstructionV2 Response: ' + response);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                insert log;
                
                responseBean = MBdeleteInstructionV2_IU_v1.mapResponseFields(response);
                
                System.debug('MBdeleteInstructionV2 Response Bean: ' + responseBean);
                
            }else {
                
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.MB_DELETE_BENEFICIARIES_V2 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = MBdeleteInstructionV2_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
                
            }
        } catch (Exception e) {
            
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBdeleteInstructionV2_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
            
        }
        
        if (log != null) {
            logList.add(log);
        }
        
        responseMap.put(responseBean, logList);
        return responseMap;
    }
    
    public static Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> MBdeleteInstructionV2ForStopOrder(String cif, String instrNo, String siteCode, String teller) {//String cif, String instrNo, String siteCode, String teller
        
        Sys_Log_Integration__c log;
        
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        MBdeleteInstructionV2_Resp_IB_v1 responseBean;
        Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBdeleteInstructionV2_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        
        Integration_API__c integrationSettings;
        
        try {
            
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_DELETE_BENEFICIARIES_V2);
            
            if (integrationSettings != null) {
                
                MBdeleteInstructionV2_Req_IB_v1 requestBean = MBdeleteInstructionV2_IU_v1.mapRequestStopOrder(cif, instrNo, siteCode, teller);
                
                String jsonString = JSON.serialize(requestBean, true);
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                system.debug('MBdeleteInstructionV2 Response: ' + response);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                insert log;
                
                responseBean = MBdeleteInstructionV2_IU_v1.mapResponseFields(response);
                
                System.debug('MBdeleteInstructionV2 Response Bean: ' + responseBean);
                
            }else {
                
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.MB_DELETE_BENEFICIARIES_V2 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = MBdeleteInstructionV2_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
                
            }
        } catch (Exception e) {
            
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBdeleteInstructionV2_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_DELETE_BENEFICIARIES_V2, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
            
        }
        
        if (log != null) {
            logList.add(log);
        }
        
        responseMap.put(responseBean, logList);
        return responseMap;
    }


  

}