/**
* Apex extension class for the lightning quick action CaseTransferAction
*
* @author  Sipho Mbulawa
* @since   2020-03-04
*
**/
public class LeadTransferActionExt {   
    
     /*
    * Return the closed status of teh current case
    *
    * @param  caseId String
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
    * Transfer a Case                        
    * <p>
    * Transfer a Case from the existing queue
    * to a new queue that were selected by 
    * the end user
    *
    * @param  caseId String 
    * @param  qname String 
    * @param  reason String
    * @param  comments String
    * @return void
    */
    @AuraEnabled
    public static void transferLead(String leadId, String qname, String reason, String comments, Service_Group__c serviceGroupRecord) {
        //Add Case Id to Set
        Set<Id> leadIds = new Set<Id>();
        leadIds.add(leadId);
        
        Set<Id> serviceGroupIds = new Set<Id>();
        List<Service_Group_Type__c> serviceGroupTypes = new List<Service_Group_Type__c>();
        
        //Call method from Case selector to query case details
        List<Lead> actionLeads = new LeadsSelector().selectById(leadIds);
        
        if(serviceGroupRecord != null) {
            
            //actionLeads[0].Previous_Manager__c = actionLeads[0].sd_Service_Group__c;
            actionLeads[0].Previous_Branch__c = actionLeads[0].sd_Service_Group__c;
            actionLeads[0].sd_Service_Group__c = serviceGroupRecord.Name;
            actionLeads[0].sd_Service_Group_Id__c = serviceGroupRecord.Id;
            actionLeads[0].Service_Group_Search__c = serviceGroupRecord.Id;
            actionLeads[0].Previous_Manager__c = actionLeads[0].Manager__c;
            
            //actionLeads[0].Transfer_Reason__c = reason;
            //actionLeads[0].Transfer_Comments__c = comments;
            
            serviceGroupIds.add(serviceGroupRecord.Id);
            //Call method from Service Group Types Selector to query Service Group Types details
            serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceGroupWithGroupAndServiceInfo(serviceGroupIds);
            
            if(!serviceGroupTypes.isEmpty()){
                actionLeads[0].Internal_SLA_Notification_User__c  = serviceGroupTypes[0].Service_Group__r.Internal_SLA_Notification_User__c;     
                actionLeads[0].External_SLA_Notification_User__c = serviceGroupTypes[0].Service_Level__r.External_SLA_Notification_User__c;
                actionLeads[0].Manager__c = serviceGroupTypes[0].Service_Group__r.Manager__c;
                actionLeads[0].sd_Service_Group_Type_Id__c = serviceGroupTypes[0].Id;
            }
            
            List<RecordType> rtypes = [Select Id, Name From RecordType Where Name =:serviceGroupRecord.Assign_Record_Type__c And sObjectType =:'Lead'];
            system.debug(LoggingLevel.FINE, '***rtypes:***'+rtypes);
            
            if(rtypes.size() > 0){
                actionLeads[0].RecordTypeId = rtypes.get(0).Id;
            }
            
            List<Group> leadQueues = [Select Id, Name, DeveloperName From Group Where Name =: serviceGroupRecord.Queue__c And Type =: 'Queue'];
            system.debug(LoggingLevel.FINE, 'leadQueues:'+leadQueues);
            
            if(leadQueues.size() > 0){
                actionLeads[0].OwnerId = leadQueues[0].Id;
                actionLeads[0].Status = 'Unallocated';
                actionLeads[0].Bypass_Validation_Rules__c = true;
                
                if(actionLeads[0].Transfer_Count__c == null){
                  actionLeads[0].Transfer_Count__c = 0;  
                }
                actionLeads[0].Transfer_Count__c = actionLeads[0].Transfer_Count__c + 1;
                actionLeads[0].Single_Transfer__c = true;
            }
            
            try{
                update actionLeads;
            }catch(DMLException ex){
                system.debug('Additional Info:' + ex.getMessage());
                throw new AuraHandledException(ex.getMessage()); 
            }
        }else{
            system.debug('Error transferring the Lead'); 
            throw new AuraHandledException('There was an error transferring the Lead - Service Group is not setup correctly, please contact your Salesforce Administrator'); 
        }
    } 
    
    /*
     * Search case Service Group records                         
     * <p>
     * Search and return a single Service_Group__c object
     * based on the record Id
     *
     * @param  recId String Service_Group__c object Id  
     * @return A single Service_Group__c object 
    */
    @AuraEnabled
    public static Service_Group__c findServiceGroupRecord(String serviceGroupId) {
        
        //Add Id to a Set
        Set<Id> serviceGroupTypes = new Set<Id>();
        serviceGroupTypes.add(serviceGroupId);
        list<Service_Group__c> returnRec = new ServiceGroupsSelector().selectById(serviceGroupTypes);
        
        if(returnRec.size() > 0){
            return returnRec[0];
        }else{
            return null;
        }
    } 
}