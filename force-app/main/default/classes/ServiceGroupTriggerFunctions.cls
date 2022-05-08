/**
* Functions class for ServiceGroupTrigger
*
* @author: Koketso Mpshane
* @since: 2020-07-21
*
**/
public class ServiceGroupTriggerFunctions {
    
    @future
    public static void updateInternalNotificationUserOnCases(Set<Id> serviceGroupIds, Set<Id> notificationUserIds, Map<Id,Id> notificationUserIdsMap) {
        
        List<Case> caseRecordsToUpdate = new List<Case>();
        
        for(Case eachCase: [Select Internal_SLA_Notification_User__c From Case Where sd_Service_Group_Id__c in:serviceGroupIds And Internal_SLA_Notification_User__c in:notificationUserIds And IsClosed =:false]) {
            eachCase.Internal_SLA_Notification_User__c = notificationUserIdsMap.get(eachCase.Internal_SLA_Notification_User__c);
            caseRecordsToUpdate.add(eachCase);
        }
        
        try{
            if(caseRecordsToUpdate.size() > 0){
                update caseRecordsToUpdate;
            }
        }catch(Exception ex){
            system.debug(LoggingLevel.FINE, 'Notification User Update Error:'+ex);
            throw ex;
        } 
        
    }
    
}