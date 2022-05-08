/**
 * Selector Layer for Application_Financial_Info_Relationship__c object
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-09-20
**/
public class ApplicationFinancialInfoRelSelector extends fflib_SObjectSelector {
    public Schema.SObjectType getSObjectType() {
        return Application_Financial_Info_Relationship__c.sObjectType;
    }

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet>
        {SObjectType.Application_Financial_Info_Relationship__c.FieldSets.Application_Financial_Info_Rel_Compact_V};
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Financial_Info_Relationship__c.Id,
            Application_Financial_Info_Relationship__c.ApplicationId__c,
            Application_Financial_Info_Relationship__c.FinancialInfoId__c
        };
    }

    public List<Application_Financial_Info_Relationship__c> selectById(Set<ID> idSet) {
        return (List<Application_Financial_Info_Relationship__c>) selectSObjectsById(idSet);
    }

    public override String getOrderBy() {
        return 'CreatedDate DESC';
    }


    /**
     * Return Application Financial Info Relationship by Applcation Id
     *
     * @param String appId from Application_c
     * @return List<Application_Financial_Info_Relationship__c>
    **/
    public List<Application_Financial_Info_Relationship__c> selectByApplicationId(String appId) {
        return Database.query(
            newQueryFactory().
            setCondition('ApplicationId__c = :appId').
            toSOQL()
        );
    }

    /**
     * Return Application Financial Information by Fin Id
     *
     * @param Set finInfoIds from FinancialInfoId__c
     * @return List<Application_Financial_Info_Relationship__c>
    **/
    public List<Application_Financial_Info_Relationship__c> selectByFinancialInfoIds(Set<Id> finInfoIds) {
        return Database.query(
            newQueryFactory()
            .setCondition('FinancialInfoId__c IN :finInfoIds')
            .toSOQL()
        );
    }
}