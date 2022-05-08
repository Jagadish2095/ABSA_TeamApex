/**
 * @description       : Integration Handler for Document Classification Service
 * @author            : Sandeep
 * @since             : 06-10-2021
 *
**/
public with sharing class DocuClassifyInfo_IH_v1 {

    /**
    * @description	: Action method which synchronously calls the Document Classification Service
    * @param		 filname 
    * @param		 docpass
    * @return		: DocuClassInfo_Resp_Parse
    **/
    public static DocuClassInfo_Resp_Parse getDocuInfo(string filname, string docpass){
        Sys_Log_Integration__c log;
        DocuClassInfo_Resp_Parse docuinoRespBean;
        string aPIName = 'Jitterbit2';
        string serviceName = 'Document Classification';
        try{
            //To get integration settings of compliance pack service for UAT env
            system.debug('/* In getDocuInfo Method');
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(APIName, Sys_Utilities_General.getEnvironment(), serviceName);
            system.debug('/* The Integration Objects are : ' +integrationSettings);
            if(integrationSettings != null){
                String jsonString = DocuClassificationInfo_IU_v1.mapRequestFields(filname,docpass);
                system.debug('/* The Payload is: ' + jsonString);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0], jsonString);
                request.setTimeout(60000);
                system.debug('/* The Request is: ' +request);
               	log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_REGULATORY_COMPLIANCE_GET_INFO, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                //Sending Request to the service
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                docuinoRespBean = DocuClassificationInfo_IU_v1.mapResponseFields(response);
                system.debug('-----Response is  :  '+docuinoRespBean);
            }
            else{
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.REGULATORY_SERVICE_COMPLIANCE_INFO + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                docuinoRespBean = DocuClassificationInfo_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_REGULATORY_COMPLIANCE_GET_INFO, StringConstants.REGULATORYCOMPLIANCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }catch(Exception e){
            //Exception Handling
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(e.getMessage());
            docuinoRespBean = DocuClassificationInfo_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_REGULATORY_COMPLIANCE_GET_INFO, StringConstants.REGULATORYCOMPLIANCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        //if(log != null && Schema.sObjectType.Sys_Log_Integration__c.fields.Name.isCreateable()){
           // insert log;
       // }

        return docuinoRespBean;
    }
}