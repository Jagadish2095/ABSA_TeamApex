/**
* Default Service Level trigger handler that extends the TriggerHandler framework
*
* @author: Koketso Mpshane
* @since: 2020-07-22
*
**/

public class ServiceLevelTriggerHandler extends TriggerHandler {
   
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
        
        List<Service_Level__c> newServiceLevelList = (List<Service_Level__c>)newRecords.values();
        Set<Id> serviceLevelIds = new Set<Id>();
        Set<Id> oldExternalUserIds = new Set<Id>();
        Map<Id, Id> externalUserIdsMap = new Map<Id, Id>();
        
        for(Service_Level__c sl: newServiceLevelList){
            Service_Level__c oldsl = (Service_Level__c)oldRecords.get(sl.Id);
            
            if(sl.External_SLA_Notification_User__c != oldsl.External_SLA_Notification_User__c) {
                serviceLevelIds.add(sl.Id);
                oldExternalUserIds.add(oldsl.External_SLA_Notification_User__c);
                externalUserIdsMap.put(oldsl.External_SLA_Notification_User__c, sl.External_SLA_Notification_User__c);
            }
            
        }
        
        system.debug(LoggingLevel.FINE, '**oldExternalUserIdsSIZE**' + oldExternalUserIds.size());
        if(oldExternalUserIds.size() > 0){
			ServiceLevelTriggerFunctions.updateExternalNotificationUserOnCases(serviceLevelIds, oldExternalUserIds, externalUserIdsMap);            
        }
        
    }
    
    /* Uncomment if needed
    public virtual override void afterDelete(Map<Id, sObject> oldRecords) {
    
    }*/
    
    /* Uncomment if needed
    public virtual override void afterUndelete(Map<Id, sObject> oldRecords) {
    
    }*/
}