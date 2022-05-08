/**
 * Selector class for Application_Assets_and_Liabilities__c SObject
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date September 2020
 */
public class ApplicationAssetsAndLiabilitiesSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return Application_Assets_and_Liabilities__c.sObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Application_Assets_and_Liabilities__c.Id,
            Application_Assets_and_Liabilities__c.RecordType.Name,
            Application_Assets_and_Liabilities__c.Amount__c,
            Application_Assets_and_Liabilities__c.Amount_Owners_Valuation__c,
            Application_Assets_and_Liabilities__c.Application__c,
            Application_Assets_and_Liabilities__c.Primary_Owner__c,
            Application_Assets_and_Liabilities__c.Type__c
        };
    } 

    /**
     * Used to get Application_Assets_and_Liabilities__c records by their Ids
     * 
     * @param idSet - Set of Opportunity Ids
     * 
     * @return List of Application_Assets_and_Liabilities__c records
     */
    public List<Application_Assets_and_Liabilities__c> selectById(Set<Id> idSet) {
        return (List<Application_Assets_and_Liabilities__c>) Database.query(
            newQueryFactory()
            .setCondition('Id IN: idSet')
            .toSOQL()
        );
    }

    /**
     * Used to get Application_Assets_and_Liabilities__c records by their Account Ids
     * 
     * @param idSetAccount - Set of Account Ids
     * @param idSetContact - Set of Contact Ids
     * 
     * @return List of Application_Assets_and_Liabilities__c records
     */
    public List<Application_Assets_and_Liabilities__c> selectByAccountIdApplicationId(Set<Id> idSetAccount, Set<Id> idSetApplication){
        return (List<Application_Assets_and_Liabilities__c>) Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Amount__c')
            .selectField('Amount_Owners_Valuation__c')
            .selectField('Application__c')
            .selectField('LastModifiedDate')
            .selectField('Primary_Owner__c')
            .selectField('Primary_Owner__r.As_at_date__c')
            .selectField('Primary_Owner__r.CIF__c')
            .selectField('Primary_Owner__r.Date_deeds_office_search__c')
            .selectField('Primary_Owner__r.Deeds_office_search_available_Y_N__c')
            .selectField('Primary_Owner__r.Outcome_positive_Y_N__c')
            .selectField('RecordType.Name')
            .selectField('Type__c')
            .setCondition('Primary_Owner__c IN: idSetAccount AND Application__c IN: idSetApplication')
            .toSOQL()
        );
    }
}