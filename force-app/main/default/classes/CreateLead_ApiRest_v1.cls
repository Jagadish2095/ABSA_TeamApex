/**
* @description Integration Utility for Create Leads function
* 
*/
@RestResource(urlMapping='/CreateLeads/v01/*')
global with sharing class CreateLead_ApiRest_v1 {
    /**
* @description Integration Utility for Create Leads function
* @param leadsRequest
* @return response
*/
	@HttpPost
    global static String CreateLeads(List<CreateLeads_Req_IB_v1> leadsRequest){
        
        String response;
        CreateLeads_Resp_IB_v1 createLeadsResp = CreateLeads_IH_v1.createLeads(leadsRequest);
        response =  JSON.serialize(createLeadsResp, true);
        return response;
    }
}