/**
* Default Unwanted_Email__c trigger handler that extends the TriggerHandler framework
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-10-10
*
**/
public class UnwantedEmailTriggerHandler extends TriggerHandler{
    
   
    public virtual override void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
		UnwantedEmailTriggerFunctions.convertToCase(Trigger.new);
    }
    
    
    /* Uncomment if needed
    public virtual override void beforeInsert(List<sObject> newRecords) {
  
    }*/
    /* Uncomment if needed
    public virtual override void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        
    }*/
    /* Uncomment if needed
    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {
        System.debug('CaseTriggerHandler : override beforeDelete');
    }*/
    /*       
    public virtual override void afterInsert(Map<Id, sObject> newRecords) {
       
    }*/
    /* Uncomment if needed
    public virtual override void afterDelete(Map<Id, sObject> oldRecords) {
        System.debug('CaseTriggerHandler : override afterDelete');
    }*/

    /* Uncomment if needed
    public virtual override void afterUndelete(Map<Id, sObject> oldRecords) {
        System.debug('CaseTriggerHandler : override afterUndelete');
    }*/

}