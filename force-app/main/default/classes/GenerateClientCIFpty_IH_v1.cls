/*
* Handler class for generating client CIF 
*
* @author  Haritha Police : Absa
* @version v1.0
* @since   2019-11-28
*
*/
public class GenerateClientCIFpty_IH_v1 {

     public static map<GenerateClientCIFpty_Resp_IB_v1,List<Sys_Log_Integration__c>> createClient(Account accountP, string userP, String recordTypeP){
        
        map<GenerateClientCIFpty_Resp_IB_v1,List<Sys_Log_Integration__c>> responseMap = new map<GenerateClientCIFpty_Resp_IB_v1,List<Sys_Log_Integration__c>>();
        GenerateClientCIFpty_Resp_IB_v1 responseBean;
        Sys_Log_Integration__c log;
         List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
        // Map<String, String> translationMapP;
         Map<String, String> translationMapP = getTranslations(accountP);
         List<User>  userList =new List<User>  ();
           if(userP!=null){
              userList = new UsersSelector().selectById(new Set<Id>{userP});
           }
        try{
            //Query Objects
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.CREATE_CLIENT_CIF);
            
            if(integrationSettings != null){
                //Map Fields
                GenerateClientCIFpty_Req_IB_v1 requestBean; 
              if(recordTypeP == 'Business Prospect'){
                  system.debug('entereddd'+userList[0]);
                  system.debug('translationMapP'+translationMapP);
                  system.debug('accountP'+accountP);
                    requestBean = GenerateClientCIFpty_IU_v1.mapBusinessClientRequestFieldsforpty(accountP, userList[0], translationMapP);
                  
                }
                String jsonString = requestBean.serialize(requestBean);
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings, integrationSettings.Integration_Services__r[0], jsonString);
                //Send Request
                log = SystemLogger.createRequestIntegrationLog(request.getBody(), StringConstants.METHOD_CREATE_CLIENT_CIF + recordTypeP, StringConstants.SALESFORCE_STRING, StringConstants.CIF_STRING);
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                //Map Response
                responseBean = GenerateClientCIFpty_IU_v1.mapResponseFields(response);
                if(response.getStatusCode() == 200){
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, response.getBody());
                }else{
                    //populate log;
                    log = SystemLogger.mapResponseFields(log, response.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, response.getBody());
                }
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.CREATE_CLIENT_CIF + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_CLIENT_CIF, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
                responseBean = GenerateClientCIFpty_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
                
            }
        }catch(Exception e){
            System.debug(e.getMessage() + '. ' + e.getStackTraceString());
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_CLIENT_CIF, StringConstants.CIF_STRING, 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            responseBean = GenerateClientCIFpty_IU_v1.mapFailedResponseFields(StringConstants.STATUS_CODE_500, 500, message);
        }
         System.debug('=====log======>'+log);
          if (log != null) {
            logList.add(log);
        }
        responseMap.put(responseBean, logList);
        return responseMap;
    }
    
        public static Map<String, String> getTranslations(Account accountP){
        
        Map<String, String> tanslationValueMap = new Map<String, String>();
        String message = '';
         String clientTypeTranslated = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(StringConstants.CIF_STRING, 'Client Type', accountP.Client_Type__c, StringConstants.OUTBOUND_RECORD_TYPE);
		 tanslationValueMap.put('clientTypeTranslated', clientTypeTranslated);
        if(message != ''){
            tanslationValueMap.put('ERROR', message);
            
        }
        System.debug('tanslationValueMap: ' + tanslationValueMap);
        return tanslationValueMap;

        }
  }