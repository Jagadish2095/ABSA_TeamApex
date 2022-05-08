/**
* RESTful API to consume Case data from TOM.
* The payload will consist of case information.
* If the case exist in Salesforce, case information  will be updated.
* @author  Anka Ganta
* @created 2019-08-15
* @Updated 
* @Updated 
*/

@RestResource(urlMapping='/updateComplaint/v01/*')
global Without Sharing class UpdateComplaint_ApiRest_v1 {
    
    /**
* REST API method that consumes data and update case
*
* @return String - in JSON format with status code, description and case ID
*/
    @HttpPatch
    global static String updateComplaint(UpdateComplaint_Req_IB_v1 wrpVals){
         
        
        UpdateComplaint_Resp_IB_v1 updateCaseResp;
        String response;
        Sys_Log_Integration__c log;
        Integer statusCode;
        
        try{
            //Extract Header
            Map<String, String> headers = RestContext.request.headers;
            String initiator = headers.get(StringConstants.FIELD_INITIATOR);
            String sender = headers.get(StringConstants.FIELD_SENDER);
            RestRequest request = RestContext.request;
            System.debug('request check'+request);
            String caseNumber = wrpVals.CaseNumber;
            //String caseNumber = request.requestURI.substring(
            //request.requestURI.lastIndexOf('/')+1);
            System.debug('caseNumber testing'+caseNumber);
            
            //Create Request Log
            log = SystemLogger.createRequestIntegrationLog(JSON.serialize(wrpVals, true), StringConstants.METHOD_UPDATE_CASE_REST, sender, StringConstants.SALESFORCE_STRING);
            
            // update Case, return UpdateComplaint_Resp_IB_v1 object
            if(wrpVals != null && caseNumber != null){
            updateCaseResp = UpdateComplaint_IH_v1.updateComplaint(wrpVals,caseNumber);
            }
            else {
                System.debug('values are null here'+wrpVals + ' ' +caseNumber);
            }
            //Serialize into JSON String
            response =  JSON.serialize(updateCaseResp, true);
            
            
            //Check Status Code
            if(updateCaseResp.status == StringConstants.STATUS_CODE_200){
                //map Positive Response to log
                log =  SystemLogger.mapResponseFields(log, 200, StringConstants.INTEGRATION_STATUS_SUCCESS, response);
                statusCode = 200;
            }else{
                //map Negative Response to log
                log =  SystemLogger.mapResponseFields(log, Integer.valueOf(updateCaseResp.status.substringBefore(StringConstants.SPACE_STRING)), StringConstants.INTEGRATION_STATUS_FAILED, response);
                statusCode = Integer.valueOf(updateCaseResp.status.substringBefore(StringConstants.SPACE_STRING));
            }
        }catch(Exception e){
            //Create Error message with exception
            String errorMessage = StringConstants.UNHANDLED_EXCEPTION_MESSAGE + e.getMessage() + '. ' + e.getStackTraceString();
            System.debug(errorMessage);
            //create negative CreateOpportunity_Resp_IB_v1 object
            updateCaseResp = UpdateComplaint_IU_v1.mapFieldsUpdateComplaintResponse(StringConstants.STATUS_CODE_500, 500, errorMessage, null,null,null);
            //Create Request Integration Log
            log = SystemLogger.createRequestIntegrationLog(JSON.serialize(wrpVals, true), StringConstants.METHOD_CREATE_OPP_REST, null, StringConstants.SALESFORCE_STRING);
            //Serialize CreateOpportunity_Resp_IB_v1 into JSON
            response =  JSON.serialize( updateCaseResp, true );
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