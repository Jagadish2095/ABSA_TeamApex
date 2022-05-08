/**
* Descripton: Apex Handler class for upadating salesforce opportunity
* @author  Muvhuso Nekhubvi : Absa
* @since   2019-05-21
*
**/

public class SalesForceUpdateOpportunity_IH_v1 {
    
    //method to update opportunity
    public static SalesForceUpdateOpportunity_Resp_IB_v1 updateOpportunity(SalesForceUpdateOpportunity_Req_IB_v1 updateOpportunity){
        
        String description;
        //Checking if lead number and opportunity stage is not empty
        if(String.isEmpty(updateOpportunity.leadNumber) || String.isEmpty(updateOpportunity.opportunityStage)){
            //Retrun bad response if lead number or opportunity stage is empty
            return SalesForceUpdateOpportunity_UI_v1.mapFieldsUpdateOpportunityResponse(StringConstants.STATUS_CODE_400, 400, StringConstants.ERROR_MSG_LEAD_NUMBER_AND_OPPSTAGE_REQUIRED, null);
        }else{
            try{
                //Validation for valid opportunity stage! valid status (Rejected and Completed)
                if(SalesForceUpdateOpportunity_UI_v1.isValidSalesforceStage(updateOpportunity.opportunityStage)){
                   
                   //query to select opportunity by lead number
                   Opportunity opportunityRecord = [SELECT Id , StageName FROM Opportunity WHERE Lead_Number__c = : updateOpportunity.leadNumber];
                  //Comparing status before updating
                  
                if(opportunityRecord.StageName != updateOpportunity.opportunityStage){
                        //Update opportunity record
                        SalesForceUpdateOpportunity_UI_v1.updateOpportunityRecord(updateOpportunity,opportunityRecord);
                        //Success response 
                        return SalesForceUpdateOpportunity_UI_v1.mapFieldsUpdateOpportunityResponse(StringConstants.STATUS_CODE_200, 200,StringConstants.MSG_CLIENT_OPP_UPDATE, updateOpportunity.leadNumber );
                        
                }else{
                            //Opportunity already update response
                            return SalesForceUpdateOpportunity_UI_v1.mapFieldsUpdateOpportunityResponse(StringConstants.STATUS_CODE_200, 200, StringConstants.MSG_CLIENT_OPP_ALREADY_UPDATE, updateOpportunity.leadNumber );
                        }
                }else{
                     //Invalid opportunity stage response
                    return SalesForceUpdateOpportunity_UI_v1.mapFieldsUpdateOpportunityResponse(StringConstants.STATUS_CODE_200, 200, StringConstants.ERROR_MSG_INVALID_OPP_STAGE, updateOpportunity.leadNumber );
                }     
            }catch(Exception ex){
                //Bad Response
               description = StringConstants.ERROR_MSG_COULD_NOT_FIND_OPPORTUNITY + ex.getMessage() + '. ' + ex.getStackTraceString();
               return SalesForceUpdateOpportunity_UI_v1.mapFieldsUpdateOpportunityResponse(StringConstants.STATUS_CODE_500, 500, description, null);

            }
        }  
     }
}