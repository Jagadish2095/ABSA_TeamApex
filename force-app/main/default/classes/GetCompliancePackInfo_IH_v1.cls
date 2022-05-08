/**
 * @description       : Integration Handler for Compliance Pack Service
 * @author            : Sharath
 * @last modified on  : 05-25-2021
 * @last modified by  : Sandeep Golla
 * Modifications Log
 * Ver   Date         Author          Modification
 * 1.0   05-25-2021   Sharath         Initial Version
**/

public class GetCompliancePackInfo_IH_v1 {

    /**
    * @description Action method which synchronously calls the Compliance Pack Service
    * @param accToReq
    * @return GetCompliancePackInfo_Resp_Parse
    **/
    public static GetCompliancePackInfo_Resp_Parse getComplianceInfo(Account accToReq)
    {
        Sys_Log_Integration__c log;
        GetCompliancePackInfo_Resp_Parse complianceRespBean;
        string APIName = 'Jitterbit2';
        string serviceName = 'Compliance Pack';
        try{
            //To get integration settings of compliance pack service for UAT env
            system.debug('/* In getComplianceInfo Method');
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(APIName, Sys_Utilities_General.getEnvironment(), serviceName);
            system.debug('/* The Integration Objects are : ' +integrationSettings);
            if(integrationSettings != null){
                String jsonString = GetCompliancePackInfo_IU_v1.mapRequestFields(accToReq);
                system.debug('/* The Payload is: ' + jsonString);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0], jsonString);
                request.setTimeout(60000);
                system.debug('/* The Request is: ' +request);
               	log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_REGULATORY_COMPLIANCE_GET_INFO, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                //Sending Request to the service
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                if(response.getStatusCode() == 200){ //Exception handling for different status code by mohammed Junaid U
                    complianceRespBean = GetCompliancePackInfo_IU_v1.mapResponseFields(response);}
                else{
                    ComplianceRespBean = GetCompliancePackInfo_IU_v1.mapFailedResponseFields(response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                }
            }
            else{
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.REGULATORY_SERVICE_COMPLIANCE_INFO + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                ComplianceRespBean = GetCompliancePackInfo_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_REGULATORY_COMPLIANCE_GET_INFO, StringConstants.REGULATORYCOMPLIANCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e){
            //Exception Handling
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(e.getMessage());
            complianceRespBean = GetCompliancePackInfo_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_REGULATORY_COMPLIANCE_GET_INFO, StringConstants.REGULATORYCOMPLIANCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        if(log != null){
            insert log;
        }
        return complianceRespBean;
    }
}