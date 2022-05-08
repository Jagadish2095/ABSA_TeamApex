/**
* RESTful API to consume opportunity data
* @author  Danie Booysen and Jason Quevauvilliers
* @created 2019-07-29
*/

@RestResource(urlMapping='/createOpportunity/v02/*')
global Without Sharing class CreateOpportunity_ApiRest_v2 {
    
    /**
* REST API method that consumes data and creates account and opportunity
*
* @return String - in JSON format with status code, description and opportunity ID
*/
    @HttpPost
    global static String createOpportunity(CreateOpportunity_Req_IB_v1 wrpVals){
        
        CreateOpportunity_Resp_IB_v1 createOppResp;
        String response;
        Sys_Log_Integration__c log;
        Integer statusCode;
        
        try{
            //Extract Header
            Map<String, String> headers = RestContext.request.headers;
            String transactionId = headers.get(StringConstants.FIELD_TRANSACTION_ID);
            String initiator = headers.get(StringConstants.FIELD_INITIATOR);
            String sender = headers.get(StringConstants.FIELD_SENDER);
            
            log = SystemLogger.createRequestIntegrationLog(String.valueOf(wrpVals), 'CreateOpportunity_ApiRest_v2.createOpportunity', null, StringConstants.SALESFORCE_STRING);
            
            //Try to create Opportunity, return CreateOpportunity_Resp_IB_v1 object
            createOppResp = CreateOpportunity_IH_v2.createOpportunity(wrpVals, transactionId, initiator, sender);
            
            log = SystemLogger.mapResponseFields(log, createOppResp.statusCode, createOppResp.status, String.valueOf(createOppResp));
            
            //Serialize into JSON String
            response =  JSON.serialize( createOppResp, true );
            //Check Status Code
            if(createOppResp.status == StringConstants.STATUS_CODE_200){
                statusCode = 200;
            }else{
                statusCode = Integer.valueOf(createOppResp.status.substringBefore(StringConstants.SPACE_STRING));
            }
        }catch(Exception e){
            //Create Error message with exception
            String errorMessage = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(errorMessage);
            //create negative CreateOpportunity_Resp_IB_v1 object
            createOppResp = CreateOpportunity_IU_v1.mapFieldsCreateOpportunityResponse(StringConstants.STATUS_CODE_500, 500, errorMessage, null);
            //Serialize CreateOpportunity_Resp_IB_v1 into JSON
            response =  JSON.serialize( createOppResp, true );
            statusCode = 500;
            //Create Request Integration Log
            log =  SystemLogger.createInternalIntegrationLog(StringConstants.METHOD_CREATE_OPP_REST, StringConstants.SALESFORCE_STRING, 500, StringConstants.STATUS_CODE_500, errorMessage);
            log.Request__c = Sys_Utilities_General.truncateFieldIfNeeded(JSON.serialize(wrpVals, true), Sys_Utilities_General.getSObjectFieldLength(StringConstants.SYS_LOGGER_OBJ_NAME, StringConstants.REQUEST_FIELD_NAME));
            
        }
        if(!test.isRunningTest()){
            RestContext.response.statusCode = statusCode;
        }
        if(log != null){
            insert log;
        }
        return response;
    }
    
}