/**
 * @description Apex Enterprise Design Patterns 
 * Selector Layer for Controlling Intrest objects
 *
 * @author  Tracy de Bruin
 * @since   July 2021
 */
public class ControllingInterestsSelector extends fflib_SObjectSelector
{
    /**
    * @description getSObjectType description
    * @return Schema.SObjectType: Return description
    */
    public Schema.SObjectType getSObjectType(){
        return Controlling_Interest__c.sObjectType;
    }

    /**
    * @description Returns all ControllingInterests
    * @return List<Schema.SObjectField>
    */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
                Controlling_Interest__c.Id,
                Controlling_Interest__c.Name,
                Controlling_Interest__c.Contact__c,
                    Controlling_Interest__c.Controlling_Interest__c,
                    Controlling_Interest__c.Other_Primary_Entity_Id__c,
                    Controlling_Interest__c.Parent_Account__c,
                    Controlling_Interest__c.Primary_Entity__c,
                    Controlling_Interest__c.Related_Account__c,
                    Controlling_Interest__c.UBO__c
                };
    }

    /**
    * @description Returns all ControllingInterests by Primary Id
    * @param accId
    * @param ubo
    * @return List<Controlling_Interest__c> 
    */
    public List<Controlling_Interest__c> getByPrimaryAndUBO(String accId, String ubo) {
        return (List<Controlling_Interest__c>) Database.query(
            newQueryFactory().
            selectField('Contact__r.Name').
            setCondition('Primary_Entity__c = :accId AND UBO__c = :ubo').
            toSOQL()
            );
    }
    /**
    * @description getByPrimary
    * @param accId 
    * @return List<Controlling_Interest__c> 
    **/
    public List<Controlling_Interest__c> getByPrimary(String accId) {
        return (List<Controlling_Interest__c>) Database.query(
            newQueryFactory().
            selectField('Contact__r.Name').
            setCondition('Primary_Entity__c = :accId').
            toSOQL()
            );
    }

}