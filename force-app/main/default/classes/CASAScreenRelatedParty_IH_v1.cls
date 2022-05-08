/*
* Version 7 of Casa Screening
* Integration Handler for Create Tracker Entry Compliance
* @author Tshego Lesejane
* @created 2019-02-20
*/
public class CASAScreenRelatedParty_IH_v1 
{

    
    //Bean to Log Map Method for related party screening
    public static Map<CASAScreenRelatedParty_Resp_IB_v1, Sys_Log_Integration__c> screenRelatedPartyMap(Account accountP, String countryOfResP, String countryOfBirthP, String nationalityP, String iDTypeAccountP, User userP, 
                                                                                                       String primaryClientRefP, String countryOfPassportP, String channelP, String sbuP, String branchP, String relationshipP, String clientTypeP){        
        
        Sys_Log_Integration__c log;
        CASAScreenRelatedParty_Resp_IB_v1 screenRelatedPartyRespBean;
        Map<CASAScreenRelatedParty_Resp_IB_v1, Sys_Log_Integration__c> beanToLogMap = new Map<CASAScreenRelatedParty_Resp_IB_v1, Sys_Log_Integration__c>();
        
        try{
            
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CASA_SCREEN_RELATED_PARTY);
            
            if(integrationSettings != null){
                
                CASAScreenRelatedParty_Req_IB_v1 screenRelatedPartyRequest = CASAScreenRelatedParty_IU_v1.mapRequestJntAccountFields(accountP, countryOfResP, countryOfBirthP, nationalityP, iDTypeAccountP, userP, primaryClientRefP, countryOfPassportP, channelP, sbuP, branchP, relationshipP, clientTypeP);
                
                String jsonString = screenRelatedPartyRequest.serialize(screenRelatedPartyRequest);
                System.debug(jsonString);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);
                
                log = SystemLogger.createRequestIntegrationLog(request.getbody(), StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v1.mapResponseFields(response);
                //Translate response values and return the translated bean
                screenRelatedPartyRespBean = translateToInternalValues(screenRelatedPartyRespBean);
                
            }else{
                
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CASA_SCREEN_RELATED_PARTY + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY, StringConstants.CASASCREENRELATEDPARTY_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }catch(Exception e){
            
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY, StringConstants.CASASCREENRELATEDPARTY_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        beanToLogMap.put(screenRelatedPartyRespBean, log);
        
        return beanToLogMap;
    }
    
    public static CASAScreenRelatedParty_Resp_IB_v1 translateToInternalValues(CASAScreenRelatedParty_Resp_IB_v1  screeningRepBeanP){

        String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, 'eCasa Status', screeningRepBeanP.respStatus, StringConstants.INBOUND_RECORD_TYPE);
        System.debug('casaStatusTranslated: ' + casaStatusTranslated);
        
        if(casaStatusTranslated != null){
            screeningRepBeanP.respStatus = casaStatusTranslated;
        }
        
        return screeningRepBeanP;
    }
    
}