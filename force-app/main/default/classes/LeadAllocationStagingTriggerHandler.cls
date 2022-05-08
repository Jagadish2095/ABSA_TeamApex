/**
* Default Trigger handler for the Lead_Allocation_Staging__c Trigger
* 
* @author Rudolf Niehaus
* @since  2020-05-06
* 
*/


public class LeadAllocationStagingTriggerHandler extends TriggerHandler {

    public virtual override void beforeInsert(List<sObject> newRecords) {
        LeadAllocationStagingTriggerFunctions.beforeInsert(newRecords);
    }

    public virtual override void afterInsert(Map<Id, sObject> newRecords) {
        LeadAllocationStagingTriggerFunctions.afterInsert(newRecords);
    }
    
}