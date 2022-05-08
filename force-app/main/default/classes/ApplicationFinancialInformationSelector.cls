/**
 * Selector Layer for Application_Financial_Information__c object
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-09-20
**/
public class ApplicationFinancialInformationSelector extends fflib_SObjectSelector  {
    public Schema.SObjectType getSObjectType() {
        return Application_Financial_Information__c.sObjectType;
    }

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return new List<Schema.FieldSet>
        { SObjectType.Application_Financial_Information__c.FieldSets.Application_Financial_Info_Compact_View };
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Application_Financial_Information__c.Id,
            Application_Financial_Information__c.Application__c,
            Application_Financial_Information__c.Client_Name__c,
            Application_Financial_Information__c.Client_Code__c,
            Application_Financial_Information__c.Year_Selection__c,
            Application_Financial_Information__c.Financial_Statement_Type__c,
            Application_Financial_Information__c.Statement_Date_Year_end__c,
            Application_Financial_Information__c.Auditor_s_Certificate_Date__c,
            Application_Financial_Information__c.Date_Financials_Signed_Client__c,
            Application_Financial_Information__c.Financial_Statement_Qualified_Issue__c,
            Application_Financial_Information__c.Qualification_Comments__c,
            Application_Financial_Information__c.No_of_Days__c,
            Application_Financial_Information__c.Non_Current_Assets__c,
            Application_Financial_Information__c.Property_Plant_Equipment__c,
            Application_Financial_Information__c.Total_Fixed_Investments_Cash_and_Market__c,
            Application_Financial_Information__c.Intangible_Assets__c,
            Application_Financial_Information__c.Loans_to_Principals_Associates__c,
            Application_Financial_Information__c.Other_Assets__c,
            Application_Financial_Information__c.Other_Assets_Comments__c,
            Application_Financial_Information__c.Total_Current_Assets__c,
            Application_Financial_Information__c.Cash_Marketable_Securities__c,
            Application_Financial_Information__c.Stock__c,
            Application_Financial_Information__c.Trade_Debtors__c,
            Application_Financial_Information__c.Other_Current_Assets__c,
            Application_Financial_Information__c.Other_Current_Assets_Comments__c,
            Application_Financial_Information__c.Total_Assets__c,
            Application_Financial_Information__c.Total_Liabilities__c,
            Application_Financial_Information__c.Shareholders_Funds_Capital_Account__c,
            Application_Financial_Information__c.Revaluation_Of_Assets__c,
            Application_Financial_Information__c.Net_Shareholders_Funds__c,
            Application_Financial_Information__c.Loans_from_Principals_Ceded__c,
            Application_Financial_Information__c.Loans_from_Principals_Non_Ceded__c,
            Application_Financial_Information__c.Loans_from_Associates__c,
            Application_Financial_Information__c.Total_Loans_from_Inside_Parties__c,
            Application_Financial_Information__c.Other_Liabilities__c,
            Application_Financial_Information__c.Other_Liabilities_Comments__c,
            Application_Financial_Information__c.Long_Term_Debt__c,
            Application_Financial_Information__c.Total_Current_Liabilities__c,
            Application_Financial_Information__c.Bank_And_Short_Term_Loans__c,
            Application_Financial_Information__c.Trade_Creditors__c,
            Application_Financial_Information__c.Taxes_PAYE_VAT_Company_Tax__c,
            Application_Financial_Information__c.Other_Current_Liabilities__c,
            Application_Financial_Information__c.Total_Liabilities__c,
            Application_Financial_Information__c.Balance_Sheet_Balanced__c,
            Application_Financial_Information__c.Net_Sales__c,
            Application_Financial_Information__c.Cost_of_Goods_Sold__c,
            Application_Financial_Information__c.Gross_Profit__c,
            Application_Financial_Information__c.Operating_Expenses_Amount__c,
            Application_Financial_Information__c.Depreciation__c,
            Application_Financial_Information__c.Amortisation__c,
            Application_Financial_Information__c.Capital_Ordinary_Credit_Payments__c,
            Application_Financial_Information__c.Capital_Payments_On_Asset_Finance__c,
            Application_Financial_Information__c.Purchase_Capital_Payments_On_Fixed_Prop__c,
            Application_Financial_Information__c.Operating_Expenses_Total__c,
            Application_Financial_Information__c.Other_Expenses__c,
            Application_Financial_Information__c.VAT__c,
            Application_Financial_Information__c.Income_From_Operations__c,
            Application_Financial_Information__c.Extraordinary_Income_e_g_Sale_of_Asset__c,
            Application_Financial_Information__c.Other_Income__c,
            Application_Financial_Information__c.Profit_Before_Interest_And_Tax_EBIT__c,
            Application_Financial_Information__c.Gross_Interest_Expenses__c,
            Application_Financial_Information__c.Interest_Asset_Finance__c,
            Application_Financial_Information__c.Interest_Loans_and_Other_Finance__c,
            Application_Financial_Information__c.Profit_Before_Tax__c,
            Application_Financial_Information__c.Income_Tax__c,
            Application_Financial_Information__c.Net_Profit__c,
            Application_Financial_Information__c.Dividends__c,
            Application_Financial_Information__c.Retained_Earnings_Deficit__c,
            Application_Financial_Information__c.Drawings_Partnerships_Sole_Prop_Only__c,
            Application_Financial_Information__c.Member_s_Shareholders_Emoluments__c,
            Application_Financial_Information__c.Month_with_highest_shortfall__c,
            Application_Financial_Information__c.Highest_Shortfall_Amount__c,
            Application_Financial_Information__c.Month_With_Highest_Debit_Balance__c,
            Application_Financial_Information__c.Highest_Debit_Balance_Amount__c,
            Application_Financial_Information__c.Sales_Growth__c,
            Application_Financial_Information__c.Gross_Profit_Ratio__c,
            Application_Financial_Information__c.Net_Profit__c,
            Application_Financial_Information__c.Current_Ratio__c,
            Application_Financial_Information__c.Acid_Test_Excl_Stock__c,
            Application_Financial_Information__c.Credit_Turnover_Days__c,
            Application_Financial_Information__c.Debtor_Turnover_Days__c,
            Application_Financial_Information__c.Stock_Turnover_Days__c,
            Application_Financial_Information__c.Interest_Cover__c,
            Application_Financial_Information__c.Net_Worth_or_Equity__c,
            Application_Financial_Information__c.Gearing__c,
            Application_Financial_Information__c.Total_Liabilities_Total_Assets__c,
            Application_Financial_Information__c.Net_Current_Assets__c,
            Application_Financial_Information__c.Liquid_Surplus_Variation__c,
            Application_Financial_Information__c.Interest_Bearing_Debt_Equity__c,
            Application_Financial_Information__c.IBD_EBITDA__c,
            Application_Financial_Information__c.Long_Term_Debt_EBITDA__c,
            Application_Financial_Information__c.Interest_Cover_Ratio__c,
            Application_Financial_Information__c.Total_Asset_Turnover__c,
            Application_Financial_Information__c.Operating_Profit_Margin__c,
            Application_Financial_Information__c.Net_Profit_Profit_before_Tax_Net_Sale__c
        };
    }

    public List<Application_Financial_Information__c> selectById(Set<ID> idSet) {
        return (List<Application_Financial_Information__c>) selectSObjectsById(idSet);
    }

    public override String getOrderBy() {
        return 'CreatedDate ASC';
    }

    /**
     * Return Application Financial Information by application code
     *
     * @param String appId from Application_c
     * @return List<Application_Financial_Information__c>
    **/
    public List<Application_Financial_Information__c> selectByApplicationId(String appId) {
        return (List<Application_Financial_Information__c>) Database.query(
            newQueryFactory().
            setCondition('Application__c = :appId').
            toSOQL()
        );
    }

    /**
     *Return Application Financial Information Based on Application Financial Id
     *
     * @param String appFinInfoId
     * @return Application Financial
    **/
    public Application_Financial_Information__c selectApplicationFinancialById(String appFinInfoId) {
        return (Application_Financial_Information__c) Database.query(
            newQueryFactory().
            setCondition('Id = :appFinInfoId').
            toSOQL()
        );
    }
}