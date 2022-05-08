/*
 * Integration Handler for MBupdateInstructionV1 Service
 * @author Rudolf Niehaus
 * @created 2020-05-16
 */

public class MBSupdateInstructionV1_IH_v1 {

    public static Map<MBSupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> MBupdateInstructionV1(String cif, String instrNo, String beneficiaryName, 
                                                                                                            String trigDate, String endDate, String payDay, String freq, String amount,
                                                                                                            String srcAccNumber,String srcAccType, String srcBranchCode, String srcRef, 
                                                                                                            String trgAccNumber,String trgAccType, String trgBranchCode,String trgRef,
                                                                                                            String siteCode, String teller) {

        Sys_Log_Integration__c log;

        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        MBSupdateInstructionV1_Resp_IB_v1 responseBean;
        Map<MBSupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<MBSupdateInstructionV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();

        Integration_API__c integrationSettings;

        try {

            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.MB_UPDATE_BENEFICIARIES_V1);

            if (integrationSettings != null) {

                MBSupdateInstructionV1_Req_IB_v1 requestBean = MBSupdateInstructionV1_IU_v1.mapRequestFields(cif, instrNo, beneficiaryName, trigDate,  endDate,  payDay,  freq,  amount,
                                                                                                            srcAccNumber, srcAccType,  srcBranchCode,  srcRef, trgAccNumber, trgAccType,  trgBranchCode, trgRef,
                                                                                                            siteCode,  teller);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('MBupdateInstructionV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                insert log;

                responseBean = MBSupdateInstructionV1_IU_v1.mapResponseFields(response);

                System.debug('MBupdateInstructionV1 Response Bean: ' + responseBean);

            }else {

                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.MB_UPDATE_BENEFICIARIES_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = MBSupdateInstructionV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);

            }
        } catch (Exception e) {

            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = MBSupdateInstructionV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_MB_UPDATE_BENEFICIARIES_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);

        }

        if (log != null) {
            logList.add(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
}