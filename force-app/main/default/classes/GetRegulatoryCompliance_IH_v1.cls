/*
* Integration Handler for Regulatory Service Regulatory Compliance
* @author Englarmerdge Mongwe
* @created 2018-11-14
*/

public class GetRegulatoryCompliance_IH_v1 
{   
    /* Action method which synchronously calls the Get Regulatory Compliance operation with specified parameters
    ** queryTypeP: Type of query, valids ones are: cif, passport, identityDocument and suid
    ** regIdP: ID number, passport number etc depending on the query type
	*/    
    public static GetRegulatoryCompliance_Resp_IB_v1 getRegulatoryComplianceInfo(String queryTypeP, String regIdP)
    {        
        Sys_Log_Integration__c log;
        GetRegulatoryCompliance_Resp_IB_v1 regulatoryComplianceRespBean;
           
        try
        {     
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.REGULATORY_SERVICE_COMPLIANCE_INFO);
            
            if(integrationSettings != null)
            {
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],'');
                request.setHeader(StringConstants.INVOLVED_PARTY_ID_TYPE,queryTypeP);
                request.setHeader(StringConstants.INVOLVED_PARTY_ID,EncodingUtil.urlEncode(regIdP, 'UTF-8'));
                request.setHeader(StringConstants.COMPLIANCE_VIEW_VERSION,'2');
                
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_REGULATORY_COMPLIANCE_GET_INFO, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                regulatoryComplianceRespBean = GetRegulatoryCompliance_IU_v1.mapResponseFields(response);
                
                System.debug('Get Regulatory Compliance Request Bean: ' + regulatoryComplianceRespBean);
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.REGULATORY_SERVICE_COMPLIANCE_INFO + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                regulatoryComplianceRespBean = GetRegulatoryCompliance_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_REGULATORY_COMPLIANCE_GET_INFO, StringConstants.REGULATORYCOMPLIANCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(e.getMessage());
            regulatoryComplianceRespBean = GetRegulatoryCompliance_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_REGULATORY_COMPLIANCE_GET_INFO, StringConstants.REGULATORYCOMPLIANCE_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        if(log != null)
        {
            insert log;
        }
         
        return regulatoryComplianceRespBean;
    }
}