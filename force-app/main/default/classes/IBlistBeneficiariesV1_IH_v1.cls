/*
 * Integration Handler for IBlistBeneficiariesV1 Service
 * @author Rudolf Niehaus
 * @created 2020-03-19
 */

public class IBlistBeneficiariesV1_IH_v1 {

    public static Map<IBlistBeneficiariesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> IBlistBeneficiariesV1(String accountNumber, String branch, String subBranch, String siteType,
                                                                                                            String teller, String manager, String supervisor) {

        Sys_Log_Integration__c log;

        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        IBlistBeneficiariesV1_Resp_IB_v1 responseBean;
        Map<IBlistBeneficiariesV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<IBlistBeneficiariesV1_Resp_IB_v1, List<Sys_Log_Integration__c>>();

        Integration_API__c integrationSettings;

        try {

            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.JITTERBIT_API_RB_STRING, Sys_Utilities_General.getEnvironment(), StringConstants.IB_GET_BENEFICIARY_V1);

            // System.debug(StringConstants.JITTERBIT_API_RB_STRING);
            // System.debug(StringConstants.IB_GET_BENEFICIARY_V1);
            // System.debug(integrationSettings);


            if (integrationSettings != null) {

                IBlistBeneficiariesV1_Req_IB_v1 requestBean = IBlistBeneficiariesV1_IU_v1.mapRequestFields(accountNumber, branch, subBranch, siteType, teller, manager, supervisor);

                String jsonString = JSON.serialize(requestBean, true);

                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);

                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_IB_GET_BENEFICIARY_V1, StringConstants.SALESFORCE_STRING, request.getEndpoint());

                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);

                system.debug('IBlistBeneficiariesV1 Response: ' + response);

                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());

                // insert log; // PJAIN: 20201112: Commented out and added below

                responseBean = IBlistBeneficiariesV1_IU_v1.mapResponseFields(response);

                System.debug('IBlistBeneficiariesV1 Response Bean: ' + responseBean);

            }else {

                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.JITTERBIT_API_RB_STRING + '. Service: ' + StringConstants.IB_GET_BENEFICIARY_V1 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = IBlistBeneficiariesV1_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_IB_GET_BENEFICIARY_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);

            }
        } catch (Exception e) {

            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = IBlistBeneficiariesV1_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_IB_GET_BENEFICIARY_V1, StringConstants.IBGETBENEFICIARYV1_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);

        }

        if (log != null) {
            logList.add(log);
            // PJAIN: 20201112: Insert log using this method rather than DML
            SystemLogger.insertLog(log);
        }

        responseMap.put(responseBean, logList);
        return responseMap;
    }
}