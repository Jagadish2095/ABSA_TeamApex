/*
* Version 6 of Casa Screening
* Integration Handler for CASAScreenRelatedParty Service
* @author Pitso Sekhu
* @created 2019-03-13
*/

public class CASAScreenRelatedParty_IH_v2 
{
   
    public static CASAScreenRelatedParty_Resp_IB_v2 screenRelatedParty(String channel, String application, 
    String trace, String firstName, String surnameComp, String idType, String idRegNo, String clientTypeGrp, 
    String dob, String nationality, String town, String cntryOfRes, String cntryOfBirth, String primaryClientRef, 
    String relationship, String branch, String teller, String originatingSys)
    {        
        Sys_Log_Integration__c log;
        CASAScreenRelatedParty_Resp_IB_v2 screenRelatedPartyRespBean;
           
        try
        {           
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CASA_SCREEN_RELATED_PARTY_V6);
            
            if(integrationSettings != null)
            {
                CASAScreenRelatedParty_Req_IB_v2 screenRelatedPartyRequest = CASAScreenRelatedParty_IU_v2.mapRequestFields(channel, application, 
    					trace, firstName, surnameComp, idType, idRegNo, clientTypeGrp, 
    					dob, nationality, town, cntryOfRes, cntryOfBirth, primaryClientRef, 
    					relationship, branch, teller, originatingSys);
                
                String jsonString = screenRelatedPartyRequest.serialize(screenRelatedPartyRequest);
               	System.debug(jsonString);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);
                              
                log = SystemLogger.createRequestIntegrationLog(request.getbody(), StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY_V6, StringConstants.SALESFORCE_STRING, request.getEndpoint());
          
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v2.mapResponseFields(response);
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CASA_SCREEN_RELATED_PARTY_V6 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v2.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY_V6, StringConstants.CASASCREENRELATEDPARTY_V6_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY_V6, StringConstants.CASASCREENRELATEDPARTY_V6_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        if(log != null)
        {
            insert log;
        }
         
        return screenRelatedPartyRespBean;
    }
    
    
    
    //Bean to Log Map Method for related party screening
    public static Map<CASAScreenRelatedParty_Resp_IB_v2, Sys_Log_Integration__c> screenRelatedPartyMap(Account accountP, String countryOfResP, String countryOfBirthP, String nationalityP, String iDTypeAccountP, User userP, String primaryClientRefP, String countryPassportP)
    {        
        Sys_Log_Integration__c log;
        CASAScreenRelatedParty_Resp_IB_v2 screenRelatedPartyRespBean;
        Map<CASAScreenRelatedParty_Resp_IB_v2, Sys_Log_Integration__c> beanToLogMap = new Map<CASAScreenRelatedParty_Resp_IB_v2, Sys_Log_Integration__c>();
        
        try
        {           
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CASA_SCREEN_RELATED_PARTY_V6);
            
            if(integrationSettings != null)
            {
                CASAScreenRelatedParty_Req_IB_v2 screenRelatedPartyRequest = CASAScreenRelatedParty_IU_v2.mapRequestJntAccountFields(accountP, countryOfResP, countryOfBirthP, nationalityP, iDTypeAccountP, userP, primaryClientRefP, countryPassportP);
                
                String jsonString = screenRelatedPartyRequest.serialize(screenRelatedPartyRequest);
                System.debug(jsonString);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);
                
                log = SystemLogger.createRequestIntegrationLog(request.getbody(), StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY_V6, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v2.mapResponseFields(response);
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CASA_SCREEN_RELATED_PARTY_V6 + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v2.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY_V6, StringConstants.CASASCREENRELATEDPARTY_V6_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v2.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY_V6, StringConstants.CASASCREENRELATEDPARTY_V6_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        beanToLogMap.put(screenRelatedPartyRespBean, log);
        
        return beanToLogMap;
    }
}