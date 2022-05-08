/**
 * @description       : Controller for Financials, Income Statements & Balance Sheets
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-18
 * @last modified by  : Saurabh
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-15   Englarmerdge Mongwe   Initial Version
**/

public class HistoricalFinancialDataController {
	/**
	* @description : Method to get Historical Financial Data
	* @author Englarmerdge Mongwe | 2021-06-15 
	* @param oppID 
	**/
    @Future(Callout=true)
	public static void getHistoricalFianancialData(String oppID) {
        Opportunity opp = new OpportunitiesSelector().selectByOppId(oppID);
        GetBalanceSheet_Resp_IB_v1 balSheetResBean = GetBalanceSheet_IH_v1.getBalanceSheet(opp?.Account.CIF__c);
        GetIncomeStatement_Resp_IB_v1 incStmtResBean = GetIncomeStatement_IH_v1.GetIncomeStatement(opp?.Account.CIF__c);

        if(balSheetResBean?.body?.size() > 0 && incStmtResBean?.body?.size() > 0) {
            List<Financial_Information__c> finInfoList = new List<Financial_Information__c>();
            Financial_Information__c finInfo = new Financial_Information__c();
            finInfo.Account__c = opp?.AccountId;
            finInfo.Auditor_s_Certificate_Date__c = null;
            finInfo.Client_Code__c = opp?.Account.CIF__c;
            finInfo.Client_Name__c = opp?.Account.Name;
            finInfo.Date_Financials_Signed_Client__c = null;
            finInfo.Financial_Statement_Qualified_Issue__c = 'YES';
            finInfo.Financial_Statement_Type__c = 'Audited - Qualified';
            finInfo.Financial_Type__c = 'Full Financial Statement';
            finInfo.No_of_Days__c = 365;
            finInfo.Qualification_Comments__c = '';
            finInfo.Status__c = 'Verified Complete';
            finInfo.Year_Selection__c = 'Forecast';//Changed - earlier value was final
            finInfo.Qualification_Comments__c ='Full Financial Statement';
            finInfo.Statement_Date_Year_end__c = Date.today();
			
            for(GetIncomeStatement_Resp_IB_v1.Body bodyOut : incStmtResBean.body) {
                finInfo.Amortisation__c = (bodyOut.Amortisation != null ? Decimal.valueOf((String)bodyOut.Amortisation) : 0.00);
                finInfo.Capital_Ordinary_Credit_Payments__c = (bodyOut.CapitalOrdinaryCreditPayments != null ? Decimal.valueOf((String)bodyOut.CapitalOrdinaryCreditPayments) : 0.00);
                finInfo.Capital_Payments_On_Asset_Finance__c = (bodyOut.CapitalPaymentsonAssetFinance != null ? Decimal.valueOf((String)bodyOut.CapitalPaymentsonAssetFinance) : 0.00);
                finInfo.Cost_of_Goods_Sold__c = (bodyOut.CostofGoodsSold != null ? Decimal.valueOf((String)bodyOut.CostofGoodsSold) : 0.00);
                //bodyOut.CreatedDate;
                finInfo.Depreciation__c = (bodyOut.Depreciation != null ? Decimal.valueOf((String)bodyOut.Depreciation) : 0.00);
                finInfo.Dividends__c = (bodyOut.Dividends != null ? Decimal.valueOf((String)bodyOut.Dividends) : 0.00);
                finInfo.Drawings_Partnerships_Sole_Prop_Only__c = (bodyOut.Drawings != null ? Decimal.valueOf((String)bodyOut.Drawings) : 0.00);
                finInfo.IBD_EBITDA__c = (bodyOut.EBITDA != null ? Decimal.valueOf((String)bodyOut.EBITDA) : 0.00);
                finInfo.Extraordinary_Income_e_g_Sale_of_Asset__c = (bodyOut.ExtraordinaryIncome != null ? Decimal.valueOf((String)bodyOut.ExtraordinaryIncome) : 0.00);
                //bodyOut.ExtraordinaryIncomeDescription;
                //bodyOut.FinancialBalanceIncomeStatementID;
                //finInfo.Gross_Interest_Expenses__c = (bodyOut.GrossInterestExpenses != null ? Decimal.valueOf((String)bodyOut.GrossInterestExpenses) : 0.00);
                //finInfo.Gross_Profit__c = (bodyOut.GrossProfit != null ? Decimal.valueOf((String)bodyOut.GrossProfit) : 0.00);
                finInfo.Highest_Debit_Balance_Amount__c = (bodyOut.HighestDebitBalanceAmountYear != null ? Decimal.valueOf((String)bodyOut.HighestDebitBalanceAmountYear) : 0.00);
                finInfo.Highest_Shortfall_Amount__c = (bodyOut.HighestShortfallAmountYear != null ? Decimal.valueOf((String)bodyOut.HighestShortfallAmountYear) : 0.00);
                //finInfo.Income_From_Operations__c = (bodyOut.IncomeFromOperations != null ? Decimal.valueOf((String)bodyOut.IncomeFromOperations) : 0.00);
                finInfo.Income_Tax__c = (bodyOut.IncomeTax != null ? Decimal.valueOf((String)bodyOut.IncomeTax) : 0.00);
                finInfo.Interest_Asset_Finance__c = (bodyOut.Interest_AssetFinance != null ? Decimal.valueOf((String)bodyOut.Interest_AssetFinance) : 0.00);
                finInfo.Interest_Bearing_Debt_Equity__c = (bodyOut.Interest_LoansandOtherFinance != null ? Decimal.valueOf((String)bodyOut.Interest_LoansandOtherFinance) : 0.00);
                finInfo.Member_s_Shareholders_Emoluments__c = (bodyOut.MembersorShareholdersEmoluments != null ? Decimal.valueOf((String)bodyOut.MembersorShareholdersEmoluments) : 0.00);
                finInfo.Month_With_Highest_Debit_Balance__c = (bodyOut.MonthwithHighestDebitBalanceYear != null ? (String)bodyOut.MonthwithHighestDebitBalanceYear : '');
                finInfo.Month_with_highest_shortfall__c = (bodyOut.MonthwithHighestShortfallYear != null ? (String)bodyOut.MonthwithHighestShortfallYear : '');
                //finInfo.Net_Profit__c = (bodyOut.NetProfit != null ? Decimal.valueOf((String)bodyOut.NetProfit) : 0.00);
                finInfo.Net_Sales__c = (bodyOut.NetSales != null ? Decimal.valueOf((String)bodyOut.NetSales) : 0.00);
                //finInfo.Operating_Expenses_Total__c = (bodyOut.OperatingExpenses != null ? Decimal.valueOf((String)bodyOut.OperatingExpenses) : 0.00);
                finInfo.Other_Expenses__c = (bodyOut.OtherExpenses != null ? Decimal.valueOf((String)bodyOut.OtherExpenses) : 0.00);
                finInfo.Other_Income__c = (bodyOut.OtherIncome != null ? Decimal.valueOf((String)bodyOut.OtherIncome) : 0.00);
                //finInfo.Profit_Before_Interest_And_Tax_EBIT__c = (bodyOut.ProfitBeforeInterestandTax != null ? Decimal.valueOf((String)bodyOut.ProfitBeforeInterestandTax) : 0.00);
                //finInfo.Profit_Before_Tax__c = (bodyOut.ProfitBeforeTax != null ? Decimal.valueOf((String)bodyOut.ProfitBeforeTax) : 0.00);
                finInfo.Purchase_Capital_Payments_On_Fixed_Prop__c = (bodyOut.PurchaseorCapitalPaymentsonFixedProperty != null ? Decimal.valueOf((String)bodyOut.PurchaseorCapitalPaymentsonFixedProperty) : 0.00);
                //finInfo.Retained_Earnings_Deficit__c = (bodyOut.RetainedEarnings_EndofYear != null ? Decimal.valueOf((String)bodyOut.RetainedEarnings_EndofYear) : 0.00);
                finInfo.Salaries__c = (bodyOut.Salaries != null ? Decimal.valueOf((String)(String)bodyOut.Salaries) : 0.00);
                finInfo.VAT__c = (bodyOut.VAT != null ? Decimal.valueOf((String)(String)bodyOut.VAT) : 0.00);
            }

            for(GetBalanceSheet_Resp_IB_v1.Body bodyOut : balSheetResBean.body) {
                /*////bodyOut.AccountNumber;
                bodyOut.BankOverdraft_Current;
                ////bodyOut.BankOverdraft_CurrentAdjusted;
                ////bodyOut.BankOverdraft_Historical;
                finInfo.Cash_Marketable_Securities__c = (bodyOut.CashInvestments_BranchValuation != null ? Decimal.valueOf((String)(String)bodyOut.CashInvestments_BranchValuation) : 0.00);
                ////bodyOut.CashInvestments_CreditValuation;
                ////bodyOut.CashInvestments_OwnerValuation;
                bodyOut.CashOnHand_BranchValuation;
                ////bodyOut.CashOnHand_CreditValuation;
                ////bodyOut.CashOnHand_OwnerValuation;
                ////bodyOut.CIF_No;
                bodyOut.CreditCards_Current;
                ////bodyOut.CreditCards_CurrentAdjusted;
                ////bodyOut.CreditCards_Historical;
                finInfo.Trade_Creditors__c = bodyOut.Creditors_Current != null ? Decimal.valueOf((String)(String)bodyOut.Creditors_Current) : 0.00);
                ////bodyOut.Creditors_CurrentAdjusted;
                ////bodyOut.Creditors_Historical;
                ////bodyOut.Curreny;
                ////bodyOut.DateOfDeedsOfficeSearch;
                finInfo.Trade_Debtors__c = (bodyOut.Debtors_BranchValuation != null ? Date.valueOf(bodyOut.Debtors_BranchValuation) : null);
                ////bodyOut.Debtors_CreditValuation;
                ////bodyOut.Debtors_OwnerValuation;
                finInfo.Property_Plant_Equipment__c = (bodyOut.EquipmentMachineryImplements_BranchValuation != null ? Date.valueOf(bodyOut.EquipmentMachineryImplements_BranchValuation) : null);
                ////bodyOut.EquipmentMachineryImplements_CreditValuation;
                ////bodyOut.EquipmentMachineryImplements_OwnerValuation;
                ////bodyOut.FinancialCustomerID;
                */
                finInfo.Statement_Date_Year_end__c = (bodyOut.FinancialStatementDate != null ? Date.valueOf(bodyOut.FinancialStatementDate) : Date.today());
                /*
                bodyOut.FixedPropertiesandImprovements_BranchValuation;
                ////bodyOut.FixedPropertiesandImprovements_CreditValuation;
                ////bodyOut.FixedPropertiesandImprovements_OwnerValuation;
                bodyOut.FixedPropertiesBonded_Current;
                ////bodyOut.FixedPropertiesBonded_CurrentAdjusted;
                ////bodyOut.FixedPropertiesBonded_Historical;
                bodyOut.FixedPropertiesInformal_Current;
                ////bodyOut.FixedPropertiesInformal_CurrentAdjusted;
                ////bodyOut.FixedPropertiesInformal_Historical;
                bodyOut.FixedPropertiesUnbonded_Current;
                ////bodyOut.FixedPropertiesUnbonded_CurrentAdjusted;
                ////bodyOut.FixedPropertiesUnbonded_Historical;
                ////bodyOut.ID;
                ////bodyOut.IDRegisrationNo;
                ////bodyOut.IsActive;
                ////bodyOut.IsDeedsOfficeSearchAvailable;
                ////bodyOut.IsOutcomePositive;
                bodyOut.Livestock_BranchValuation;
                ////bodyOut.Livestock_CreditValuation;
                ////bodyOut.Livestock_OwnerValuation;
                bodyOut.LoanAccounts_Current;
                ////bodyOut.LoanAccounts_CurrentAdjusted;
                ////bodyOut.LoanAccounts_Historical;
                bodyOut.LoanAccountsToBusiness_BranchValuation;
                ////bodyOut.LoanAccountsToBusiness_CreditValuation;
                ////bodyOut.LoanAccountsToBusiness_OwnerValuation;
                bodyOut.LocalFinancialInstrumentsListed_BranchValuation;
                ////bodyOut.LocalFinancialInstrumentsListed_CreditValuation;
                ////bodyOut.LocalFinancialInstrumentsListed_OwnerValuation;
                ////bodyOut.ModifyDate;
                bodyOut.MortgageBonds_Current;
                ////bodyOut.MortgageBonds_CurrentAdjusted;
                ////bodyOut.MortgageBonds_Historical;
                bodyOut.MotorVehiclesCaravansBoats_BranchValuation;
                ////bodyOut.MotorVehiclesCaravansBoats_CreditValuation;
                ////bodyOut.MotorVehiclesCaravansBoats_OwnerValuation;
                ////bodyOut.Name;
                bodyOut.NetCapitalofBusiness_BranchValuation;
                ////bodyOut.NetCapitalofBusiness_CreditValuation;
                ////bodyOut.NetCapitalofBusiness_OwnerValuation;
                finInfo.Net_Worth_or_Equity__c = (bodyOut.NetWorth_Current != null ? Decimal.valueOf((String)bodyOut.NetWorth_Current) : 0.00);
                ////bodyOut.NetWorth_CurrentAdjusted;
                ////bodyOut.NetWorth_Historical;
                bodyOut.NotarialBondAmount_Current;
                ////bodyOut.NotarialBondAmount_CurrentAdjusted;
                ////bodyOut.NotarialBondAmount_Historical;
                finInfo.Other_Assets__c = (bodyOut.OtherAssets_BranchValuation != null ? Decimal.valueOf((String)bodyOut.OtherAssets_BranchValuation) : 0.00);
                ////bodyOut.OtherAssets_CreditValuation;
                ////bodyOut.OtherAssets_OwnerValuation;
                finInfo.Other_Current_Liabilities__c = (bodyOut.OtherLiabilities_Current != null ? Decimal.valueOf((String)bodyOut.OtherLiabilities_Current) : 0.00);
                ////bodyOut.OtherLiabilities_CurrentAdjusted;
                ////bodyOut.OtherLiabilities_Historical;
                */
                finInfo.Net_Worth_or_Equity__c = (bodyOut.OwnersNetWorth_Current != null ? Decimal.valueOf((String)bodyOut.OwnersNetWorth_Current) : 0.00);
                /*
                bodyOut.PersonalEffects_BranchValuation;
                ////bodyOut.PersonalEffects_CreditValuation;
                ////bodyOut.PersonalEffects_OwnerValuation;
                finInfo.Shareholders_Funds_Capital_Account__c = (bodyOut.ShareholdersEquity_Current != null ? Decimal.valueOf((String)bodyOut.ShareholdersEquity_Current) : 0.00);
                ////bodyOut.ShareholdersEquity_CurrentAdjusted;
                ////bodyOut.ShareholdersEquity_Historical;
                bodyOut.SharesinPrivateCompanyOrCCInterest_BranchValuation;
                ////bodyOut.SharesinPrivateCompanyOrCCInterest_CreditValuation;
                ////bodyOut.SharesinPrivateCompanyOrCCInterest_OwnerValution;
                */
                finInfo.Stock__c = (bodyOut.Stock_BranchValuation != null ? Decimal.valueOf(bodyOut.TotalAssets_BranchValuation) : 0.00);
                ////bodyOut.Stock_CreditValuation;
                ////bodyOut.Stock_OwnerValuation;
                //finInfo.Total_Assets__c = (bodyOut.TotalAssets_BranchValuation != null ? Decimal.valueOf(bodyOut.TotalAssets_BranchValuation) : 0.00);
                ////bodyOut.TotalAssets_CreditValuation;
                ////bodyOut.TotalAssets_OwnerValuation;
                /*
                bodyOut.TotalBondRegistered_Current;
                ////bodyOut.TotalBondRegistered_CurrentAdjusted;
                ////bodyOut.TotalBondRegistered_Historical;
                bodyOut.TotalForeignAssets_BranchValuation;
                ////bodyOut.TotalForeignAssets_CreditValuation;
                ////bodyOut.TotalForeignAssets_OwnerValuation;
                bodyOut.TotalForeignLiabilities_Current;
                ////bodyOut.TotalForeignLiabilities_CurrentAdjusted;
                ////bodyOut.TotalForeignLiabilities_Historical;
                */
                //finInfo.Total_Current_Liabilities__c = (bodyOut.TotalLiabilities_Current != null ? Decimal.valueOf(bodyOut.TotalLiabilities_Current) : 0.00);
                ////bodyOut.TotalLiabilities_CurrentAdjusted;
                ////bodyOut.TotalLiabilities_Historical;
                //bodyOut.TotalPropertiesBondDetails_Current;
                ////bodyOut.TotalPropertiesBondDetails_CurrentAdjusted;
                ////bodyOut.TotalPropertiesBondDetails_Historical;
            }

            //finInfo.Balance_Sheet_Balanced__c = (finInfo.Total_Assets__c == Total_Liabilities__c ? 'YES' : 'NO');

            /*finInfo.Acid_Test_Excl_Stock__c = '';
            finInfo.Bank_And_Short_Term_Loans__c = '';
            finInfo.Credit_Turnover_Days__c = '';
            finInfo.Current_Ratio__c = '';
            finInfo.Debtor_Turnover_Days__c = '';
            finInfo.Earnings_Before_Interest_Tax_Dep_Amort__c = '';
            finInfo.Gross_Profit_Ratio__c = '';
            finInfo.Intangible_Assets__c = '';
            finInfo.Interest_Cover__c = '';
            finInfo.Interest_Cover_Ratio__c = '';
            finInfo.Interest_Loans_and_Other_Finance__c = '';
            finInfo.Land_Bank__c = '';
            finInfo.Liquid_Surplus_Variation__c = '';
            finInfo.Loans_from_Associates__c = '';
            finInfo.Loans_from_Principals_Ceded__c = '';
            finInfo.Loans_from_Principals_Non_Ceded__c = '';
            finInfo.Loans_to_Principals_Associates__c = '';
            finInfo.Long_Term_Debt__c = '';
            finInfo.Long_Term_Debt_EBITDA__c = '';
            finInfo.Net_Current_Assets__c = '';
            finInfo.Net_Gearing__c = '';
            finInfo.Net_Profit_Profit_before_Tax_Net_Sale__c = '';
            finInfo.Net_Shareholders_Funds__c = '';
            finInfo.Non_Current_Assets__c = '';
            finInfo.Operating_Expenses_Total__c = '';
            finInfo.Operating_Profit_Margin__c = '';
            finInfo.Other_Assets_Comments__c = '';
            finInfo.Other_Current_Assets__c = '';
            finInfo.Other_Current_Assets_Comments__c = '';
            finInfo.Other__c = '';
            finInfo.Revaluation_Of_Assets__c = '';
            finInfo.Sales_Growth__c = '';
            finInfo.Stock_Turnover_Days__c = '';
            finInfo.Taxes_PAYE_VAT_Company_Tax__c = '';
            finInfo.Total_Asset_Turnover__c = '';
            finInfo.Total_Current_Assets__c = '';
            finInfo.Total_Fixed_Investments_Cash_and_Market__c = '';
            finInfo.Total_Liabilities__c = '';
            finInfo.Total_Liabilities_Total_Assets__c = '';
            finInfo.Total_Loans_from_Inside_Parties__c = '';
            */
            finInfoList.add(finInfo);

            try {
                insert finInfoList;
            }
            catch (Exception ex) {
                throw new AuraHandledException('Financial Information Insert failed: ' + ex.getMessage() + ' ' + ex.getStackTraceString());
            }
        }
    }
}