/**
 * @description       : 
 * @author            : muvhuso.nekhubvi@absa.africa
 * @last modified on  : 2021-07-04
 * @last modified by  : muvhuso.nekhubvi@absa.africa
 * Modifications Log 
 * Ver   Date         Author                         Modification
 * 1.0   2021-07-04   muvhuso.nekhubvi@absa.africa   Initial Version
**/
public class CovenantTriggerHandler extends TriggerHandler {
	 
    public virtual override void beforeInsert(List<sObject> newRecords) {
			CovenantTriggerFunctions.updateCaseServiceTypeInfoBeforeInsert(Trigger.new);
    }
    public virtual override void afterInsert(Map<Id, sObject> newRecords) {
         for(Id newRecordId: newRecords.keySet()) {
             CovenantTriggerFunctions.createTask(newRecordId , 'Create');
         }
     }
    
    public virtual override void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
       // CovenantTriggerFunctions.updateCaseServiceTypeInfoBeforeInsert(Trigger.new);
       CovenantTriggerFunctions.updateCovenantBeforeUpdate(Trigger.new , Trigger.old);
    }
    
    public virtual override void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        if(System.IsBatch() == false && System.isFuture() == false){
        for(Id newRecordId: newRecords.keySet()) {

            Covenant__c covenant = (Covenant__c)newRecords.get(newRecordId);
            
            if(covenant.Covenant_Approved__c){
                CovenantTriggerFunctions.completeTask(covenant.Name , covenant.Account__c);
                
                if(covenant.Covenant_Status__c == 'MET' || covenant.Covenant_Status__c == 'WAIVED'){
                    CovenantTriggerFunctions.createTask(newRecordId , 'update');
                }else if(covenant.Covenant_Status__c == 'BREACHED' || covenant.Covenant_Status__c == 'CLOSED' ){
                    CovenantTriggerFunctions.createTask(newRecordId , 'close');
                }
            }
        }
      }
    }
         
}