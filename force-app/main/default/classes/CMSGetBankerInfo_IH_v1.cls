/**
* Description: Class makes callout to the CMS Service to get the Banker detials
* @Author:  Diksha Wasekar:Absa
* @Created Date:  2019-09-07
==================================================================================================
**/

/* 
* Description: This method Makes the callout to CMS service to get Banker deatils
* @param: String - Clientcode
* @return : String - bankerdetails
*/


public class CMSGetBankerInfo_IH_v1 {
    
    public static Map<CMSGetBankerInfo_Resp_IB_v1, List<Sys_Log_Integration__c>> getBankerDeatils(String application, String clientcode) 
    {
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        CMSGetBankerInfo_Resp_IB_v1 responseBean;
        Map<CMSGetBankerInfo_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = new Map<CMSGetBankerInfo_Resp_IB_v1, List<Sys_Log_Integration__c>>();
        Integration_API__c integrationSettings;
        
        try
        {           
            integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CMS_GET_ACCOUNTDEATILS);
            
            if(integrationSettings != null)
            {
                CMSGetBankerInfo_Req_IB_V1 requestBean = CMSGetBankerInfo_IU_v1.mapFieldscmsBankerInfoRequest(application, clientcode);
                
                String jsonString = JSON.serialize(requestBean, true);
                
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],jsonString);
                
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CMS_GET_BANKERINFO, StringConstants.SALESFORCE_STRING, request.getEndpoint());
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                
                responseBean = CMSGetBankerInfo_IU_v1.mapResponseFields(response);
                
            }
            else
            {
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CMS_GET_ACCOUNTDEATILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                responseBean = CMSGetBankerInfo_IU_v1.mapFailedResponseFields(500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CMS_GET_BANKERINFO, StringConstants.CMS_Get_AccountDeatils_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                System.debug(message);
            }
        }
        catch(Exception e)
        {
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            responseBean = CMSGetBankerInfo_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CMS_GET_BANKERINFO, StringConstants.CMS_Get_AccountDeatils_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            System.debug(message);
        }
        
        if(log != null)
        {
            logList.add(log);
        }
        
        responseMap.put(responseBean, logList);
        return responseMap;
    }
    
}