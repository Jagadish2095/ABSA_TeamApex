/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 2021-06-23
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log 
 * Ver   Date         Author                               Modification
 * 1.0   04-11-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
**/
public class RiskProfileJointClient_IH_v1
{
 /**
* @description Method riskProfileJntClient joint related parties,
* @param accountP
* @param relatedPartyListP
* @param productCodeListP
* @param subProductCodeListP
* @param countriesListP
* @param userIdP
* @param sbu
* @return RiskProfileJointClient_Resp_IB_v1 - list accounts with CASA fields
*/
    public static RiskProfileJointClient_Resp_IB_v1 riskProfileJntClient(Account accountP, List<Account> relatedPartyListP, List<String> productCodeListP, List<String> subProductCodeListP, List<String> countriesListP, String userIdP, String sbu)
    {
        return riskProfileJntClient(accountP, relatedPartyListP, productCodeListP, subProductCodeListP, countriesListP, userIdP, true, sbu);
    }
/**
* @description Method thatroskprofiles joint related parties,
* @param accountP
* @param relatedPartyListP
* @param productCodeListP
* @param subProductCodeListP
* @param countriesListP
* @param userIdP
* @param insertLogsP
* @param sbu
* @return RiskProfileJointClient_Resp_IB_v1 - list accounts with CASA fields
*/
public static RiskProfileJointClient_Resp_IB_v1 riskProfileJntClient(Account accountP, List<Account> relatedPartyListP, List<String> productCodeListP, List<String> subProductCodeListP, List<String> countriesListP, String userIdP, Boolean insertLogsP, String sbu){
        
        RiskProfileJointClient_Resp_IB_v1 responseBean;
        Sys_Log_Integration__c log;
        
        try{
            
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.RISK_PROFILE_JOINT_CLIENT);
            List<General_Virtual_Advisor_Rules__mdt> metaDataList = Sys_Utilities_Metadata.getGeneralVirtualAdvisorRuleMetadata();
            
            if(integrationSettings != null && metaDataList.size() > 0){
                
                //Map Fields
                RiskProfileJointClient_Req_IB_v1 requestBean = RiskProfileJointClient_IU_v1.mapRequestFields(accountP, relatedPartyListP, metaDataList, productCodeListP, subProductCodeListP, countriesListP, userIdP, '1', '1', '1', sbu);
                
                if(String.isBlank(requestBean.errorMessage)){
                    
                    String jsonString = requestBean.serialize(requestBean);
                    HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                    
                    //Send Request
                    log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_RISK_PROFILE_JNT_CLIENT, StringConstants.SALESFORCE_STRING, StringConstants.ECASA_STRING);
                    
                    HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                    //Map Response
                    responseBean = RiskProfileJointClient_IU_v1.mapResponseFields(response);
                    
                    if(response.getStatusCode() == 200){
                        //populate log;
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                    }else{
                        //populate log;
                        log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                    }
                }else{
                    System.debug('Request Bean Error: ' + requestBean.errorMessage);
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_RISK_PROFILE_JNT_CLIENT, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, requestBean.errorMessage);
                    responseBean = RiskProfileJointClient_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, requestBean.errorMessage);
                }
            }else{
                //No Integration Settings/Metadata Found
                String message = '';
                message += integrationSettings == null ? StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.RISK_PROFILE_JOINT_CLIENT + '. Environment: ' + Sys_Utilities_General.getEnvironment() + '. ' : '';
                message += metaDataList.size() == 0 ? StringConstants.ERROR_MSG_NO_GENERAL_ADVISOR_MDT_FOUND : '';
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_RISK_PROFILE_JNT_CLIENT, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = RiskProfileJointClient_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
                System.debug('Error: ' + message);
            }
        }catch(Exception e){
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_RISK_PROFILE_JNT_CLIENT, StringConstants.ECASA_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = RiskProfileJointClient_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
        }
        if(log != null && insertLogsP){
            insert log;
        }
        
        return responseBean;
    }
   /**
* @description Method that get Entity Casa status by refernce number,
* @param requestBean -for relatedparty* 
* @return riskProfilejointrelatedParty - list accounts with CASA fields
*/

     public static RiskProfileJointClient_Resp_IB_v1 riskProfilejointrelatedParty(RiskProfileJointClient_Req_IB_v2 requestBean) { 

        RiskProfileJointClient_Resp_IB_v1 responseBean = (RiskProfileJointClient_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, StringConstants.RISK_PROFILE_JOINT_CLIENTV2, RiskProfileJointClient_Resp_IB_v1.class);
           return responseBean;

    }
}