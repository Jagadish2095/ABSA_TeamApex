/**
* Default Service Group trigger handler that extends the TriggerHandler framework
*
* @author: Koketso Mpshane
* @since: 2020-07-21
*
**/

public class ServiceGroupTriggerHandler extends TriggerHandler {
   
    /* Uncomment if needed
    public virtual override void beforeInsert(List<sObject> newRecords) {
        
    }*/
	
    /* Uncomment if needed
    public virtual override void beforeUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
    
	}*/
    
    /* Uncomment if needed
    public virtual override void beforeDelete(Map<Id, sObject> oldRecords) {

    }*/
    
    /* Uncomment if needed
    public virtual override void afterInsert(Map<Id, sObject> newRecords) { 
        
    }*/
    
    public virtual override void afterUpdate(Map<Id, sObject> newRecords, Map<Id, sObject> oldRecords) {
        
        List<Service_Group__c> newGerviceGroupList = (List<Service_Group__c>)newRecords.values();
        Set<Id> serviceGroupIds = new Set<Id>();
        Set<Id> oldInternalUserIds = new Set<Id>();
        Map<Id, Id> internalUserIdsMap = new Map<Id, Id>();
        
        for(Service_Group__c sg: newGerviceGroupList){
            Service_Group__c oldsg = (Service_Group__c)oldRecords.get(sg.Id);
            
            if(sg.Internal_SLA_Notification_User__c != oldsg.Internal_SLA_Notification_User__c) {
                serviceGroupIds.add(sg.Id);
                oldInternalUserIds.add(oldsg.Internal_SLA_Notification_User__c);
                internalUserIdsMap.put(oldsg.Internal_SLA_Notification_User__c, sg.Internal_SLA_Notification_User__c);
            }
            
        }
        
        system.debug(LoggingLevel.FINE, '**oldInternalUserIdsSIZE**' + oldInternalUserIds.size());
        if(oldInternalUserIds.size() > 0){
			ServiceGroupTriggerFunctions.updateInternalNotificationUserOnCases(serviceGroupIds, oldInternalUserIds, internalUserIdsMap);            
        }
        
    }
    
    /* Uncomment if needed
    public virtual override void afterDelete(Map<Id, sObject> oldRecords) {
    
    }*/
    
    /* Uncomment if needed
    public virtual override void afterUndelete(Map<Id, sObject> oldRecords) {
    
    }*/
}