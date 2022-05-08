/**
* Apex Enterprise Design Patterns
* Selector Layer for Integration Service object
*
* @author  Rudolf Niehaus - CloudSmiths
* @since   2018-04-24
*/
public class IntegrationServicesSelector extends fflib_SObjectSelector {

    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
       return Integration_Service__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList(){
        return new List<Schema.SObjectField> {
            Integration_Service__c.Id,
            Integration_Service__c.Name,
            Integration_Service__c.Method__c,
            Integration_Service__c.URL_Extension__c,
            Integration_Service__c.Username__c,
            Integration_Service__c.Password__c,
            Integration_Service__c.Content_Type__c,
            Integration_Service__c.Service_Description__c,
            Integration_Service__c.Integration_API_ID__c
        };
    }
     //INHERIT FROM BASE CLASS - START
    public List<Integration_Service__c> selectById( Set<Id> idSet ) {
        return (List<Integration_Service__c>) selectSObjectsById(idSet);
    }
    //Override default sort order i.e. CreatedDate
    public override String getOrderBy(){
        return 'Name';
    }
    //INHERIT FROM BASE CLASS - STOP

    // PJAIN: 20200708
    public List<Integration_Service__c> selectByNameAndEnvironment(String name, String environment) {

        return Database.query(
            newQueryFactory().
            selectField('Integration_API_ID__r.Environment__c').
            selectField('Integration_API_ID__r.Name').
            selectField('Integration_API_ID__r.Base_URL__c').
            selectField('Integration_API_ID__r.Client_ID__c').
            selectField('Integration_API_ID__r.Client_Secret__c').
            setCondition('Name = :name AND Integration_API_ID__r.Environment__c = :environment').
            toSOQL()
        );
    }
}