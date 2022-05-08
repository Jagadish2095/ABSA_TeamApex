/**
* Apex Enterprise Design Patterns
* Selector Layer for Data_Staging_Setting__mdt objects
*
* @author       Tracy de Bruin (CloudSmiths)
* @since        15-08-2019
* @modified     
*/

public class DataStagingSettingsSelector extends fflib_SObjectSelector {
  //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Data_Staging_Setting__mdt.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Data_Staging_Setting__mdt.Id,
                Data_Staging_Setting__mdt.Action_Plan_Name__c,
                Data_Staging_Setting__mdt.DeveloperName,
                Data_Staging_Setting__mdt.Label, 
                Data_Staging_Setting__mdt.CC_Banker_in_Emails__c,
                Data_Staging_Setting__mdt.From_Email_Address__c
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //INHERIT FROM BASE CLASS - START
    public List<Data_Staging_Setting__mdt> selectById(Set<Id> idSet) {
        return (List<Data_Staging_Setting__mdt>) selectSObjectsById(idSet);
    }

    //INHERIT FROM BASE CLASS - STOP

    //CUSTOM SELECTORS - START

    /**
     * Method that gets a List of Data_Staging_Setting__mdt based on DeveloperName
     *
     * @return List<Data_Staging_Setting__mdt> 
     */
    public List<Data_Staging_Setting__mdt> selectByDeveloperName(Set<String> actionPlanNames) {
        return Database.query(
                newQueryFactory().
                        setCondition('DeveloperName IN :actionPlanNames').
                        toSOQL()
        );

    }

    //CUSTOM SELECTORS - END
}