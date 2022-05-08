/**
* RESTful API to update opportunity.
* The payload will consist of opportunity information.
* @author  Muvhuso Nekhubvi
* @created 2019-06-24
* @Updated by Muvhuso Nekhubvi 
* @Updated Date 2019-06-26
*/
@RestResource(urlMapping='/UpdateOpportunity/v01/*')
global with sharing class SalesForceUpdateOpportunity_ApiRest_v1 {
    
    @HttpPost
    global static String UpdateOpportunity(SalesForceUpdateOpportunity_Req_IB_v1 updateOpportunityrequest){
        
        SalesForceUpdateOpportunity_Resp_IB_v1 updateOppResp;
        String response;
        Sys_Log_Integration__c log;
        Integer statusCode;
        
        try{
            //Extract Header
            
            Map<String, String> headers = RestContext.request.headers;
            String transactionId = headers.get(StringConstants.FIELD_TRANSACTION_ID);
            String initiator = headers.get(StringConstants.FIELD_INITIATOR);
            String sender = headers.get(StringConstants.FIELD_SENDER);
            
            //Create Request Log
            log = SystemLogger.createRequestIntegrationLog(JSON.serialize(updateOpportunityrequest, true), StringConstants.METHOD_UPDATE_OPP_REST, sender, StringConstants.SALESFORCE_STRING);
            //Map Audit Header fields to log
            log = SystemLogger.mapAuditFields(log, transactionId, initiator, sender);
            //update Opportunity, return SalesforceUpdateOpportunity_Resp_IB_v1 object
             updateOppResp = SalesForceUpdateOpportunity_IH_v1.updateOpportunity(updateOpportunityrequest);
            //Serialize into JSON String
            response =  JSON.serialize( updateOppResp, true );
            //Check Status Code
            if(updateOppResp.status == StringConstants.STATUS_CODE_200){
                //map Positive Response to log
                log =  SystemLogger.mapResponseFields(log, 200, StringConstants.INTEGRATION_STATUS_SUCCESS, response);
                //statusCode = 200;
            }else{
                //map Negative Response to log
                log =  SystemLogger.mapResponseFields(log, Integer.valueOf(updateOppResp.status.substringBefore(StringConstants.SPACE_STRING)), StringConstants.INTEGRATION_STATUS_FAILED, response);
                //statusCode = Integer.valueOf(updateOppResp.status.substringBefore(StringConstants.SPACE_STRING));
            }
        }catch(Exception e){
            
            //Serialize SalesforceUpdateOpportunity_Resp_IB_v1 into JSON
            //response =  JSON.serialize( SalesForceUpdateOpportunity_UI_v1.mapFieldsUpdateOpportunityResponse(StringConstants.STATUS_CODE_500, 500, StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString(), null), true );
            //map negative response to log
            //log =  SystemLogger.mapResponseFields(log, 500, StringConstants.INTEGRATION_STATUS_FAILED, response);
            
            //Create Error message with exception
            String errorMessage = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(errorMessage);
            //create negative SalesForceUpdateOpportunity_Resp_IB_v1 object
            updateOppResp = SalesForceUpdateOpportunity_UI_v1.mapFieldsUpdateOpportunityResponse(StringConstants.STATUS_CODE_500, 500, errorMessage, null);
            //Create Request Integration Log
            log = SystemLogger.createRequestIntegrationLog(JSON.serialize(updateOpportunityrequest, true), StringConstants.METHOD_CREATE_OPP_REST, null, StringConstants.SALESFORCE_STRING);
            //Serialize SalesForceUpdateOpportunity_Resp_IB_v1 into JSON
            response =  JSON.serialize( updateOppResp, true );
            statusCode = 500;
            //map negative response to log
            log =  SystemLogger.mapResponseFields(log, 500, StringConstants.INTEGRATION_STATUS_FAILED, response);
            
        }
        
        insert log;
        return response;
     }
  
}