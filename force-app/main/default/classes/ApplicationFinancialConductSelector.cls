/**
 * Selector Layer for Application_Financial_Conduct__c object
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-08-26
**/
public class ApplicationFinancialConductSelector extends fflib_SObjectSelector {

    public Schema.SObjectType getSObjectType() {
        return Application_Financial_Conduct__c.sObjectType;
    }

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet>
        { SObjectType.Application_Financial_Conduct__c.FieldSets.Application_Finder_Compact_View };
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Financial_Conduct__c.Id,
            Application_Financial_Conduct__c.Account_Name_Number__c,
            Application_Financial_Conduct__c.Amount_Last_Credit__c,
            Application_Financial_Conduct__c.Amount_Of_Last_Debit__c,
            Application_Financial_Conduct__c.Application__c,
            Application_Financial_Conduct__c.Balance__c,
            Application_Financial_Conduct__c.Cheque_Product_Type__c,
            Application_Financial_Conduct__c.Conduct_Type__c,
            Application_Financial_Conduct__c.Current_Credit_T_O__c,
            Application_Financial_Conduct__c.Current_Highest_Balance__c,
            Application_Financial_Conduct__c.Current_Lowest_Balance__c,
            Application_Financial_Conduct__c.Date_Last_Overdraft_Captured__c,
            Application_Financial_Conduct__c.Date_Last_Within_Limit__c,
            Application_Financial_Conduct__c.Date_LST_Within_Limit__c,
            Application_Financial_Conduct__c.Date_Of_Last_Credit__c,
            Application_Financial_Conduct__c.Date_Of_Last_Debit__c,
            Application_Financial_Conduct__c.Date_Of_Last_RD__c,
            Application_Financial_Conduct__c.Date_Opened__c,
            Application_Financial_Conduct__c.Days_Since_Last_Credit_Date__c,
            Application_Financial_Conduct__c.Excess_Amount__c,
            Application_Financial_Conduct__c.Expiry_Date__c,
            Application_Financial_Conduct__c.Once_Off_Reduce_Amount__c,
            Application_Financial_Conduct__c.Once_Off_Reduce_Date__c,
            Application_Financial_Conduct__c.Overdraft_Type__c,
            Application_Financial_Conduct__c.Payment_Date__c,
            Application_Financial_Conduct__c.Previous_Credit_T_O__c,
            Application_Financial_Conduct__c.Previous_Highest_Balance__c,
            Application_Financial_Conduct__c.Previous_Lowest_Balance__c,
            Application_Financial_Conduct__c.RD_CHQS_Current_Month__c,
            Application_Financial_Conduct__c.RD_CHQS_Current_Year__c,
            Application_Financial_Conduct__c.RD_CHQS_Previous_Year__c,
            Application_Financial_Conduct__c.RD_Days_12_Months__c,
            Application_Financial_Conduct__c.Reduction_Amount__c,
            Application_Financial_Conduct__c.Unauth_OD_12_Months__c,
            Application_Financial_Conduct__c.Year_Before_Last_T_O__c
        };
    }

    public List<Application_Financial_Conduct__c> selectById(Set<ID> idSet) {
        return (List<Application_Financial_Conduct__c>) selectSObjectsById(idSet);
    }

    public override String getOrderBy() {
        return 'CreatedDate ASC, Name';
    }

    /**
     * Return Application Financial Conduct by application code
     *
     * @param String appId from Application_c
     * @return List<Application_Financial_Conduct__c>
    **/
    public List<Application_Financial_Conduct__c> selectByApplicationId(Id appId) {
        return (List<Application_Financial_Conduct__c>) Database.query(
            newQueryFactory().selectField('Id').
            setCondition('Application__c = :appId').
            toSOQL()
        );
    }

    /**
     *Return Application Financial Based on Application Financial Id
     *
     * @param String appFinConId
     * @return Application Financial
    **/
    public Application_Financial_Conduct__c selectApplicationFinancialById(Id appFinConId) {
        return (Application_Financial_Conduct__c) Database.query(
            newQueryFactory().
            setCondition('Id =: appFinConId').
            toSOQL()
        );
    }

    /**
     *Return Application Financial Based on Account Number
     *
     * @param Id appId from Application_c
     * @param String appFinConAcc
     * @return Application Financial
    **/
    public Application_Financial_Conduct__c selectApplicationFinancialByAccount(Id appId, Set<String> appFinConAcc) {
        return (Application_Financial_Conduct__c) Database.query(
            newQueryFactory().
            setCondition('Application__c = :appId AND Account_Name_Number__c in :appFinConAcc').
            toSOQL()
        );
    }
}