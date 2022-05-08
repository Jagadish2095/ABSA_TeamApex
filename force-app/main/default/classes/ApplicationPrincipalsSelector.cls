/**
 * Selector Layer for Application_Principal__c object
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-08-27
 **/
public class ApplicationPrincipalsSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return Application_Principal__c.sObjectType;
    }

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet>
        { SObjectType.Application_Principal__c.FieldSets.Application_Principal_Finder_Compact_Vie };
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Principal__c.Id,
            Application_Principal__c.AccConRelId__c,
            Application_Principal__c.Application__c,
            Application_Principal__c.Casa_Reference__c,
            Application_Principal__c.Casa_Result__c,
            Application_Principal__c.CIF__c,
            Application_Principal__c.Controlling_Interest__c,
            Application_Principal__c.Id_Number__c,
            Application_Principal__c.ID_Type__c,
            Application_Principal__c.Is_Part_Of_Application__c,
            Application_Principal__c.Main__c,
            Application_Principal__c.Principal_Shareholder_Name__c
        };
    }

    public List<Application_Principal__c> selectById(Set<ID> idSet) {
        return (List<Application_Principal__c>) selectSObjectsById(idSet);
    }

    public override String getOrderBy() {
        return 'Controlling_Interest__c DESC, Main__c DESC';
    }

    /**
     * Return Application Principal by application id
     *
     * @param String appId from Application_c
     * @return List<Application_Principal__c>
     **/
    public List<Application_Principal__c> selectByApplicationId(String appId) {
        return (List<Application_Principal__c>) Database.query(
            newQueryFactory().
            setCondition('Application__c = :appId AND Is_Part_Of_Application__c = true').
            toSOQL()
        );
    }

    /**
     * Return Application Principal by idSet
     *
     * @param Set<Id> appId from idSet
     * @return List<Application_Principal__c>
     **/
    public List<Application_Principal__c> selectByOpportunityId(Set<Id> idSet){
        return (List<Application_Principal__c>) Database.query(
            newQueryFactory().
            setCondition('Application__r.Opportunity__c IN: idSet').
            toSOQL()
        );
    }

    /**
     * Return Application Principal by idSet
     *
     * @param Set<Id> appId from idSet
     * @return List<Application_Principal__c>
     **/
    public List<Application_Principal__c> selectApplicationPrincipalByOpportunityId(Set<Id> idSet){
        return (List<Application_Principal__c>) Database.query(
            newQueryFactory().
            setCondition('Application__r.Opportunity__c IN: idSet AND Is_Part_Of_Application__c = true').
            toSOQL()
        );
    }

    //Added By Himani Joshi
    public List<Application_Principal__c> getApplicationPrincipals(Id applicationId) {
        return Database.query(
            newQueryFactory()
            .setCondition('Application__c =:applicationId')
            .toSOQL()
        );
    }

    // Getting the Principals which are part of application
    public List<Application_Principal__c> getSelectedApplicationPrincipals(Id applicationId) {
        return Database.query(
            newQueryFactory()
            .setCondition('Application__c =:applicationId AND Is_Part_Of_Application__c = true')
            .toSOQL()
        );
    }
}