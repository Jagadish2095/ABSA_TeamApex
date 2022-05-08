/**
* Integration Handler for Regulatory Service Involved Parties
* @author Himanshu Nimje
* @created 2018-11-15
* @updated Danie Booysen
* @updated 2018-02-07
*/

public class RegSer_InvolvedParties_IH_v1 {
    
    public static RegSer_InvolvedParties_Resp_IB_v1 getInvolvedParties(String queryTypeP, String regIdP){
        return getInvolvedParties(queryTypeP, regIdP, true);
    }
    
    public static RegSer_InvolvedParties_Resp_IB_v1 getInvolvedParties(String queryTypeP, String regIdP, Boolean insertLogsP){
        
        //Call getAnalystCommentsMap
        Map<RegSer_InvolvedParties_Resp_IB_v1, Sys_Log_Integration__c> responseMap = getInvolvedPartiesMap(queryTypeP, regIdP);
        
        //Check for logs and insert if specified 
        if(responseMap.values().size() > 0){
            
            if(responseMap.values()[0] != null && insertLogsP){
                //Insert Logs
                insert responseMap.values()[0];
            }
        }
        //Get Response Bean from Map
        List<RegSer_InvolvedParties_Resp_IB_v1> responseList = new List<RegSer_InvolvedParties_Resp_IB_v1>(responseMap.keySet());
        
        return responseList[0];
    }
    
    public static Map<RegSer_InvolvedParties_Resp_IB_v1, Sys_Log_Integration__c> getInvolvedPartiesMap(String queryTypeP, String regIdP){
        
        /* queryTypeP: Type of query, valids ones are: cif, passport, identityDocument and suid
** regIdP: Registration number, ID number, passport number etc depending on the query type       
*/   
        System.debug('queryTypeP: ' + queryTypeP);
        System.debug('regIdP: ' + regIdP);
        Sys_Log_Integration__c log;
        RegSer_InvolvedParties_Resp_IB_v1 regSerInvolvedPartiesRespBean;  
        Map<RegSer_InvolvedParties_Resp_IB_v1, Sys_Log_Integration__c> responseMap = new Map<RegSer_InvolvedParties_Resp_IB_v1, Sys_Log_Integration__c>();
        
        try{  
            Integration_API__c integrationSettings = Sys_Utilities_Integration.getIntegrationSettings(StringConstants.API_MANAGER, Sys_Utilities_General.getEnvironment(), StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES);
            system.debug('integrationSettings ## '+integrationSettings);
            
            //Check if Metadata was found
            if(integrationSettings != null){
                HttpRequest request = Sys_Utilities_Integration.mapHttpRequest(integrationSettings,integrationSettings.Integration_Services__r[0],'');
				request.setHeader(StringConstants.INVOLVED_PARTY_VERSION,'1');
                request.setHeader(StringConstants.INVOLVED_PARTY_ID_TYPE,queryTypeP);
                request.setHeader(StringConstants.INVOLVED_PARTY_ID,EncodingUtil.urlEncode(regIdP, 'UTF-8'));
                
                system.debug('UnEncoded: '+ regIdP);
                system.debug('Url Encode: '+ EncodingUtil.urlEncode(regIdP, 'UTF-8'));
                
                system.debug('HttpRequest:request ## '+ request);
                
                
                String requestInfo = 'Query Type: ' + queryTypeP + '. Reg Id: ' + regIdP;
                log = SystemLogger.createRequestIntegrationLog(requestInfo, StringConstants.METHOD_REG_SER_INVOLVED_PARTIES, StringConstants.SALESFORCE_STRING, request.getEndpoint()); 
                
                //Send Request
                HttpResponse response = Sys_Utilities_Integration.serviceCalloutWithoutLogging(request);
                
                log = SystemLogger.mapResponseFields(log, response.getStatusCode(), response.getStatus(), response.getBody());
                system.debug('response' +response);
                
                if(response.getStatusCode() == 200){
                    
                    regSerInvolvedPartiesRespBean = RegSer_InvolvedParties_IU_v1.mapResponseFields(response);
                    
                }else{
                    
                    regSerInvolvedPartiesRespBean = RegSer_InvolvedParties_IU_v1.mapFailedResponseFields(response.getStatusCode(), response.getStatus(), response.getBody());
                    
                }
                
            }else{
                //No Integration Settings Found
                String message = StringConstants.ERROR_MSG_NO_INTEGRATION_SETTINGS_FOUND + 'API: ' + StringConstants.API_MANAGER + '. Service: ' +  StringConstants.REGULATORY_SERVICE_INVOLVED_PARTIES + '. Environment: ' + Sys_Utilities_General.getEnvironment();
                regSerInvolvedPartiesRespBean = RegSer_InvolvedParties_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
                log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_REG_SER_INVOLVED_PARTIES, 'Involved Parties', 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
            }
            
        }catch(Exception e){
            //Exception
            String message = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(message);
            regSerInvolvedPartiesRespBean = RegSer_InvolvedParties_IU_v1.mapFailedResponseFields(500, StringConstants.STATUS_CODE_500, message);
            log = SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_REG_SER_INVOLVED_PARTIES, 'Involved Parties', 500, StringConstants.INTEGRATION_STATUS_FAILED, message);
        }
        responseMap.put(regSerInvolvedPartiesRespBean, log);
        
        return responseMap;
    }        
}