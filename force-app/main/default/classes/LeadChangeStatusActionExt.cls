/**
* Apex extension class for the lightning quick action LeadChangeStatusAction
*
* @author  Koketso Mpshane
* @since   2020-03-11
*
**/
public class LeadChangeStatusActionExt {
    
    /*
    * Return the closed status of the current lead
    *
    * @param  leadId String
    * @return Boolean
    */
    @AuraEnabled
    public static Boolean getLeadCloseStatus(String leadId) {
        
        Set<Id> idSet = new Set<Id>();
        idSet.add(leadId);
        
        List<Lead> focusedLead = new LeadsSelector().selectById(idSet);
        
        if(focusedLead.size() > 0){
            
            if(focusedLead[0].Status == 'Closed'){
                return true;
            }else{
                return false;
            }
            
        }else{
           return false;  
        }
        
    }
    
    /*
    * Change Lead Statuses                        
    * @param  leadId String 
    * @param  qname String 
    * @param  reason String
    * @param  comments String
    * @return void
    */
    @AuraEnabled
    public static void updateLeadStatus(String leadId, String status, String subStatus, String statusReason, String leadRating, String leadRatingComment) {
        Set<Id> leadIds = new Set<Id>();
        leadIds.add(leadId);
        
        List<Lead> actionLeads = new LeadsSelector().selectById(leadIds);
        
        if(!actionLeads.isEmpty()) {
            
            actionLeads[0].Status                 = status;
            actionLeads[0].SubStatus__c           = subStatus;
            actionLeads[0].On_Hold_Reason__c      = statusReason;
            actionLeads[0].Lead_Rating__c         = leadRating;
            actionLeads[0].Lead_Rating_Comment__c = leadRatingComment;
            System.debug('actionLeads[0].Lead_Rating_Comment__c ==> '+ actionLeads[0].Lead_Rating_Comment__c);
            try{
                update actionLeads;
            }catch(DMLException ex){
                system.debug('Error changing status:' + ex.getMessage());
                throw new AuraHandledException(ex.getMessage()); 
            }
        }else{
            system.debug('Error changing status of the Lead'); 
            throw new AuraHandledException('Error changing status of the Lead, please contact your Salesforce Administrator'); 
        }
    }

}