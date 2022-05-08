/**
* Apex Integration Utility Bean class for updating salesforce opportunity
* @author  Muvhuso Nekhubvi : Absa
* @since   2019-05-21
*
**/
public class SalesForceUpdateOpportunity_UI_v1 {
    
    public static void updateOpportunityRecord(SalesForceUpdateOpportunity_Req_IB_v1 updateOpportunity ,  Opportunity opportunity){
        opportunity.StageName = updateOpportunity.opportunityStage;
        opportunity.Last_External_Update_Reference__c = updateOpportunity.externalReference;
        opportunity.Last_External_Update_System__c = updateOpportunity.extenalSystem;
        opportunity.Last_External_Update_User__c = UserInfo.getName();
        opportunity.Last_External_Update_Time__c = System.now(); 
        opportunity.Comments__c = updateOpportunity.comments;
        update opportunity;
    }
    public static SalesForceUpdateOpportunity_Resp_IB_v1 mapFieldsUpdateOpportunityResponse(String statusP, Integer statusCodeP, String descriptionP, String leadNumber){
		
		SalesForceUpdateOpportunity_Resp_IB_v1 updateOpportunityResponse = new SalesForceUpdateOpportunity_Resp_IB_v1();
		
		updateOpportunityResponse.status = statusP;
        updateOpportunityResponse.statusCode = statusCodeP;
		updateOpportunityResponse.description = descriptionP;
		if(leadNumber != null ){
			updateOpportunityResponse.leadNumber = leadNumber;
        }
		return updateOpportunityResponse;
	}
    
    public static boolean isValidSalesforceStage(String status){
        String[] stage = StringConstants.ESP_STAGES.split(',');
        Boolean results = false;
       
        for(Integer i = 0 ; i < stage.Size(); i++){
            
            if(stage[i] == status){  
                results = true;
                break;
                
            }
        }
        
        return results;
    }
}