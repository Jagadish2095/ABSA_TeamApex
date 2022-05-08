/**
* Integration Utilities for use Across All Integrations
* Contains Generic Methods that will be re-used
* @author Danie Booysen and Jason Quevauvilliers
* @created 2018-08-22
*/

public class IntegrationUtilities{
    
    /**
* Method that executes a Service Callout
* @param HTTP Request
* @return List<Opportunity> - returns a list of opportunities
*/
    public static HttpResponse serviceCallout(HttpRequest httpRequest){
        
        Http http = new Http();
        HttpResponse httpResponse;
        
        Sys_Log_Integration__c log = SystemLogger.createRequestIntegrationLog(httpRequest.getBody(), StringConstants.METHOD_INTEGRATION_UTILITIES_SERVICE_CALLOUT, StringConstants.SALESFORCE_STRING, httpRequest.getEndpoint());
        
        System.debug(StringConstants.DEBUG_HTTP_REQUEST_STRING + httpRequest);
        
        try {
            
            httpResponse = http.send(httpRequest);
            System.debug(StringConstants.DEBUG_HTTP_RESPONSE_STRING + httpResponse);
            
            if(httpResponse.getStatusCode() >= 200 && httpResponse.getStatusCode() < 300){
                
                log = SystemLogger.mapResponseFields(log, httpResponse.getStatusCode(), StringConstants.INTEGRATION_STATUS_SUCCESS, httpResponse.getBody());
            }else{
                log = SystemLogger.mapResponseFields(log, httpResponse.getStatusCode(), StringConstants.INTEGRATION_STATUS_FAILED, httpResponse.getBody());
            }
            
        }catch (Exception e){
            
            log = SystemLogger.mapResponseFields(log, 500, StringConstants.INTEGRATION_STATUS_FAILED, e.getMessage() + '. ' + e.getStackTraceString());
        }
        
        insert log;
        return httpResponse;
    }
    
    /**
* Method that translates an internal value to an external value
* @param System Name (Currentlty not used)
* @param Field Name
* @param Internal Value
* @return External Value
*/
    public static String translateToExternalValue(String systemNameP, String fieldNameP, String valueP){
        //Metadata type records for mapping Salesforce values to Siebel.
        List<Integration_Mapping__mdt> integrationMappingValueList = new List<Integration_Mapping__mdt>([
            SELECT
            External_Value__c
            FROM
            Integration_Mapping__mdt
            WHERE
            Salesforce_Value__c =: valueP
            AND
            System_Value_Type__c =: fieldNameP
        ]);
        
        if(integrationMappingValueList.size() == 1){
            return integrationMappingValueList.get(0).External_Value__c;
        }
        return null;
    }
    
    /**
* Method that retreives the current environment
* @return Environment
*/
    public static String getEnvironment(){
        
        List<Organization> salesforceOrg = [SELECT IsSandbox FROM Organization];
        
        if(salesforceOrg.size() == 1){
            
            if(salesforceOrg[0].IsSandbox){
                
                String hostName = String.valueOf(URL.getSalesforceBaseUrl());
                return hostName.contains('uat') ? 'UAT' : 'Development';
            }else{
                
                return 'Production';
            }
        }else if(salesforceOrg.size() == 0){
            
            System.debug(StringConstants.ERROR_MSG_NO_ENVIRONMENT_FOUND);
            return StringConstants.ERROR_MSG_NO_ENVIRONMENT_FOUND;
            
        }else{
            
            System.debug(StringConstants.ERROR_MSG_MULTIPLE_ENVIRONMENTS_FOUND);
            return StringConstants.ERROR_MSG_MULTIPLE_ENVIRONMENTS_FOUND;
        }
    }
    
    public static Integer getSObjectFieldLength(String objP, String fieldNameP){
        //In the future we should store the value in cache so that we dont have to go through all the fields everytime. we would check if it exists in the cache first
        for(Schema.SObjectField s : Schema.getGlobalDescribe().get(objP).getDescribe().Fields.getMap().values()){
            if(s.getDescribe().getName() == fieldNameP){
                return s.getDescribe().getLength();
            }
        }
        return null;
    }
    
    public static String truncateFieldIfNeeded(String fieldP, Integer lengthP){
        
        if(fieldP.length() > lengthP){
            fieldP = fieldP.substring(0, lengthP);
        }
        return fieldP;
    }
    
}