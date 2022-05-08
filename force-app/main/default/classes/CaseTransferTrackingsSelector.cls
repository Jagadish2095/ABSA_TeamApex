/**
* Apex Enterprise Design Patterns
* Selector Layer for custom Object Case_Transfer_Tracking__c
*
* @author  Tracy de Bruin - CloudSmiths
* @since   2019-01-18
*/
public class CaseTransferTrackingsSelector extends fflib_SObjectSelector {
    
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType(){
        return Case_Transfer_Tracking__c.sObjectType;
    }
    
    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            Case_Transfer_Tracking__c.Id,
                Case_Transfer_Tracking__c.In__c,
                Case_Transfer_Tracking__c.Out__c,
                Case_Transfer_Tracking__c.Total_Time_Min__c
            };
    }
    
    //INHERIT FROM BASE CLASS - START
    //get records by id's 
    public List<Case_Transfer_Tracking__c> selectById(Set<Id> idSet) {
        return (List<Case_Transfer_Tracking__c>) selectSObjectsById(idSet);
    }
    
    //INHERIT FROM BASE CLASS - END

    //CUSTOM SELECTORS - START
    
   
    //CUSTOM SELECTORS - END
}