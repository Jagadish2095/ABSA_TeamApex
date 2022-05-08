/**
 * Selector class for FinServ__AssetsAndLiabilities__c SObject
 *
 * @author Ephetehe Mokgopanyane (ephetehe.mokgopanyane@tetrad.co.za)
 * @date December 2020
 */
public class FinServAssetsAndLiabilitiesSelector extends fflib_SObjectSelector {
	public Schema.SObjectType getSObjectType() {
        return FinServ__AssetsAndLiabilities__c.sObjectType;
    }

    public List<SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            FinServ__AssetsAndLiabilities__c.Id
        };
    } 

    /**
     * Used to get FinServ__AssetsAndLiabilities__c records by their Ids
     * 
     * @param idSet - Set of Ids
     * 
     * @return List of FinServ__AssetsAndLiabilities__c records
     */
    public List<FinServ__AssetsAndLiabilities__c> selectById(Set<Id> idSet) {
        return (List<FinServ__AssetsAndLiabilities__c>) Database.query(
            newQueryFactory()
            .setCondition('Id IN: idSet')
            .toSOQL()
        );
    }
	
    /**
     * Used to get FinServ__AssetsAndLiabilities__c records by their Account Ids
     * 
     * @param idSetAccount - Set of Account Ids
     * 
     * @return List of FinServ__AssetsAndLiabilities__c records
     */
    public List<FinServ__AssetsAndLiabilities__c> selectAssetsAndLiabilitiesByAccountId(Set<Id> idSetAccount){
        return (List<FinServ__AssetsAndLiabilities__c>) Database.query(
            newQueryFactory()
            .selectField('Id')
            .selectField('Amount_Owners_Valuation__c')
            .selectField('Name')
            .selectField('FinServ__Amount__c')
            .selectField('FinServ__AssetsAndLiabilitiesSource__c')
            .selectField('FinServ__AssetsAndLiabilitiesType__c')
            .selectField('FinServ__Description__c')
            .selectField('FinServ__FinancialAccount__c')
            .selectField('FinServ__Household__c')
            .selectField('FinServ__JointOwner__c')
            .selectField('FinServ__Ownership__c')
            .selectField('FinServ__OwnerType__c')
            .selectField('FinServ__PrimaryOwner__c')
            .selectField('FinServ__SourceSystemId__c')
            .selectField('RecordType.Name')
            .selectField('FinServ__PrimaryOwner__r.As_at_date__c')
            .selectField('FinServ__PrimaryOwner__r.Date_deeds_office_search__c')
            .selectField('FinServ__PrimaryOwner__r.Deeds_office_search_available_Y_N__c')
            .selectField('FinServ__PrimaryOwner__r.Id_Number__pc')
            .selectField('FinServ__PrimaryOwner__r.Name')
            .selectField('FinServ__PrimaryOwner__r.Passport_Number__pc')
            .selectField('FinServ__PrimaryOwner__r.Outcome_positive_Y_N__c')
            .setCondition('FinServ__PrimaryOwner__c IN: idSetAccount AND Is_Application_Asset_Liability__c = true')
            .toSOQL()
        );
    }
}