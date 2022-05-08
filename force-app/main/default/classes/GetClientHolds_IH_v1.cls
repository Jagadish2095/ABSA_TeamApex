/*US:W-002572
*Description:Web Service to get Client Holds From CIF For Client Hold Indicator
* @author  Almas Aleem : Absa
* @version v1.0
* @since   2019-07-31
* @updated 2019-09-07
*/
public class GetClientHolds_IH_v1 {
/* 
* Description: This method Makes the callout to CIF System to get client holds
* @param: String - accountCifNumber
* @return : String - holdList
*/
    public static GetClientHolds_Resp_IB_v1 getClientHolds(String CIFNumber){
        String clientHoldList = '';
        GetClientHolds_Resp_IB_v1 clientHoldResponse;
        Sys_Log_Integration__c log;
        try{ 
          //Fetch Integeration Service Record
                Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), 
                                                                                                          StringConstants.GET_CLIENT_HOLDS);
            if(integrationSettings != null){
                 //set request
                   GetClientHolds_Req_IB_v1 clientHoldrequest = GetClientHolds_IU_v1.mapRequestFields(CIFNumber);   
                  
                 String jsonString = clientHoldrequest.serialize( clientHoldrequest );
                String jsonStringOverride =  jsonString.replace('override_Z', 'override');//override string as varaible name override can't be define
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCallout(Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonStringOverride));
               
                
                //get response and map to response bean
                if(response.getStatusCode() == 200){
                     String message = StringConstants.INTEGRATION_STATUS_SUCCESS+ 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_CLIENT_DETAILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                     clientHoldResponse = GetClientHolds_IU_v1.mapResponseFields(response); 
                    log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CLIENT_HOLDS, StringConstants.CIF_STRING, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, message);
                
     
                }else{
                  String message = StringConstants.ERROR_MSG_UNEXPECTED_STATUS_CODE + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_CLIENT_DETAILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                 log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CLIENT_HOLDS, StringConstants.CIF_STRING, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, message);
             	  
                }
            }else{
                
                   //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.GET_CLIENT_DETAILS + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CLIENT_HOLDS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                
            }
           
        }catch(Exception e){
            system.debug(+e.getLineNumber()+'--'+e.getCause()+'--'+e.getMessage());
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_GET_CLIENT_HOLDS, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
         
			throw new AuraHandledException('Error in service callout:'+message);      
   
        }
        if(log !=null){
            insert log;
        }
        
        return clientHoldresponse;
    }
}