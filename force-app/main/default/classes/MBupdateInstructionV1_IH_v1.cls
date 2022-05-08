/*
 * Integration Handler for MBupdateInstructionV1 Service
 * @author Rudolf Niehaus
 * @created 2020-03-20
 */

public class MBupdateInstructionV1_IH_v1 {

    public static Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> MBupdateInstructionV1(String cif, String instrNo, String beneficiaryName, 
                                                                                                            String srcAccNumber,String srcAccType, String srcBranchCode, String srcRef, 
                                                                                                            String trgAccNumber,String trgAccType, String trgBranchCode,String trgRef,
                                                                                                            String siteCode, String teller, String tieb) {

        Sys_Log_Integration__c log;

        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        MBupdateInstructionV1_Resp_IB_v1 responseBean;
        Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();

        Integration_API__c integrationSettings;

        try {

            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_UPDATE_BENEFICIARIES_V1);

            if (integrationSettings != null) {

                MBupdateInstructionV1_Req_IB_v1 requestBean = MBupdateInstructionV1_IU_v1.mapRequestFields(cif, instrNo, beneficiaryName, 
                                                                                                            srcAccNumber,srcAccType, srcBranchCode, srcRef, 
                                                                                                            trgAccNumber,trgAccType, trgBranchCode,trgRef,
                                                                                                            siteCode, teller, tieb);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('MBupdateInstructionV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                insert log;

                responseBean = MBupdateInstructionV1_IU_v1.mapResponseFields(response);

                System.debug('MBupdateInstructionV1 Response Bean: ' + responseBean);

            }else {

                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.MB_UPDATE_BENEFICIARIES_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = MBupdateInstructionV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);

            }
        } catch (Exception e) {

            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBupdateInstructionV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);

        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
    
    
    
        
    public static Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> updateInstruction(String cif, String instrNo,String amount, String instrRefName, 
                                                                                                            String srcAccNumber,String srcAccType, String srcBranchCode, String srcRef, 
                                                                                                            String trgAccNumber,String trgAccType, String trgBranchCode,String trgRef,
                                                                                                            String siteCode, String teller,String actDate) {

        Sys_Log_Integration__c log;

        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        MBupdateInstructionV1_Resp_IB_v1 responseBean;
        Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();

        Integration_API__c integrationSettings;

        try {

            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_UPDATE_BENEFICIARIES_V1);

            if (integrationSettings != null) {

                MBupdateInstructionV1_Req_IB_v1 requestBean = MBupdateInstructionV1_IU_v1.mapRequest(cif, instrNo,amount, instrRefName, 
                                                                                                            srcAccNumber,srcAccType, srcBranchCode, srcRef, 
                                                                                                            trgAccNumber,trgAccType, trgBranchCode,trgRef,siteCode, teller,actDate);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('MBupdateInstructionV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                insert log;

                responseBean = MBupdateInstructionV1_IU_v1.mapResponseFields(response);

                System.debug('MBupdateInstructionV1 Response Bean: ' + responseBean);

            }else {

                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.MB_UPDATE_BENEFICIARIES_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = MBupdateInstructionV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);

            }
        } catch (Exception e) {

            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBupdateInstructionV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);

        }

        if (log != null) {
             //insert log;
            logList.add(log);
            
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
    
    public static Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> updateIVRbeneficiary(String beneficiaryName,String trgAccNumber,String trgAccType, 
                                                                     String trgBranchCode,String ivrCustNo, String cif, String srcAcc,String tieb,String instrNo, String srcAccType,String srcStmtRef, String trgStmtRef) {

        Sys_Log_Integration__c log;

        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        MBupdateInstructionV1_Resp_IB_v1 responseBean;
        Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();

        Integration_API__c integrationSettings;

        try {

            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_UPDATE_BENEFICIARIES_V1);

            if (integrationSettings != null) {

                MBupdateInstructionV1_Req_IB_v1 requestBean = MBupdateInstructionV1_IU_v1.mapRequestFieldsIVR(beneficiaryName,trgAccNumber,trgAccType,trgBranchCode,ivrCustNo,cif,srcAcc,tieb,instrNo,srcAccType,srcStmtRef, trgStmtRef);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('MBupdateInstructionV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                insert log;

                responseBean = MBupdateInstructionV1_IU_v1.mapResponseFields(response);

                System.debug('MBupdateInstructionV1 Response Bean: ' + responseBean);

            }else {

                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.MB_UPDATE_BENEFICIARIES_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = MBupdateInstructionV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);

            }
        } catch (Exception e) {

            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBupdateInstructionV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);

        }

        if (log != null) {
             //insert log;
            logList.add(log);
            
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }

}