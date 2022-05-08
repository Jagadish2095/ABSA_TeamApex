/**
* @description Version 7 of Casa Screening
* Integration Handler for Onboarding CASAScreeningRelatedParties
* @author Anka Ganta
* @created 2019-12-20 
*/

public with sharing class CASAScreenRelatedParty_IH_v3 
{

    /**
    * @description Bean to Log Map Method for related party screening
    * @author ChangeMeIn@UserSettingsUnder.SFDoc | 2021-10-19 
    * @param accountP 
    * @param primaryClientRef 
    * @param integrationCasaRelatedPartySettings 
    * @return Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> 
    **/
    public static Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> screenRelatedPartyMapBusinessAcc(Account accountP,String primaryClientRef,  Integration_API__c integrationCasaRelatedPartySettings){ 

        Sys_Log_Integration__c log;
        CASAScreenRelatedParty_Resp_IB_v3 screenRelatedPartyRespBean;
        Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> beanToLogMap = new Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c>();
        try{
            Integration_API__c integrationSettings = integrationCasaRelatedPartySettings;
            if(integrationSettings != null){
                CASAScreenRelatedParty_Req_IB_v3 screenRelatedPartyRequest = CASAScreenRelatedParty_IU_v3.mapRequestJntAccountFieldsBusiness(accountP,primaryClientRef);
                String jsonString = screenRelatedPartyRequest.serialize(screenRelatedPartyRequest);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);
                log = SystemLogger.createRequestIntegrationLog(request.getbody(), StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
              log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v3.mapResponseFields(response);
                //Translate response values and return the translated bean
                screenRelatedPartyRespBean = translateToInternalValues(screenRelatedPartyRespBean);
                beanToLogMap.put(screenRelatedPartyRespBean, log);
            }else{
                
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CASA_SCREEN_RELATED_PARTY + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v3.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY, StringConstants.CASASCREENRELATEDPARTY_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
               
            }
        }catch(Exception e){
            
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v3.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY, StringConstants.CASASCREENRELATEDPARTY_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            beanToLogMap.put(screenRelatedPartyRespBean, log);
            
        }
        
        return beanToLogMap;
    }
    
/**
* @description screenTradingAsNamesMapBusinessAcc
* @return CASAScreenRelatedParty_Resp_IB_v3
* @param tradingNameRec
* @param primaryClientRef
* @param integrationCasaRelatedPartySettings
* @return Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c>
*/ 
    public static Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> screenTradingAsNamesMapBusinessAcc(Trading_as_Name__c tradingNameRec,String primaryClientRef,Integration_API__c integrationCasaRelatedPartySettings){ 

        Sys_Log_Integration__c log;
        CASAScreenRelatedParty_Resp_IB_v3 screenRelatedPartyRespBean;
        Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c> beanToLogMap = new Map<CASAScreenRelatedParty_Resp_IB_v3, Sys_Log_Integration__c>();
        try{
            Integration_API__c integrationSettings = integrationCasaRelatedPartySettings;
               if(integrationSettings != null){

                CASAScreenRelatedParty_Req_IB_v3 screenRelatedPartyRequest = CASAScreenRelatedParty_IU_v3.mapRequestTradingAsName(tradingNameRec,primaryClientRef);
                String jsonString = screenRelatedPartyRequest.serialize(screenRelatedPartyRequest); 
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);
                 log = SystemLogger.createRequestIntegrationLog(request.getbody(), StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v3.mapResponseFields(response);
                //Translate response values and return the translated bean
                screenRelatedPartyRespBean = translateToInternalValues(screenRelatedPartyRespBean);
                beanToLogMap.put(screenRelatedPartyRespBean, log);

            }else{
                
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CASA_SCREEN_RELATED_PARTY + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v3.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY, StringConstants.CASASCREENRELATEDPARTY_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
               
            }
        }catch(Exception e){
            
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            screenRelatedPartyRespBean = CASAScreenRelatedParty_IU_v3.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CASA_SCREEN_RELATED_PARTY, StringConstants.CASASCREENRELATEDPARTY_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            beanToLogMap.put(screenRelatedPartyRespBean, log);
        }
        
        return beanToLogMap;
    }
    

    /**
    * @description casaScreenRelatedClientV7
    * @param screeningRepBeanP
    * @return CASAScreenRelatedParty_Resp_IB_v3
    */
    public static CASAScreenRelatedParty_Resp_IB_v3 translateToInternalValues(CASAScreenRelatedParty_Resp_IB_v3  screeningRepBeanP){
        
        String casaStatusTranslated = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(StringConstants.ECASA_STRING, StringConstants.ECASA_STRING_REF, screeningRepBeanP.respStatus, StringConstants.INBOUND_RECORD_TYPE);
        
        if(casaStatusTranslated != null){
            screeningRepBeanP.respStatus = casaStatusTranslated;
        }
        
        return screeningRepBeanP;
    }

    /**
    * @description casaScreenRelatedClientV7
    * @param requestBean
    * @return CASAScreenRelatedParty_Resp_IB_v3
    */
    public static CASAScreenRelatedParty_Resp_IB_v3 casaScreenRelatedClientV7(CASAScreenRelatedParty_Req_IB_v3 requestBean) { 
        CASAScreenRelatedParty_Resp_IB_v3 responseBean = (CASAScreenRelatedParty_Resp_IB_v3) Sys_Utilities_Integration.integrationServiceCall(requestBean, StringConstants.CASA_SCREEN_RELATED_PARTY_V7, CASAScreenRelatedParty_Resp_IB_v3.class);
        return responseBean;
    }

}