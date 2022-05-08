/**
* Lightning Component for Covid19 Quality Validator  (For Non Scored)
*
* @author  Himanshu Nimje
* @since   2020-11-27
* UserStory W-007816
*/


Public class TermLoansQualityValidator {
    
   
    @AuraEnabled 
    public static user fetchUser(){
        User u = [select id,Name from User where id =: userInfo.getUserId()];
        return u;
    }
    
    @AuraEnabled
    Public static String submitDecision(String oppId,String decision,String reason , String comments, String defaultApprover){ 
        
        System.debug('opp id++ ' + oppId + '@@decision ' + decision + '##reason' + reason  + '##comments' + comments + '##defaultApprover' + defaultApprover);
        
        String returnMessage = 'SUCCESS';
        List<Opportunity> opportunities = new OpportunitiesSelector().selectByOpportunityId(oppId);
        System.debug('opportunities ' + opportunities); 
        
        Opportunity oppToUpdate = new Opportunity();
        if(!opportunities.isEmpty()){
            if(decision=='Accepted'){
                oppToUpdate.Id = opportunities[0].Id;
                oppToUpdate.Is_Submitted_QValidation__c=true;
                oppToUpdate.Comments__c=comments;
                oppToUpdate.QVDecision__c = decision; 
                oppToUpdate.QV_Default_Approver__c=defaultApprover;
                oppToUpdate.StageName = 'Get Contract Signed';
                try{
                    update oppToUpdate;
                    System.debug('Accepted oppToUpdate ' + oppToUpdate);
                    return returnMessage;
                    
                }
                catch(Exception ex) {
                    returnMessage=('Opportunity Accepted Update Error:' + ex.getDmlMessage(0));
                    System.debug('Error Accepted oppToUpdate ' + returnMessage);
                    return returnMessage;
                }
                
            }else if(decision=='Rejected'){
                oppToUpdate.Id = opportunities[0].Id;
                oppToUpdate.Is_Submitted_QValidation__c = true;
                oppToUpdate.Comments__c = comments;
                oppToUpdate.RejectedReason__c = reason;
                oppToUpdate.QVDecision__c = decision;
                
                try{
                    update oppToUpdate;
                    System.debug('Rejected oppToUpdate ' + oppToUpdate);
                    return returnMessage;
                }
                catch(Exception ex) {
                    returnMessage=('Opportunity Rejected Update Error:' + ex.getDmlMessage(0));
                    System.debug('Error Rejected oppToUpdate ' + returnMessage);
                    return returnMessage;
                }
            }
        }
        
        return null;
        
    }
    
}