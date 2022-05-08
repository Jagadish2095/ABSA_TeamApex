/**
* Apex Enterprise Design Patters
* Selector layer for ESP_Onboarded__c objects
*
* @author  Manoj Danthala
* @since   11/18/2020
*/
public class ESPOnboardedSelector extends fflib_SObjectSelector{
    public Schema.SObjectType getSObjectType() {
        return ESP_Onboarded__c.sObjectType;
    }
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                ESP_Onboarded__c.Id
        };
    }
    public List<ESP_Onboarded__c> selectBycif(String cifKeyP) {
        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('ClientKey__c').
            setCondition('ClientKey__c =: cifKeyP').
            toSOQL()
        );
    }
    
}