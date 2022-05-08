/**
* RESTful API to consume opportunity data from Siebel.
* The payload will consist of account and opportunity information.
* If the account does not exist on Salesforce, it will be created with the associated opportunity.
* If the account exists in Salesforce, only the associated opportunity will be created.
* @author  Kyle Alexander
* @created 2018-05-28
* @Updated by Danie Booysen and Jason Quevauvilliers
* @Updated Date 2018-08-23
*/

@RestResource(urlMapping='/createOpportunity/v01/*')
global Without Sharing class CreateOpportunity_ApiRest_v1 {
    
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
            
            //Create Request Log
            log = SystemLogger.createRequestIntegrationLog(JSON.serialize(wrpVals, true), StringConstants.METHOD_CREATE_OPP_REST, sender, StringConstants.SALESFORCE_STRING);
            //Map Audit Header fields to log
            log = SystemLogger.mapAuditFields(log, transactionId, initiator, sender);
            //Try to create Opportunity, return CreateOpportunity_Resp_IB_v1 object
            createOppResp = CreateOpportunity_IH_v1.createOpportunity(wrpVals, transactionId, initiator, sender);
            //Serialize into JSON String
            response =  JSON.serialize( createOppResp, true );
            //Check Status Code
            if(createOppResp.status == StringConstants.STATUS_CODE_200){
                //map Positive Response to log
                log =  SystemLogger.mapResponseFields(log, 200, StringConstants.INTEGRATION_STATUS_SUCCESS, response);
                statusCode = 200;
            }else{
                //map Negative Response to log
                log =  SystemLogger.mapResponseFields(log, Integer.valueOf(createOppResp.status.substringBefore(StringConstants.SPACE_STRING)), StringConstants.INTEGRATION_STATUS_FAILED, response);
                statusCode = Integer.valueOf(createOppResp.status.substringBefore(StringConstants.SPACE_STRING));
            }
        }catch(Exception e){
            //Create Error message with exception
            String errorMessage = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(errorMessage);
            //create negative CreateOpportunity_Resp_IB_v1 object
            createOppResp = CreateOpportunity_IU_v1.mapFieldsCreateOpportunityResponse(StringConstants.STATUS_CODE_500, 500, errorMessage, null);
            //Create Request Integration Log
            log = SystemLogger.createRequestIntegrationLog(JSON.serialize(wrpVals, true), StringConstants.METHOD_CREATE_OPP_REST, null, StringConstants.SALESFORCE_STRING);
            //Serialize CreateOpportunity_Resp_IB_v1 into JSON
            response =  JSON.serialize( createOppResp, true );
            statusCode = 500;
            //map negative response to log
            log =  SystemLogger.mapResponseFields(log, 500, StringConstants.INTEGRATION_STATUS_FAILED, response);
            
        }
        if(!test.isRunningTest()){
            RestContext.response.statusCode = statusCode;
        }
        insert log;
        return response;
    }
    
}