/**
* Default Knowledge trigger handler that extends the TriggerHandler framework
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2018-11-01
*
**/
public class KnowledgeTriggerHandler extends TriggerHandler{
 		
    public virtual override void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        KnowledgeTriggerFunctions.syncAssignedToBeforeUpdate(Trigger.New);
    }
    
    
    /* Uncomment if needed
      public virtual override void beforeInsert(List<sObject> newRecords) {
        
      } 
    */
    /* Uncomment if needed
    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {
        System.debug('CaseTriggerHandler : override beforeDelete');
    }*/
     /* Uncomment if needed       
    public virtual override void afterInsert(Map<Id, sObject> newRecords) {
    }
    */
     /* Uncomment if needed
    public virtual override void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
		
    }
	*/
    /* Uncomment if needed
    public virtual override void afterDelete(Map<Id, sObject> oldRecords) {
        System.debug('CaseTriggerHandler : override afterDelete');
    }*/

    /* Uncomment if needed
    public virtual override void afterUndelete(Map<Id, sObject> oldRecords) {
        System.debug('CaseTriggerHandler : override afterUndelete');
    }*/
}