/**
* Functions class for ServiceLevelTrigger
*
* @author: Koketso Mpshane
* @since: 2020-07-22
*
**/
public class ServiceLevelTriggerFunctions {
    
    @future
    public static void updateExternalNotificationUserOnCases(Set<Id> serviceLevelIds, Set<Id> notificationUserIds, Map<Id,Id> notificationUserIdsMap) {
        
        Set<Id> serviceGroupIds = new Set<Id>();
        List<Case> caseRecordsToUpdate = new List<Case>();
        
        List<Service_Group_Type__c> serviceGroupTypeList = new ServiceGroupTypesSelector().selectByServiceLevelId(serviceLevelIds);
        
        if(serviceGroupTypeList.size() > 0){
            for(Service_Group_Type__c sgt: serviceGroupTypeList){
                serviceGroupIds.add(sgt.Service_Group__c);
            }
            
            if(serviceGroupIds.size() > 0){
                
                for(Case eachCase: [Select External_SLA_Notification_User__c From Case Where sd_Service_Group_Id__c in:serviceGroupIds And External_SLA_Notification_User__c in:notificationUserIds And IsClosed =:false]) {
                    eachCase.External_SLA_Notification_User__c = notificationUserIdsMap.get(eachCase.External_SLA_Notification_User__c);
                    caseRecordsToUpdate.add(eachCase);
                }
                
                try{
                    update caseRecordsToUpdate;
                }catch(Exception ex){
                    system.debug(LoggingLevel.FINE, 'Notification User Update Error:'+ex);
                    throw ex;
                } 
            }
        }
    }
    
}