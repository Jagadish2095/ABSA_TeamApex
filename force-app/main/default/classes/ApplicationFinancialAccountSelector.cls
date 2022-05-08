/**
 * @description Selector Layer for Application_Financial_Account__c object
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-08-17
**/
public class ApplicationFinancialAccountSelector extends fflib_SObjectSelector {
/**
 * @description getSObjectType description
 *
 * @return Schema.SObjectType: Return description
 */
    public Schema.SObjectType getSObjectType() {
        return Application_Financial_Account__c.sObjectType;
    }

    /**
     * @description getSObjectFieldSetList description
     *
     * @return overrideList<Schema.FieldSet>: Return description
     */
    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet>
        { SObjectType.Application_Financial_Account__c.FieldSets.Application_Finder_Compact_View };
    }

    /**
     * @description getSObjectFieldList description
     *
     * @return List<Schema.SObjectField>: Return description
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Financial_Account__c.Id,
            Application_Financial_Account__c.Application__c,
            Application_Financial_Account__c.External_Banking_Relationship__c,
            Application_Financial_Account__c.Account_Limit__c,
            Application_Financial_Account__c.Arrears_Amount__c,
            Application_Financial_Account__c.Expiry_Date__c,
            Application_Financial_Account__c.Term_Of_Finance__c,
            Application_Financial_Account__c.Institution_Name__c,
            Application_Financial_Account__c.Other_Bank_Name__c,
            Application_Financial_Account__c.Overdraft_Limit__c,
            Application_Financial_Account__c.Current_Balance__c,
            Application_Financial_Account__c.Maximum_Overdraft_Limit__c,
            Application_Financial_Account__c.Balance__c,
            Application_Financial_Account__c.Maximum_Debit_Balance__c,
            Application_Financial_Account__c.Account_Number__c,
            Application_Financial_Account__c.Reduction_Amount__c,
            Application_Financial_Account__c.Reduction_Frequency__c,
            Application_Financial_Account__c.Monthly_Reduction__c,
            Application_Financial_Account__c.Turnover_For_The_Period__c,
            Application_Financial_Account__c.Period_Of_The_Bank_Statement_s__c,
            Application_Financial_Account__c.Number_Of_Returned_Items__c,
            Application_Financial_Account__c.Credit_Card_Limit__c,
            Application_Financial_Account__c.Monthly_Repayment__c,
            Application_Financial_Account__c.Outstanding_Balance__c,
            Application_Financial_Account__c.Instalment__c,
            Application_Financial_Account__c.Repayment_Frequency__c,
            Application_Financial_Account__c.Repayment_Amount__c,
            Application_Financial_Account__c.Last_Payment_Date__c,
            Application_Financial_Account__c.Creditor_Name__c,
            Application_Financial_Account__c.Monthly_Interest_And_Dividends_Earned__c,
            Application_Financial_Account__c.Monthly_Interest_Earned__c,
            Application_Financial_Account__c.Application_Product_CPF__c,
            Application_Financial_Account__c.Recalculate__c
        };
    }

    /**
     * @description selectByIdSet description
     *
     * @param idSet (Set<ID>): idSet
     * @return List<Application_Financial_Account__c>: Return description
     */
    public List<Application_Financial_Account__c> selectByIdSet(Set<ID> idSet) {
        return (List<Application_Financial_Account__c>) selectSObjectsById(idSet);
    }

    /**
     * @description getOrderBy description
     *
     * @return overrideString: Return description
     */
    public override String getOrderBy() {
        return 'CreatedDate ASC';
    }

    /**
     * @description Return Application Financial Accounts by application code
     *
     * @param appId : appId from Application_c
     * @return List<Application_Financial_Account__c>
    **/
    public List<Application_Financial_Account__c> selectByApplicationId(String appId) {
        return (List<Application_Financial_Account__c>) Database.query(
            newQueryFactory().selectField('Id').
            selectField('External_Banking_Relationship__c').
            selectField('Institution_Name__c').
            selectField('Account_Limit__c').
            selectField('Arrears_Amount__c').
            selectField('Expiry_Date__c').
            selectField('Term_Of_Finance__c').
            selectField('Other_Bank_Name__c').
            selectField('Overdraft_Limit__c').
            selectField('Current_Balance__c').
            selectField('Maximum_Overdraft_Limit__c').
            selectField('Balance__c').
            selectField('Maximum_Debit_Balance__c').
            selectField('Account_Number__c').
            selectField('Reduction_Amount__c').
            selectField('Reduction_Frequency__c').
            selectField('Monthly_Reduction__c').
            selectField('Turnover_For_The_Period__c').
            selectField('Period_Of_The_Bank_Statement_s__c').
            selectField('Number_Of_Returned_Items__c').
            selectField('Credit_Card_Limit__c').
            selectField('Monthly_Repayment__c').
            selectField('Outstanding_Balance__c').
            selectField('Instalment__c').
            selectField('Repayment_Frequency__c').
            selectField('Repayment_Amount__c').
            selectField('Last_Payment_Date__c').
            selectField('Creditor_Name__c').
            selectField('Monthly_Interest_And_Dividends_Earned__c').
            selectField('Monthly_Interest_Earned__c').
            selectField('Recalculate__c').
            setCondition('Application__c = :appId').
            toSOQL()
        );
    }
        /**
     * @description Return Application Financial Accounts by application code and External_Banking_Relationship__c
     *
     * @param appId : from Application_c
     * @param EBR : from Application_c
     * @return List<Application_Financial_Account__c>
    **/
    public List<Application_Financial_Account__c> selectByApplicationIdEBR(String appId, String EBR) {
        return (List<Application_Financial_Account__c>) Database.query(
            newQueryFactory().selectField('Id').
            selectField('External_Banking_Relationship__c').
            selectField('Institution_Name__c').
            selectField('Account_Limit__c').
            selectField('Arrears_Amount__c').
            selectField('Expiry_Date__c').
            selectField('Term_Of_Finance__c').
            selectField('Other_Bank_Name__c').
            selectField('Overdraft_Limit__c').
            selectField('Current_Balance__c').
            selectField('Maximum_Overdraft_Limit__c').
            selectField('Balance__c').
            selectField('Maximum_Debit_Balance__c').
            selectField('Account_Number__c').
            selectField('Reduction_Amount__c').
            selectField('Reduction_Frequency__c').
            selectField('Monthly_Reduction__c').
            selectField('Turnover_For_The_Period__c').
            selectField('Period_Of_The_Bank_Statement_s__c').
            selectField('Number_Of_Returned_Items__c').
            selectField('Credit_Card_Limit__c').
            selectField('Monthly_Repayment__c').
            selectField('Outstanding_Balance__c').
            selectField('Instalment__c').
            selectField('Repayment_Frequency__c').
            selectField('Repayment_Amount__c').
            selectField('Last_Payment_Date__c').
            selectField('Creditor_Name__c').
            selectField('Monthly_Interest_And_Dividends_Earned__c').
            selectField('Monthly_Interest_Earned__c').
            selectField('Recalculate__c').
            setCondition('Application__c = :appId AND External_Banking_Relationship__c = :EBR').
            toSOQL()
        );
    }

    /**
     * @description Return Application Financial Account Based on Application Financial Id
     *
     * @param appFinId
     * @return Application_Financial_Account__c
    **/
    public Application_Financial_Account__c selectApplicationFinancialById(String appFinId) {
        return (Application_Financial_Account__c) Database.query(
            newQueryFactory().
            setCondition('Id = :appFinId').
            toSOQL()
        );
    }

    /**
     * @description Added by Haritha- Method to retrieve Application_Product_CPF__c records based on an Appliaction Id
     *
     * @param AppPrdctId
     *
     * @return  List<Application_Financial_Account__c>
     */
    public  List<Application_Financial_Account__c> selectByAppPrdctId(Id AppPrdctId) {

        return Database.query(
            newQueryFactory().
            selectField('Id').
            selectField('Name').
            selectField('Existing_Number__c').
            selectField('Application_Product_CPF__c').
            selectField('Outstanding_Balance__c').
            selectField('Account_to_be_closed__c').
            selectField('Balance_as_at__c').
            selectField('Existing_Account_Number__c').
            selectField('Phase_Number__c').
            setCondition('Application_Product_CPF__c =: AppPrdctId').
            toSOQL()
        );
    }
}