/**
* @description Integration Handler for Create Leads function

*/
public class CreateLeads_IH_v1 {
    /**
* @description Integration Utility for Create Leads function
* @param createLeadsRequest
* @return response
*/
    public static CreateLeads_Resp_IB_v1 createLeads(List<CreateLeads_Req_IB_v1> createLeadsRequest){
        String description;
        Sys_Log_Integration__c log;
        List<Sys_Log_Integration__c> logList = new List<Sys_Log_Integration__c>();
           
        if(createLeadsRequest.size() > 0){
            try{
                string response = CreateLeads_UI_v1.createLeadRecord(createLeadsRequest);
                log = SystemLogger.createRequestIntegrationLog(JSON.serialize(createLeadsRequest), 'CreateLeads_IH_v1.CreateLeads', StringConstants.SALESFORCE_STRING, StringConstants.SALESFORCE_STRING);
                                
                string finalResponse = response.substring(1, response.length()-1);
                Map<String, String> m = (Map<String, String>) JSON.deserialize(finalResponse, Map<String, String>.class);
                String sCodeStr = m.get('Status');
                Integer sCode = sCodeStr.contains('4') ? 400 : sCodeStr.contains('5') ? 500 : 200;
                String statCode = sCodeStr.contains('4') ? '400' : sCodeStr.contains('5') ? '500' : '200';
                  
                //log = SystemLogger.mapResponseFields(log,200,StringConstants.STATUS_CODE_200, response);
                //return CreateLeads_UI_v1.mapFieldsCreateLeadResponse(StringConstants.STATUS_CODE_200 , 200, StringConstants.MSG_CLIENT_LEAD_CREATE ,response);
                
                log = SystemLogger.mapResponseFields(log, sCode, statCode, response);
                return CreateLeads_UI_v1.mapFieldsCreateLeadResponse(statCode, sCode, StringConstants.MSG_CLIENT_LEAD_CREATE ,response);

            }catch(Exception ex){
                //Bad Response
               description = StringConstants.ERROR_MSG_COULD_NOT_CREATE_LEAD + ex.getMessage() + '. ' + ex.getStackTraceString();
               log = SystemLogger.createInternalIntegrationLog('CreateLeads_IH_v1.CreateLeads', StringConstants.MSG_CLIENT_LEAD_CREATE, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
               return CreateLeads_UI_v1.mapFieldsCreateLeadResponse(StringConstants.STATUS_CODE_500, 500, description, null);
            }
        	
        }else{
            //Empty Leads Records
            description = StringConstants.ERROR_MSG_COULD_NOT_EMPTY_LEAD_ERROR;
            log = SystemLogger.createInternalIntegrationLog('CreateLeads_IH_v1.CreateLeads', StringConstants.MSG_CLIENT_LEAD_CREATE, 500, StringConstants.INTEGRATION_STATUS_FAILED, description);
            return CreateLeads_UI_v1.mapFieldsCreateLeadResponse(StringConstants.STATUS_CODE_500, 500, description, null);
        }
           //return null;
        }
}