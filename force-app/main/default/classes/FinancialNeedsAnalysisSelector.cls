/**
* Apex Enterprise Design Patterns
* Selector Layer for FNA objects
*
* @author  Kyle Alexander
* @version APIv4.3
* @since   2018-08-14
*/

public class FinancialNeedsAnalysisSelector extends fflib_SObjectSelector {
    //MANDATORY ABSTRACT METHODS - START
    public Schema.SObjectType getSObjectType() {
        return Financial_Needs_Analysis__c.sObjectType;
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
                Financial_Needs_Analysis__c.id,
                Financial_Needs_Analysis__c.name
        };
    }
    //MANDATORY ABSTRACT METHODS - END

    //get cases by id's
    public List<Financial_Needs_Analysis__c> selectById(Set<Id> idSet) {
        return (List<Financial_Needs_Analysis__c>) selectSObjectsById(idSet);
    }

    public override String getOrderBy(){
        return 'createdDate DESC';
    }

    //CUSTOM SELECTORS - START

    /**
     * Method that gets all FNA fields from latest FNA ID
     *
     * @return FNA - all FNA fields
     */
    public List<Financial_Needs_Analysis__c> selectLatestById(Id fnaId, Integer recordLimit) {
        return Database.query(
                newQueryFactory().
                        selectField('Assets__c').
                        selectField('Liabilities__c').
                        selectField('Cash__c').
                        selectField('Investment__c').
                        selectField('Fixed_Properties__c').
                        selectField('Life_Policies__c').
                        selectField('Other_Assets__c').
                        selectField('lump_sum_Assets_Capture__c').
                        selectField('Cash_Action__c').
                        selectField('Investment_Action__c').
                        selectField('Fixed_Properties_Action__c').
                        selectField('Life_Policies_Action__c').
                        selectField('Other_Assets_Action__c').
                        selectField('Vehicle_Finances__c').
                        selectField('Credit_Cards__c').
                        selectField('Personal_Loans__c').
                        selectField('Over_Drafts__c').
                        selectField('Mortgages__c').
                        selectField('Other_liabilities__c').
                        selectField('Full_Liquidity__c').
                        setCondition('Id = :fnaId').
                        setLimit(recordLimit).
                        toSOQL()
        );
    }
    //CUSTOM SELECTORS - END
}