/**
* Description: Default Lead trigger handler that extends the TriggerHandler framework
* Test Class Name: LeadTriggerFunctionsTest
* @Author:  Rakesh Byri(Absa)
* @Created Date:  2019-02-18
* CHANGE LOG:
*=======================================================================================================
* Author                CreatedDate             Change
* Manoj Danthala        2019-03-07              Added afterUpdate method
* Rudolf Niehaus        2019-05-14              Add methods for implimenting the communcation plan
                                                for Leads
*=======================================================================================================
**/
public class LeadTriggerHandler extends TriggerHandler {

    public virtual override void beforeInsert(List<sObject> newRecords) {
        LeadTriggerFunctions.beforeInsert(newRecords);
    }

    public virtual override void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        LeadTriggerFunctions.beforeUpdate(newRecords,oldRecords);        
    }
    
    public virtual override void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> OldRecords) {
    	LeadTriggerFunctions.afterUpdate(newRecords,oldRecords);
    }

    public virtual override void afterInsert( Map<Id, sObject> newRecords ) {
    	LeadTriggerFunctions.afterInsert(newRecords);
    }
     public virtual override void beforeDelete(Map<Id, sObject> oldRecords){
        LeadTriggerFunctions.beforeDelete(oldRecords);
    } 
    public virtual override void afterDelete(Map<Id, sObject> oldRecords){
        LeadTriggerFunctions.afterDelete(oldRecords);
    } 
}