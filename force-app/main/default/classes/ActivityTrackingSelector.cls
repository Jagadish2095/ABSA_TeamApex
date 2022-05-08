/**
* Apex Enterprise Design Patterns
* Selector Layer for custom Object Activity_Tracking__c
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2019-07-08
*/
public class ActivityTrackingSelector extends fflib_SObjectSelector{
   
    public Schema.SObjectType getSObjectType(){
        return Activity_Tracking__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
                Activity_Tracking__c.Id,
                Activity_Tracking__c.Name,
                Activity_Tracking__c.Start_Time__c,
                Activity_Tracking__c.End_Time__c,
                Activity_Tracking__c.Total_Time_Min__c,
                Activity_Tracking__c.Total_Time_Hrs__c,
                Activity_Tracking__c.Total_Time_Days__c,
                Activity_Tracking__c.Start_Initiator__c,
                Activity_Tracking__c.End_Initiator__c,
                Activity_Tracking__c.Lead__c,
                Activity_Tracking__c.Business_Time_Min__c,
                Activity_Tracking__c.Business_Time_Hrs__c,
                Activity_Tracking__c.Business_Time_Days__c,
                Activity_Tracking__c.Status_Tracked__c
            };
    }

    //INHERIT FROM BASE CLASS - START
    //get records by id's 
    public List<Activity_Tracking__c> selectById(Set<Id> idSet) {
        return (List<Activity_Tracking__c>) selectSObjectsById(idSet);
    }
}