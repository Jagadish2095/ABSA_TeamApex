/**
 * Lightning Component Controller for Financial Information for application
 *
 * @author  Englarmerdge Mongwe
 * @since   2020-09-20
**/
public class ApplicationFinancialInformation {

    public class FinancialStatement {
        @auraEnabled public Object SectionItem { get;set; }
        @auraEnabled public Object Forecast { get;set; }
        @auraEnabled public Object Year1 { get;set; }
        @auraEnabled public Object Year2 { get;set; }
        @auraEnabled public Object Year3 { get;set; }
        @auraEnabled public Object IsTotal { get;set; }

        public FinancialStatement() {
            SectionItem = null;
            Forecast = null;
            Year1 = null;
            Year2 = null;
            Year3 = null;
            IsTotal = null;
        }
    }

	@AuraEnabled
	public static Map<String, Object> getFinancialInformation(String accId) {
		Map<String, Object> mapObj = new Map<String, Object>();
		List<Financial_Information__c> appFinInfo = new FinancialInformationSelector().selectByAccountId(accId);
		if (appFinInfo != null & appFinInfo.size() > 0) {
			List<FinancialStatement> finStatList = new List<FinancialStatement>();
			List<FinancialStatement> finStatBalSheetList = new List<FinancialStatement>();
			List<FinancialStatement> finStatIncomeStatList = new List<FinancialStatement>();
			List<FinancialStatement> finStatFinNeedsList = new List<FinancialStatement>();
			List<FinancialStatement> finStatProfRatiosList = new List<FinancialStatement>();
			List<FinancialStatement> finStatOperRatiosList = new List<FinancialStatement>();
			List<FinancialStatement> finStatDebtCapKeyRatioList = new List<FinancialStatement>();
			FinancialStatement finStat;

			//FinStatList
			List<String> finStatSec = finStatSectionList();
			for (Integer i = 0; i < finStatSec.size(); i++) {
				finStat = new FinancialStatement();
				finStat.SectionItem = finStatSec[i];
				finStatList.add(finStat);
			}

			//FinStatBalSheetList
			List<String> finBalSec = finStatBalSheetSectionList();
			for (Integer i = 0; i < finBalSec.size(); i++) {
				finStat = new FinancialStatement();
				finStat.SectionItem = finBalSec[i];
				finStat.IsTotal = (i == 0 || i == 7 || i == 13 || i == 21 || i == 24 || i == 25 || i == 29 ? true : false);
				finStatBalSheetList.add(finStat);
			}

			//FinStatIncomeStatList
			List<String> finIncomSec = finStatIncomeStatSectionList();
			for (Integer i = 0; i < finIncomSec.size(); i++) {
				finStat = new FinancialStatement();
				finStat.SectionItem = finIncomSec[i];
				finStat.IsTotal = (i == 2 || i == 3 || i == 12 || i == 15 || i == 19 || i == 21 ? true : false);
				finStatIncomeStatList.add(finStat);
			}

			//FinStatFinNeedsList
			List<String> finNeedSec = finStatFinNeedsSectionList();
			for (Integer i = 0; i < finNeedSec.size(); i++) {
				finStat = new FinancialStatement();
				finStat.SectionItem = finNeedSec[i];
				finStatFinNeedsList.add(finStat);
			}

			//FinStatProfRatiosList
			List<String> finProfSec = finStatProfRatiosSectionList();
			for (Integer i = 0; i < finProfSec.size(); i++) {
				finStat = new FinancialStatement();
				finStat.SectionItem = finProfSec[i];
				finStatProfRatiosList.add(finStat);
			}

			//FinStatOperRatiosList
			List<String> finOperSec = finStatOperRatiosSectionList();
			for (Integer i = 0; i < finOperSec.size(); i++) {
				finStat = new FinancialStatement();
				finStat.SectionItem = finOperSec[i];
				finStatOperRatiosList.add(finStat);
			}

			//FinStatDebtCapKeyRatioList
			List<String> finDebtSec = finStatDebtCapKeyRatioSectionList();
			for (Integer i = 0; i < finDebtSec.size(); i++) {
				finStat = new FinancialStatement();
				finStat.SectionItem = finDebtSec[i];
				finStatDebtCapKeyRatioList.add(finStat);
			}

			for (Integer idx = 0; idx < appFinInfo.size(); idx++) {
				if (appFinInfo[idx].Year_Selection__c == 'Forecast') {
					//FinStatList
					finStatList[0].Forecast = appFinInfo[idx].Financial_Statement_Type__c;
					finStatList[1].Forecast = appFinInfo[idx].Statement_Date_Year_end__c.year();
					finStatList[2].Forecast = appFinInfo[idx].Auditor_s_Certificate_Date__c;
					finStatList[3].Forecast = appFinInfo[idx].Date_Financials_Signed_Client__c;
					finStatList[4].Forecast = appFinInfo[idx].Financial_Statement_Qualified_Issue__c;
					finStatList[5].Forecast = appFinInfo[idx].Qualification_Comments__c;
					finStatList[6].Forecast = appFinInfo[idx].No_of_Days__c;

					//FinStatBalSheetList
					finStatBalSheetList[0].Forecast = 'R ' + appFinInfo[idx].Non_Current_Assets__c;
					finStatBalSheetList[1].Forecast = 'R ' + appFinInfo[idx].Property_Plant_Equipment__c;
					finStatBalSheetList[2].Forecast = 'R ' + appFinInfo[idx].Total_Fixed_Investments_Cash_and_Market__c;
					finStatBalSheetList[3].Forecast = 'R ' + appFinInfo[idx].Intangible_Assets__c;
					finStatBalSheetList[4].Forecast = 'R ' + appFinInfo[idx].Loans_to_Principals_Associates__c;
					finStatBalSheetList[5].Forecast = 'R ' + appFinInfo[idx].Other_Assets__c;
					finStatBalSheetList[6].Forecast = appFinInfo[idx].Other_Assets_Comments__c;
					finStatBalSheetList[7].Forecast = 'R ' + appFinInfo[idx].Total_Current_Assets__c;
					finStatBalSheetList[8].Forecast = 'R ' + appFinInfo[idx].Cash_Marketable_Securities__c;
					finStatBalSheetList[9].Forecast = 'R ' + appFinInfo[idx].Stock__c;
					finStatBalSheetList[10].Forecast = 'R ' + appFinInfo[idx].Trade_Debtors__c;
					finStatBalSheetList[11].Forecast = 'R ' + appFinInfo[idx].Other_Current_Assets__c;
					finStatBalSheetList[12].Forecast = appFinInfo[idx].Other_Current_Assets_Comments__c;
					finStatBalSheetList[13].Forecast = 'R ' + appFinInfo[idx].Total_Assets__c;
					finStatBalSheetList[14].Forecast = 'R ' + appFinInfo[idx].Shareholders_Funds_Capital_Account__c;
					finStatBalSheetList[15].Forecast = 'R ' + appFinInfo[idx].Revaluation_Of_Assets__c;
					finStatBalSheetList[16].Forecast = 'R ' + appFinInfo[idx].Net_Shareholders_Funds__c;
					finStatBalSheetList[17].Forecast = 'R ' + appFinInfo[idx].Loans_from_Principals_Ceded__c;
					finStatBalSheetList[18].Forecast = 'R ' + appFinInfo[idx].Loans_from_Principals_Non_Ceded__c;
					finStatBalSheetList[19].Forecast = 'R ' + appFinInfo[idx].Loans_from_Associates__c;
					finStatBalSheetList[20].Forecast = 'R ' + appFinInfo[idx].Total_Loans_from_Inside_Parties__c;
					finStatBalSheetList[21].Forecast = 'R ' + appFinInfo[idx].Land_Bank__c;
					finStatBalSheetList[22].Forecast = 'R ' + appFinInfo[idx].Other__c;
					finStatBalSheetList[23].Forecast = 'R ' + appFinInfo[idx].Long_Term_Debt__c;
					finStatBalSheetList[24].Forecast = 'R ' + appFinInfo[idx].Total_Current_Liabilities__c;
					finStatBalSheetList[25].Forecast = 'R ' + appFinInfo[idx].Bank_And_Short_Term_Loans__c;
					finStatBalSheetList[26].Forecast = 'R ' + appFinInfo[idx].Trade_Creditors__c;
					finStatBalSheetList[27].Forecast = 'R ' + appFinInfo[idx].Taxes_PAYE_VAT_Company_Tax__c;
					finStatBalSheetList[28].Forecast = 'R ' + appFinInfo[idx].Other_Current_Liabilities__c;
					finStatBalSheetList[29].Forecast = 'R ' + appFinInfo[idx].Total_Liabilities__c;
					finStatBalSheetList[30].Forecast = appFinInfo[idx].Balance_Sheet_Balanced__c;

					//finStatIncomeStatList
					finStatIncomeStatList[0].Forecast = 'R ' + appFinInfo[idx].Net_Sales__c;
					finStatIncomeStatList[1].Forecast = 'R ' + appFinInfo[idx].Cost_of_Goods_Sold__c;
					finStatIncomeStatList[2].Forecast = 'R ' + appFinInfo[idx].Gross_Profit__c;
					finStatIncomeStatList[3].Forecast = 'R ' + appFinInfo[idx].Salaries__c;
					finStatIncomeStatList[4].Forecast = 'R ' + appFinInfo[idx].Depreciation__c;
					finStatIncomeStatList[5].Forecast = 'R ' + appFinInfo[idx].Amortisation__c;
					finStatIncomeStatList[6].Forecast = 'R ' + appFinInfo[idx].Capital_Ordinary_Credit_Payments__c;
					finStatIncomeStatList[7].Forecast = 'R ' + appFinInfo[idx].Capital_Payments_On_Asset_Finance__c;
					finStatIncomeStatList[8].Forecast = 'R ' + appFinInfo[idx].Purchase_Capital_Payments_On_Fixed_Prop__c;
					finStatIncomeStatList[9].Forecast = 'R ' + appFinInfo[idx].Operating_Expenses_Total__c;
					finStatIncomeStatList[10].Forecast = 'R ' + appFinInfo[idx].Other_Expenses__c;
					finStatIncomeStatList[11].Forecast = 'R ' + appFinInfo[idx].VAT__c;
					finStatIncomeStatList[12].Forecast = 'R ' + appFinInfo[idx].Income_From_Operations__c;
					finStatIncomeStatList[13].Forecast = 'R ' + appFinInfo[idx].Extraordinary_Income_e_g_Sale_of_Asset__c;
					finStatIncomeStatList[14].Forecast = 'R ' + appFinInfo[idx].Other_Income__c;
					finStatIncomeStatList[15].Forecast = 'R ' + appFinInfo[idx].Profit_Before_Interest_And_Tax_EBIT__c;
					finStatIncomeStatList[16].Forecast = 'R ' + appFinInfo[idx].Gross_Interest_Expenses__c;
					finStatIncomeStatList[17].Forecast = 'R ' + appFinInfo[idx].Interest_Asset_Finance__c;
					finStatIncomeStatList[18].Forecast = 'R ' + appFinInfo[idx].Interest_Loans_and_Other_Finance__c;
					finStatIncomeStatList[19].Forecast = 'R ' + appFinInfo[idx].Profit_Before_Tax__c;
					finStatIncomeStatList[20].Forecast = 'R ' + appFinInfo[idx].Income_Tax__c;
					finStatIncomeStatList[21].Forecast = 'R ' + appFinInfo[idx].Net_Profit__c;
					finStatIncomeStatList[22].Forecast = 'R ' + appFinInfo[idx].Dividends__c;
					finStatIncomeStatList[23].Forecast = 'R ' + appFinInfo[idx].Retained_Earnings_Deficit__c;
					finStatIncomeStatList[24].Forecast = 'R ' + appFinInfo[idx].Drawings_Partnerships_Sole_Prop_Only__c;
					finStatIncomeStatList[25].Forecast = 'R ' + appFinInfo[idx].Member_s_Shareholders_Emoluments__c;

					//finStatFinNeedsList
					finStatFinNeedsList[0].Forecast = appFinInfo[idx].Month_with_highest_shortfall__c;
					finStatFinNeedsList[1].Forecast = 'R ' + appFinInfo[idx].Highest_Shortfall_Amount__c;
					finStatFinNeedsList[2].Forecast = appFinInfo[idx].Month_With_Highest_Debit_Balance__c;
					finStatFinNeedsList[3].Forecast = 'R ' + appFinInfo[idx].Highest_Debit_Balance_Amount__c;

					//finStatProfRatiosList
					finStatProfRatiosList[0].Forecast = appFinInfo[idx].Sales_Growth__c;
					finStatProfRatiosList[1].Forecast = appFinInfo[idx].Gross_Profit_Ratio__c;
					finStatProfRatiosList[2].Forecast = appFinInfo[idx].Net_Profit_Profit_before_Tax_Net_Sale__c;

					//finStatOperRatiosList
					finStatOperRatiosList[0].Forecast = appFinInfo[idx].Current_Ratio__c;
					finStatOperRatiosList[1].Forecast = appFinInfo[idx].Acid_Test_Excl_Stock__c;
					finStatOperRatiosList[2].Forecast = appFinInfo[idx].Credit_Turnover_Days__c;
					finStatOperRatiosList[3].Forecast = appFinInfo[idx].Debtor_Turnover_Days__c;
					finStatOperRatiosList[4].Forecast = appFinInfo[idx].Stock_Turnover_Days__c;
					finStatOperRatiosList[5].Forecast = appFinInfo[idx].Interest_Cover__c;
					finStatOperRatiosList[6].Forecast = appFinInfo[idx].Net_Worth_or_Equity__c;
					finStatOperRatiosList[7].Forecast = appFinInfo[idx].Net_Gearing__c;
					finStatOperRatiosList[8].Forecast = appFinInfo[idx].Total_Liabilities_Total_Assets__c;
					finStatOperRatiosList[9].Forecast = 'R ' + appFinInfo[idx].Net_Current_Assets__c;
					finStatOperRatiosList[10].Forecast = 'R ' + appFinInfo[idx].Liquid_Surplus_Variation__c;

					//finStatDebtCapKeyRatioList
					finStatDebtCapKeyRatioList[0].Forecast = 'R ' + appFinInfo[idx].Interest_Bearing_Debt_Equity__c;
					finStatDebtCapKeyRatioList[1].Forecast = 'R ' + appFinInfo[idx].IBD_EBITDA__c;
					finStatDebtCapKeyRatioList[2].Forecast = appFinInfo[idx].Long_Term_Debt_EBITDA__c;
					finStatDebtCapKeyRatioList[3].Forecast = appFinInfo[idx].Interest_Cover_Ratio__c;
					finStatDebtCapKeyRatioList[4].Forecast = appFinInfo[idx].Total_Asset_Turnover__c;
					finStatDebtCapKeyRatioList[5].Forecast = appFinInfo[idx].Operating_Profit_Margin__c;
				}

				if (appFinInfo[idx].Year_Selection__c == 'Year1') {
					finStatList[0].Year1 = appFinInfo[idx].Financial_Statement_Type__c;
					finStatList[1].Year1 = appFinInfo[idx].Statement_Date_Year_end__c.year();
					finStatList[2].Year1 = appFinInfo[idx].Auditor_s_Certificate_Date__c;
					finStatList[3].Year1 = appFinInfo[idx].Date_Financials_Signed_Client__c;
					finStatList[4].Year1 = appFinInfo[idx].Financial_Statement_Qualified_Issue__c;
					finStatList[5].Year1 = appFinInfo[idx].Qualification_Comments__c;
					finStatList[6].Year1 = appFinInfo[idx].No_of_Days__c;

					//FinStatBalSheetList
					finStatBalSheetList[0].Year1 = 'R ' + appFinInfo[idx].Non_Current_Assets__c;
					finStatBalSheetList[1].Year1 = 'R ' + appFinInfo[idx].Property_Plant_Equipment__c;
					finStatBalSheetList[2].Year1 = 'R ' + appFinInfo[idx].Total_Fixed_Investments_Cash_and_Market__c;
					finStatBalSheetList[3].Year1 = 'R ' + appFinInfo[idx].Intangible_Assets__c;
					finStatBalSheetList[4].Year1 = 'R ' + appFinInfo[idx].Loans_to_Principals_Associates__c;
					finStatBalSheetList[5].Year1 = 'R ' + appFinInfo[idx].Other_Assets__c;
					finStatBalSheetList[6].Year1 = appFinInfo[idx].Other_Assets_Comments__c;
					finStatBalSheetList[7].Year1 = 'R ' + appFinInfo[idx].Total_Current_Assets__c;
					finStatBalSheetList[8].Year1 = 'R ' + appFinInfo[idx].Cash_Marketable_Securities__c;
					finStatBalSheetList[9].Year1 = 'R ' + appFinInfo[idx].Stock__c;
					finStatBalSheetList[10].Year1 = 'R ' + appFinInfo[idx].Trade_Debtors__c;
					finStatBalSheetList[11].Year1 = 'R ' + appFinInfo[idx].Other_Current_Assets__c;
					finStatBalSheetList[12].Year1 = appFinInfo[idx].Other_Current_Assets_Comments__c;
					finStatBalSheetList[13].Year1 = 'R ' + appFinInfo[idx].Total_Assets__c;
					finStatBalSheetList[14].Year1 = 'R ' + appFinInfo[idx].Shareholders_Funds_Capital_Account__c;
					finStatBalSheetList[15].Year1 = 'R ' + appFinInfo[idx].Revaluation_Of_Assets__c;
					finStatBalSheetList[16].Year1 = 'R ' + appFinInfo[idx].Net_Shareholders_Funds__c;
					finStatBalSheetList[17].Year1 = 'R ' + appFinInfo[idx].Loans_from_Principals_Ceded__c;
					finStatBalSheetList[18].Year1 = 'R ' + appFinInfo[idx].Loans_from_Principals_Non_Ceded__c;
					finStatBalSheetList[19].Year1 = 'R ' + appFinInfo[idx].Loans_from_Associates__c;
					finStatBalSheetList[20].Year1 = 'R ' + appFinInfo[idx].Total_Loans_from_Inside_Parties__c;
					finStatBalSheetList[21].Year1 = 'R ' + appFinInfo[idx].Land_Bank__c;
					finStatBalSheetList[22].Year1 = 'R ' + appFinInfo[idx].Other__c;
					finStatBalSheetList[23].Year1 = 'R ' + appFinInfo[idx].Long_Term_Debt__c;
					finStatBalSheetList[24].Year1 = 'R ' + appFinInfo[idx].Total_Current_Liabilities__c;
					finStatBalSheetList[25].Year1 = 'R ' + appFinInfo[idx].Bank_And_Short_Term_Loans__c;
					finStatBalSheetList[26].Year1 = 'R ' + appFinInfo[idx].Trade_Creditors__c;
					finStatBalSheetList[27].Year1 = 'R ' + appFinInfo[idx].Taxes_PAYE_VAT_Company_Tax__c;
					finStatBalSheetList[28].Year1 = 'R ' + appFinInfo[idx].Other_Current_Liabilities__c;
					finStatBalSheetList[29].Year1 = 'R ' + appFinInfo[idx].Total_Liabilities__c;
					finStatBalSheetList[30].Year1 = appFinInfo[idx].Balance_Sheet_Balanced__c;

					//finStatIncomeStatList
					finStatIncomeStatList[0].Year1 = 'R ' + appFinInfo[idx].Net_Sales__c;
					finStatIncomeStatList[1].Year1 = 'R ' + appFinInfo[idx].Cost_of_Goods_Sold__c;
					finStatIncomeStatList[2].Year1 = 'R ' + appFinInfo[idx].Gross_Profit__c;
					finStatIncomeStatList[3].Year1 = 'R ' + appFinInfo[idx].Salaries__c;
					finStatIncomeStatList[4].Year1 = 'R ' + appFinInfo[idx].Depreciation__c;
					finStatIncomeStatList[5].Year1 = 'R ' + appFinInfo[idx].Amortisation__c;
					finStatIncomeStatList[6].Year1 = 'R ' + appFinInfo[idx].Capital_Ordinary_Credit_Payments__c;
					finStatIncomeStatList[7].Year1 = 'R ' + appFinInfo[idx].Capital_Payments_On_Asset_Finance__c;
					finStatIncomeStatList[8].Year1 = 'R ' + appFinInfo[idx].Purchase_Capital_Payments_On_Fixed_Prop__c;
					finStatIncomeStatList[9].Year1 = 'R ' + appFinInfo[idx].Operating_Expenses_Total__c;
					finStatIncomeStatList[10].Year1 = 'R ' + appFinInfo[idx].Other_Expenses__c;
					finStatIncomeStatList[11].Year1 = 'R ' + appFinInfo[idx].VAT__c;
					finStatIncomeStatList[12].Year1 = 'R ' + appFinInfo[idx].Income_From_Operations__c;
					finStatIncomeStatList[13].Year1 = 'R ' + appFinInfo[idx].Extraordinary_Income_e_g_Sale_of_Asset__c;
					finStatIncomeStatList[14].Year1 = 'R ' + appFinInfo[idx].Other_Income__c;
					finStatIncomeStatList[15].Year1 = 'R ' + appFinInfo[idx].Profit_Before_Interest_And_Tax_EBIT__c;
					finStatIncomeStatList[16].Year1 = 'R ' + appFinInfo[idx].Gross_Interest_Expenses__c;
					finStatIncomeStatList[17].Year1 = 'R ' + appFinInfo[idx].Interest_Asset_Finance__c;
					finStatIncomeStatList[18].Year1 = 'R ' + appFinInfo[idx].Interest_Loans_and_Other_Finance__c;
					finStatIncomeStatList[19].Year1 = 'R ' + appFinInfo[idx].Profit_Before_Tax__c;
					finStatIncomeStatList[20].Year1 = 'R ' + appFinInfo[idx].Income_Tax__c;
					finStatIncomeStatList[21].Year1 = 'R ' + appFinInfo[idx].Net_Profit__c;
					finStatIncomeStatList[22].Year1 = 'R ' + appFinInfo[idx].Dividends__c;
					finStatIncomeStatList[23].Year1 = 'R ' + appFinInfo[idx].Retained_Earnings_Deficit__c;
					finStatIncomeStatList[24].Year1 = 'R ' + appFinInfo[idx].Drawings_Partnerships_Sole_Prop_Only__c;
					finStatIncomeStatList[25].Year1 = 'R ' + appFinInfo[idx].Member_s_Shareholders_Emoluments__c;

					//finStatFinNeedsList
					finStatFinNeedsList[0].Year1 = appFinInfo[idx].Month_with_highest_shortfall__c;
					finStatFinNeedsList[1].Year1 = 'R ' + appFinInfo[idx].Highest_Shortfall_Amount__c;
					finStatFinNeedsList[2].Year1 = appFinInfo[idx].Month_With_Highest_Debit_Balance__c;
					finStatFinNeedsList[3].Year1 = 'R ' + appFinInfo[idx].Highest_Debit_Balance_Amount__c;

					//finStatProfRatiosList
					finStatProfRatiosList[0].Year1 = appFinInfo[idx].Sales_Growth__c;
					finStatProfRatiosList[1].Year1 = appFinInfo[idx].Gross_Profit_Ratio__c;
					finStatProfRatiosList[2].Year1 = appFinInfo[idx].Net_Profit_Profit_before_Tax_Net_Sale__c;

					//finStatOperRatiosList
					finStatOperRatiosList[0].Year1 = appFinInfo[idx].Current_Ratio__c;
					finStatOperRatiosList[1].Year1 = appFinInfo[idx].Acid_Test_Excl_Stock__c;
					finStatOperRatiosList[2].Year1 = appFinInfo[idx].Credit_Turnover_Days__c;
					finStatOperRatiosList[3].Year1 = appFinInfo[idx].Debtor_Turnover_Days__c;
					finStatOperRatiosList[4].Year1 = appFinInfo[idx].Stock_Turnover_Days__c;
					finStatOperRatiosList[5].Year1 = appFinInfo[idx].Interest_Cover__c;
					finStatOperRatiosList[6].Year1 = appFinInfo[idx].Net_Worth_or_Equity__c;
					finStatOperRatiosList[7].Year1 = appFinInfo[idx].Net_Gearing__c;
					finStatOperRatiosList[8].Year1 = appFinInfo[idx].Total_Liabilities_Total_Assets__c;
					finStatOperRatiosList[9].Year1 = 'R ' + appFinInfo[idx].Net_Current_Assets__c;
					finStatOperRatiosList[10].Year1 = 'R ' + appFinInfo[idx].Liquid_Surplus_Variation__c;

					//finStatDebtCapKeyRatioList
					finStatDebtCapKeyRatioList[0].Year1 = 'R ' + appFinInfo[idx].Interest_Bearing_Debt_Equity__c;
					finStatDebtCapKeyRatioList[1].Year1 = 'R ' + appFinInfo[idx].IBD_EBITDA__c;
					finStatDebtCapKeyRatioList[2].Year1 = appFinInfo[idx].Long_Term_Debt_EBITDA__c;
					finStatDebtCapKeyRatioList[3].Year1 = appFinInfo[idx].Interest_Cover_Ratio__c;
					finStatDebtCapKeyRatioList[4].Year1 = appFinInfo[idx].Total_Asset_Turnover__c;
					finStatDebtCapKeyRatioList[5].Year1 = appFinInfo[idx].Operating_Profit_Margin__c;
				}

				if (appFinInfo[idx].Year_Selection__c == 'Year2') {
					finStatList[0].Year2 = appFinInfo[idx].Financial_Statement_Type__c;
					finStatList[1].Year2 = appFinInfo[idx].Statement_Date_Year_end__c.year();
					finStatList[2].Year2 = appFinInfo[idx].Auditor_s_Certificate_Date__c;
					finStatList[3].Year2 = appFinInfo[idx].Date_Financials_Signed_Client__c;
					finStatList[4].Year2 = appFinInfo[idx].Financial_Statement_Qualified_Issue__c;
					finStatList[5].Year2 = appFinInfo[idx].Qualification_Comments__c;
					finStatList[6].Year2 = appFinInfo[idx].No_of_Days__c;

					//FinStatBalSheetList
					finStatBalSheetList[0].Year2 = 'R ' + appFinInfo[idx].Non_Current_Assets__c;
					finStatBalSheetList[1].Year2 = 'R ' + appFinInfo[idx].Property_Plant_Equipment__c;
					finStatBalSheetList[2].Year2 = 'R ' + appFinInfo[idx].Total_Fixed_Investments_Cash_and_Market__c;
					finStatBalSheetList[3].Year2 = 'R ' + appFinInfo[idx].Intangible_Assets__c;
					finStatBalSheetList[4].Year2 = 'R ' + appFinInfo[idx].Loans_to_Principals_Associates__c;
					finStatBalSheetList[5].Year2 = 'R ' + appFinInfo[idx].Other_Assets__c;
					finStatBalSheetList[6].Year2 = appFinInfo[idx].Other_Assets_Comments__c;
					finStatBalSheetList[7].Year2 = 'R ' + appFinInfo[idx].Total_Current_Assets__c;
					finStatBalSheetList[8].Year2 = 'R ' + appFinInfo[idx].Cash_Marketable_Securities__c;
					finStatBalSheetList[9].Year2 = 'R ' + appFinInfo[idx].Stock__c;
					finStatBalSheetList[10].Year2 = 'R ' + appFinInfo[idx].Trade_Debtors__c;
					finStatBalSheetList[11].Year2 = 'R ' + appFinInfo[idx].Other_Current_Assets__c;
					finStatBalSheetList[12].Year2 = appFinInfo[idx].Other_Current_Assets_Comments__c;
					finStatBalSheetList[13].Year2 = 'R ' + appFinInfo[idx].Total_Assets__c;
					finStatBalSheetList[14].Year2 = 'R ' + appFinInfo[idx].Shareholders_Funds_Capital_Account__c;
					finStatBalSheetList[15].Year2 = 'R ' + appFinInfo[idx].Revaluation_Of_Assets__c;
					finStatBalSheetList[16].Year2 = 'R ' + appFinInfo[idx].Net_Shareholders_Funds__c;
					finStatBalSheetList[17].Year2 = 'R ' + appFinInfo[idx].Loans_from_Principals_Ceded__c;
					finStatBalSheetList[18].Year2 = 'R ' + appFinInfo[idx].Loans_from_Principals_Non_Ceded__c;
					finStatBalSheetList[19].Year2 = 'R ' + appFinInfo[idx].Loans_from_Associates__c;
					finStatBalSheetList[20].Year2 = 'R ' + appFinInfo[idx].Total_Loans_from_Inside_Parties__c;
					finStatBalSheetList[21].Year2 = 'R ' + appFinInfo[idx].Land_Bank__c;
					finStatBalSheetList[22].Year2 = 'R ' + appFinInfo[idx].Other__c;
					finStatBalSheetList[23].Year2 = 'R ' + appFinInfo[idx].Long_Term_Debt__c;
					finStatBalSheetList[24].Year2 = 'R ' + appFinInfo[idx].Total_Current_Liabilities__c;
					finStatBalSheetList[25].Year2 = 'R ' + appFinInfo[idx].Bank_And_Short_Term_Loans__c;
					finStatBalSheetList[26].Year2 = 'R ' + appFinInfo[idx].Trade_Creditors__c;
					finStatBalSheetList[27].Year2 = 'R ' + appFinInfo[idx].Taxes_PAYE_VAT_Company_Tax__c;
					finStatBalSheetList[28].Year2 = 'R ' + appFinInfo[idx].Other_Current_Liabilities__c;
					finStatBalSheetList[29].Year2 = 'R ' + appFinInfo[idx].Total_Liabilities__c;
					finStatBalSheetList[30].Year2 = appFinInfo[idx].Balance_Sheet_Balanced__c;

					//finStatIncomeStatList
					finStatIncomeStatList[0].Year2 = 'R ' + appFinInfo[idx].Net_Sales__c;
					finStatIncomeStatList[1].Year2 = 'R ' + appFinInfo[idx].Cost_of_Goods_Sold__c;
					finStatIncomeStatList[2].Year2 = 'R ' + appFinInfo[idx].Gross_Profit__c;
					finStatIncomeStatList[3].Year2 = 'R ' + appFinInfo[idx].Salaries__c;
					finStatIncomeStatList[4].Year2 = 'R ' + appFinInfo[idx].Depreciation__c;
					finStatIncomeStatList[5].Year2 = 'R ' + appFinInfo[idx].Amortisation__c;
					finStatIncomeStatList[6].Year2 = 'R ' + appFinInfo[idx].Capital_Ordinary_Credit_Payments__c;
					finStatIncomeStatList[7].Year2 = 'R ' + appFinInfo[idx].Capital_Payments_On_Asset_Finance__c;
					finStatIncomeStatList[8].Year2 = 'R ' + appFinInfo[idx].Purchase_Capital_Payments_On_Fixed_Prop__c;
					finStatIncomeStatList[9].Year2 = 'R ' + appFinInfo[idx].Operating_Expenses_Total__c;
					finStatIncomeStatList[10].Year2 = 'R ' + appFinInfo[idx].Other_Expenses__c;
					finStatIncomeStatList[11].Year2 = 'R ' + appFinInfo[idx].VAT__c;
					finStatIncomeStatList[12].Year2 = 'R ' + appFinInfo[idx].Income_From_Operations__c;
					finStatIncomeStatList[13].Year2 = 'R ' + appFinInfo[idx].Extraordinary_Income_e_g_Sale_of_Asset__c;
					finStatIncomeStatList[14].Year2 = 'R ' + appFinInfo[idx].Other_Income__c;
					finStatIncomeStatList[15].Year2 = 'R ' + appFinInfo[idx].Profit_Before_Interest_And_Tax_EBIT__c;
					finStatIncomeStatList[16].Year2 = 'R ' + appFinInfo[idx].Gross_Interest_Expenses__c;
					finStatIncomeStatList[17].Year2 = 'R ' + appFinInfo[idx].Interest_Asset_Finance__c;
					finStatIncomeStatList[18].Year2 = 'R ' + appFinInfo[idx].Interest_Loans_and_Other_Finance__c;
					finStatIncomeStatList[19].Year2 = 'R ' + appFinInfo[idx].Profit_Before_Tax__c;
					finStatIncomeStatList[20].Year2 = 'R ' + appFinInfo[idx].Income_Tax__c;
					finStatIncomeStatList[21].Year2 = 'R ' + appFinInfo[idx].Net_Profit__c;
					finStatIncomeStatList[22].Year2 = 'R ' + appFinInfo[idx].Dividends__c;
					finStatIncomeStatList[23].Year2 = 'R ' + appFinInfo[idx].Retained_Earnings_Deficit__c;
					finStatIncomeStatList[24].Year2 = 'R ' + appFinInfo[idx].Drawings_Partnerships_Sole_Prop_Only__c;
					finStatIncomeStatList[25].Year2 = 'R ' + appFinInfo[idx].Member_s_Shareholders_Emoluments__c;

					//finStatFinNeedsList
					finStatFinNeedsList[0].Year2 = appFinInfo[idx].Month_with_highest_shortfall__c;
					finStatFinNeedsList[1].Year2 = 'R ' + appFinInfo[idx].Highest_Shortfall_Amount__c;
					finStatFinNeedsList[2].Year2 = appFinInfo[idx].Month_With_Highest_Debit_Balance__c;
					finStatFinNeedsList[3].Year2 = 'R ' + appFinInfo[idx].Highest_Debit_Balance_Amount__c;

					//finStatProfRatiosList
					finStatProfRatiosList[0].Year2 = appFinInfo[idx].Sales_Growth__c;
					finStatProfRatiosList[1].Year2 = appFinInfo[idx].Gross_Profit_Ratio__c;
					finStatProfRatiosList[2].Year2 = appFinInfo[idx].Net_Profit_Profit_before_Tax_Net_Sale__c;

					//finStatOperRatiosList
					finStatOperRatiosList[0].Year2 = appFinInfo[idx].Current_Ratio__c;
					finStatOperRatiosList[1].Year2 = appFinInfo[idx].Acid_Test_Excl_Stock__c;
					finStatOperRatiosList[2].Year2 = appFinInfo[idx].Credit_Turnover_Days__c;
					finStatOperRatiosList[3].Year2 = appFinInfo[idx].Debtor_Turnover_Days__c;
					finStatOperRatiosList[4].Year2 = appFinInfo[idx].Stock_Turnover_Days__c;
					finStatOperRatiosList[5].Year2 = appFinInfo[idx].Interest_Cover__c;
					finStatOperRatiosList[7].Year2 = appFinInfo[idx].Net_Gearing__c;
					finStatOperRatiosList[6].Year2 = appFinInfo[idx].Net_Worth_or_Equity__c;
					finStatOperRatiosList[8].Year2 = appFinInfo[idx].Total_Liabilities_Total_Assets__c;
					finStatOperRatiosList[9].Year2 = 'R ' + appFinInfo[idx].Net_Current_Assets__c;
					finStatOperRatiosList[10].Year2 = 'R ' + appFinInfo[idx].Liquid_Surplus_Variation__c;

					//finStatDebtCapKeyRatioList
					finStatDebtCapKeyRatioList[0].Year2 = 'R ' + appFinInfo[idx].Interest_Bearing_Debt_Equity__c;
					finStatDebtCapKeyRatioList[1].Year2 = 'R ' + appFinInfo[idx].IBD_EBITDA__c;
					finStatDebtCapKeyRatioList[2].Year2 = appFinInfo[idx].Long_Term_Debt_EBITDA__c;
					finStatDebtCapKeyRatioList[3].Year2 = appFinInfo[idx].Interest_Cover_Ratio__c;
					finStatDebtCapKeyRatioList[4].Year2 = appFinInfo[idx].Total_Asset_Turnover__c;
					finStatDebtCapKeyRatioList[5].Year2 = appFinInfo[idx].Operating_Profit_Margin__c;
				}

				if (appFinInfo[idx].Year_Selection__c == 'Year3') {
					finStatList[0].Year3 = appFinInfo[idx].Financial_Statement_Type__c;
					finStatList[1].Year3 = appFinInfo[idx].Statement_Date_Year_end__c.year();
					finStatList[2].Year3 = appFinInfo[idx].Auditor_s_Certificate_Date__c;
					finStatList[3].Year3 = appFinInfo[idx].Date_Financials_Signed_Client__c;
					finStatList[4].Year3 = appFinInfo[idx].Financial_Statement_Qualified_Issue__c;
					finStatList[5].Year3 = appFinInfo[idx].Qualification_Comments__c;
					finStatList[6].Year3 = appFinInfo[idx].No_of_Days__c;

					//FinStatBalSheetList
					finStatBalSheetList[0].Year3 = 'R ' + appFinInfo[idx].Non_Current_Assets__c;
					finStatBalSheetList[1].Year3 = 'R ' + appFinInfo[idx].Property_Plant_Equipment__c;
					finStatBalSheetList[2].Year3 = 'R ' + appFinInfo[idx].Total_Fixed_Investments_Cash_and_Market__c;
					finStatBalSheetList[3].Year3 = 'R ' + appFinInfo[idx].Intangible_Assets__c;
					finStatBalSheetList[4].Year3 = 'R ' + appFinInfo[idx].Loans_to_Principals_Associates__c;
					finStatBalSheetList[5].Year3 = 'R ' + appFinInfo[idx].Other_Assets__c;
					finStatBalSheetList[6].Year3 = appFinInfo[idx].Other_Assets_Comments__c;
					finStatBalSheetList[7].Year3 = 'R ' + appFinInfo[idx].Total_Current_Assets__c;
					finStatBalSheetList[8].Year3 = 'R ' + appFinInfo[idx].Cash_Marketable_Securities__c;
					finStatBalSheetList[9].Year3 = 'R ' + appFinInfo[idx].Stock__c;
					finStatBalSheetList[10].Year3 = 'R ' + appFinInfo[idx].Trade_Debtors__c;
					finStatBalSheetList[11].Year3 = 'R ' + appFinInfo[idx].Other_Current_Assets__c;
					finStatBalSheetList[12].Year3 = appFinInfo[idx].Other_Current_Assets_Comments__c;
					finStatBalSheetList[13].Year3 = 'R ' + appFinInfo[idx].Total_Assets__c;
					finStatBalSheetList[14].Year3 = 'R ' + appFinInfo[idx].Shareholders_Funds_Capital_Account__c;
					finStatBalSheetList[15].Year3 = 'R ' + appFinInfo[idx].Revaluation_Of_Assets__c;
					finStatBalSheetList[16].Year3 = 'R ' + appFinInfo[idx].Net_Shareholders_Funds__c;
					finStatBalSheetList[17].Year3 = 'R ' + appFinInfo[idx].Loans_from_Principals_Ceded__c;
					finStatBalSheetList[18].Year3 = 'R ' + appFinInfo[idx].Loans_from_Principals_Non_Ceded__c;
					finStatBalSheetList[19].Year3 = 'R ' + appFinInfo[idx].Loans_from_Associates__c;
					finStatBalSheetList[20].Year3 = 'R ' + appFinInfo[idx].Total_Loans_from_Inside_Parties__c;
					finStatBalSheetList[21].Year3 = 'R ' + appFinInfo[idx].Land_Bank__c;
					finStatBalSheetList[22].Year3 = 'R ' + appFinInfo[idx].Other__c;
					finStatBalSheetList[23].Year3 = 'R ' + appFinInfo[idx].Long_Term_Debt__c;
					finStatBalSheetList[24].Year3 = 'R ' + appFinInfo[idx].Total_Current_Liabilities__c;
					finStatBalSheetList[25].Year3 = 'R ' + appFinInfo[idx].Bank_And_Short_Term_Loans__c;
					finStatBalSheetList[26].Year3 = 'R ' + appFinInfo[idx].Trade_Creditors__c;
					finStatBalSheetList[27].Year3 = 'R ' + appFinInfo[idx].Taxes_PAYE_VAT_Company_Tax__c;
					finStatBalSheetList[28].Year3 = 'R ' + appFinInfo[idx].Other_Current_Liabilities__c;
					finStatBalSheetList[29].Year3 = 'R ' + appFinInfo[idx].Total_Liabilities__c;
					finStatBalSheetList[30].Year3 = appFinInfo[idx].Balance_Sheet_Balanced__c;

					//finStatIncomeStatList
					finStatIncomeStatList[0].Year3 = 'R ' + appFinInfo[idx].Net_Sales__c;
					finStatIncomeStatList[1].Year3 = 'R ' + appFinInfo[idx].Cost_of_Goods_Sold__c;
					finStatIncomeStatList[2].Year3 = 'R ' + appFinInfo[idx].Gross_Profit__c;
					finStatIncomeStatList[3].Year3 = 'R ' + appFinInfo[idx].Salaries__c;
					finStatIncomeStatList[4].Year3 = 'R ' + appFinInfo[idx].Depreciation__c;
					finStatIncomeStatList[5].Year3 = 'R ' + appFinInfo[idx].Amortisation__c;
					finStatIncomeStatList[6].Year3 = 'R ' + appFinInfo[idx].Capital_Ordinary_Credit_Payments__c;
					finStatIncomeStatList[7].Year3 = 'R ' + appFinInfo[idx].Capital_Payments_On_Asset_Finance__c;
					finStatIncomeStatList[8].Year3 = 'R ' + appFinInfo[idx].Purchase_Capital_Payments_On_Fixed_Prop__c;
					finStatIncomeStatList[9].Year3 = 'R ' + appFinInfo[idx].Operating_Expenses_Total__c;
					finStatIncomeStatList[10].Year3 = 'R ' + appFinInfo[idx].Other_Expenses__c;
					finStatIncomeStatList[11].Year3 = 'R ' + appFinInfo[idx].VAT__c;
					finStatIncomeStatList[12].Year3 = 'R ' + appFinInfo[idx].Income_From_Operations__c;
					finStatIncomeStatList[13].Year3 = 'R ' + appFinInfo[idx].Extraordinary_Income_e_g_Sale_of_Asset__c;
					finStatIncomeStatList[14].Year3 = 'R ' + appFinInfo[idx].Other_Income__c;
					finStatIncomeStatList[15].Year3 = 'R ' + appFinInfo[idx].Profit_Before_Interest_And_Tax_EBIT__c;
					finStatIncomeStatList[16].Year3 = 'R ' + appFinInfo[idx].Gross_Interest_Expenses__c;
					finStatIncomeStatList[17].Year3 = 'R ' + appFinInfo[idx].Interest_Asset_Finance__c;
					finStatIncomeStatList[18].Year3 = 'R ' + appFinInfo[idx].Interest_Loans_and_Other_Finance__c;
					finStatIncomeStatList[19].Year3 = 'R ' + appFinInfo[idx].Profit_Before_Tax__c;
					finStatIncomeStatList[20].Year3 = 'R ' + appFinInfo[idx].Income_Tax__c;
					finStatIncomeStatList[21].Year3 = 'R ' + appFinInfo[idx].Net_Profit__c;
					finStatIncomeStatList[22].Year3 = 'R ' + appFinInfo[idx].Dividends__c;
					finStatIncomeStatList[23].Year3 = 'R ' + appFinInfo[idx].Retained_Earnings_Deficit__c;
					finStatIncomeStatList[24].Year3 = 'R ' + appFinInfo[idx].Drawings_Partnerships_Sole_Prop_Only__c;
					finStatIncomeStatList[25].Year3 = 'R ' + appFinInfo[idx].Member_s_Shareholders_Emoluments__c;

					//finStatFinNeedsList
					finStatFinNeedsList[0].Year3 = appFinInfo[idx].Month_with_highest_shortfall__c;
					finStatFinNeedsList[1].Year3 = 'R ' + appFinInfo[idx].Highest_Shortfall_Amount__c;
					finStatFinNeedsList[2].Year3 = appFinInfo[idx].Month_With_Highest_Debit_Balance__c;
					finStatFinNeedsList[3].Year3 = 'R ' + appFinInfo[idx].Highest_Debit_Balance_Amount__c;

					//finStatProfRatiosList
					finStatProfRatiosList[0].Year3 = appFinInfo[idx].Sales_Growth__c;
					finStatProfRatiosList[1].Year3 = appFinInfo[idx].Gross_Profit_Ratio__c;
					finStatProfRatiosList[2].Year3 = appFinInfo[idx].Net_Profit_Profit_before_Tax_Net_Sale__c;

					//finStatOperRatiosList
					finStatOperRatiosList[0].Year3 = appFinInfo[idx].Current_Ratio__c;
					finStatOperRatiosList[1].Year3 = appFinInfo[idx].Acid_Test_Excl_Stock__c;
					finStatOperRatiosList[2].Year3 = appFinInfo[idx].Credit_Turnover_Days__c;
					finStatOperRatiosList[3].Year3 = appFinInfo[idx].Debtor_Turnover_Days__c;
					finStatOperRatiosList[4].Year3 = appFinInfo[idx].Stock_Turnover_Days__c;
					finStatOperRatiosList[5].Year3 = appFinInfo[idx].Interest_Cover__c;
					finStatOperRatiosList[6].Year3 = appFinInfo[idx].Net_Worth_or_Equity__c;
					finStatOperRatiosList[7].Year3 = appFinInfo[idx].Net_Gearing__c;
					finStatOperRatiosList[8].Year3 = appFinInfo[idx].Total_Liabilities_Total_Assets__c;
					finStatOperRatiosList[9].Year3 = 'R ' + appFinInfo[idx].Net_Current_Assets__c;
					finStatOperRatiosList[10].Year3 = 'R ' + appFinInfo[idx].Liquid_Surplus_Variation__c;

					//finStatDebtCapKeyRatioList
					finStatDebtCapKeyRatioList[0].Year3 = 'R ' + appFinInfo[idx].Interest_Bearing_Debt_Equity__c;
					finStatDebtCapKeyRatioList[1].Year3 = 'R ' + appFinInfo[idx].IBD_EBITDA__c;
					finStatDebtCapKeyRatioList[2].Year3 = appFinInfo[idx].Long_Term_Debt_EBITDA__c;
					finStatDebtCapKeyRatioList[3].Year3 = appFinInfo[idx].Interest_Cover_Ratio__c;
					finStatDebtCapKeyRatioList[4].Year3 = appFinInfo[idx].Total_Asset_Turnover__c;
					finStatDebtCapKeyRatioList[5].Year3 = appFinInfo[idx].Operating_Profit_Margin__c;
				}
			}

			mapObj.put('FinStatList', finStatList);
			mapObj.put('FinStatBalSheetList', finStatBalSheetList);
			mapObj.put('FinStatIncomeStatList', finStatIncomeStatList);
			mapObj.put('FinStatFinNeedsList', finStatFinNeedsList);
			mapObj.put('FinStatProfRatiosList', finStatProfRatiosList);
			mapObj.put('FinStatOperRatiosList', finStatOperRatiosList);
			mapObj.put('FinStatDebtCapKeyRatioList', finStatDebtCapKeyRatioList);

			return mapObj;
		}
		return null;
	}

	@AuraEnabled
	public static Map<String, Object> getApplicationClientDetails(String finRecId, String accId) {
		Map<String, Object> mapDet = new Map<String, Object>();
		accId = (accId == null ? (new FinancialInformationSelector().selectApplicationFinancialById(finRecId)).Account__c : accId);
		Account acc = new AccountsSelector().selectByAccountId(accId,1);
		List<Financial_Information__c> appFinInfo = new FinancialInformationSelector().selectByAccountId(accId);

		if (acc != null) {
			mapDet.put('recordAccId', acc.Id);
			mapDet.put('recordClientName', acc.Name);

			if (appFinInfo?.size() > 0) {
				for (Integer idx = 0; idx < appFinInfo.size(); idx++) {
					if (appFinInfo[idx].Year_Selection__c == 'Year1') {
						mapDet.put('recordYear1NetSales', (appFinInfo[idx].Net_Sales__c == null ? 0.00 :appFinInfo[idx].Net_Sales__c));
						mapDet.put('recordYear1NetCurAssets', (appFinInfo[idx].Net_Current_Assets__c == null ? 0.00 :appFinInfo[idx].Net_Current_Assets__c));
						break;
					}
				}
				for (Integer idx = 0; idx < appFinInfo.size(); idx++) {
					if (appFinInfo[idx].Year_Selection__c == 'Year2') {
						mapDet.put('recordYear2NetSales', (appFinInfo[idx].Net_Sales__c == null ? 0.00 :appFinInfo[idx].Net_Sales__c));
						mapDet.put('recordYear2NetCurAssets', (appFinInfo[idx].Net_Current_Assets__c == null ? 0.00 :appFinInfo[idx].Net_Current_Assets__c));
						break;
					}
				}
				for (Integer idx = 0; idx < appFinInfo.size(); idx++) {
					if (appFinInfo[idx].Year_Selection__c == 'Year3') {
						mapDet.put('recordYear3NetSales', (appFinInfo[idx].Net_Sales__c == null ? 0.00 :appFinInfo[idx].Net_Sales__c));
						mapDet.put('recordYear3NetCurAssets', (appFinInfo[idx].Net_Current_Assets__c == null ? 0.00 :appFinInfo[idx].Net_Current_Assets__c));
						break;
					}
				}
			}
			return mapDet;
		}
		return null;
	}

	@AuraEnabled
	public static List<Id> getApplicationFinancialsDocuments(String recordAccId) {
        List<ContentDocument> CDList = new List<ContentDocument>();
        Set<Id> ContentDocumentset = new Set<Id>();
        List<Id> idlist = new List<Id>();

        if(recordAccId != null) {
           	List<ContentDocumentLink> cdllist = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordAccId];
            for(ContentDocumentLink cdlink:cdllist) {
                ContentDocumentset.add(cdlink.ContentDocumentId);
            }
            CDList = [SELECT id FROM ContentDocument WHERE Id IN:ContentDocumentset];
            for(ContentDocument sdd: CDList){
                idlist.add(sdd.Id);
            }
			return idlist;
        }

       return null;
	}

    //## Added for W-008188
    @AuraEnabled
    public static Account getAccClientType(Id acntId) {
        return new AccountsSelector().selectFinancialStatementRedirectFieldsById(acntId);
    }

    //## Added for W-008188
    @AuraEnabled
    public static List<Financial_Information__c> getFinancialByAccountId(Id acntId) {
        return new FinancialInformationSelector().selectByAccountId(acntId);
    }

	//## Added for W-008188
	@AuraEnabled
	public static void createCaseforCreditSupportConsultant(Id acntId) {
		ApplicationFinancialsUploadController.createCaseforCreditSupportConsultant(acntId);
	}

    private static List<String> finStatSectionList() {
        return (new List<String>{
                                'Financial Statement Type',
                                'Statement Date (Year-end)',
                                'Auditor\'s certificate date',
                                'Date Financials Signed (Client)',
                                'Financial statement qualified (Issue)',
                                'Qualification Comments',
                                'No Of Days'
                            }
                );
    }

    private static List<String> finStatBalSheetSectionList() {
        return (new List<String>{
                                'Non-Current Assets',
                                'Property, Plant & Equipment',
                                'Total Fixed Investments (Cash and Marketable Securities)',
                                'Intangible Assets (Goodwill, patents, etc.)',
                                'Loans To Principals / Associates',
                                'Other Assets ',
                                'Other Assets Comments (specify.....e.g. Deferred expenses, breeding stock )',
                                'Total Current Assets',
                                'Cash & Marketable Securities (Included above)',
                                'Stock (included above)',
                                'Trade Debtors (Included above)',
                                'Other Current Assets',
                                'Other Current Assets Comments (specify….)',
                                'Total Assets',
                                'Shareholders Funds / Capital Account (includes Intangibles but excluding Revaluation of Assets)',
                                'Revaluation Of  Assets (Postive or negative)',
                                'Net Shareholders Funds (including Revaluation of Assets and excluding Intangibles)',
                                'Loans From Principals Ceded (Director Loans included in shareholders funds)',
                                'Loans From Principals Non-Ceded (Director Loans)',
                                'Loans From Associates',
                                'Total Loans from Inside Parties',
                                'Land Bank',
                                'Other',
                                'Long Term Debt',
                                'Total Current Liabilities',
                                'Bank And Short Term Loans (included above)',
                                'Trade Creditors (included above)',
                                'Taxes (PAYE, VAT, Company Tax) included above',
                                'Other Current Liabilities',
                                'Total Liabilities',
                                'Balance Sheet Balanced'}
                );
    }

    private static List<String> finStatIncomeStatSectionList() {
        return (new List<String>{
                                'Net Sales',
                                'Cost Of Goods Sold',
                                'Gross Profit',
                                'Operating Expenses',
                                'Depreciation',
                                'Amortisation',
                                'Capital Ordinary Credit Payments',
                                'Capital Payments On Asset Finance',
                                'Purchase/Capital Payments On Fixed Property',
                                'Salaries',
                                'Other Expenses',
                                'VAT',
                                'Income From Operations',
                                'Extraordinary Income (e.g. Sale of Assets)',
                                'Other Income (specify e.g. Interest, etc......)',
                                'Profit Before Interest And Tax (EBIT)',
                                'Gross Interest Expenses',
                                'Interest - Asset Finance (Included above)',
                                'Interest - Loans And Other Finance (Included above)',
                                'Profit Before Tax',
                                'Income Tax',
                                'Net Profit',
                                'Dividends',
                                'Retained Earnings (Deficit) - End of Year c/f to BS',
                                'Drawings (Partnerships & Sole Proprietors only)',
                                'Member\'s/Shareholders Emoluments'
                                }
                );
    }

    private static List<String> finStatFinNeedsSectionList() {
        return (new List<String>{
                                'Month With Highest Shortfall',
                                'Highest Shortfall Amount',
                                'Month With highest Debit Balance',
                                'Highest Debit Balance Amount'}
                );
    }

    private static List<String> finStatProfRatiosSectionList() {
        return (new List<String>{
                                'Sales Growth %',
                                'Gross Profit %',
                                'Net Profit % (Profit before Tax/Net Sales %)'}
                );
    }

    private static List<String> finStatOperRatiosSectionList() {
        return (new List<String>{
                                'Current Ratio',
                                'Acid Test (Excl Stock)',
                                'Credit Turnover (Days)',
                                'Debtor Turnover (Days)',
                                'Stock Turnover (Days)',
                                'Interest Cover',
                                'Net Worth (or Equity)',
                                'Net Gearing',
                                'Total Liabilities/Total Assets (Excl Net Worth)',
                                'Net Current Assets',
                                'Liquid Surplus Variation'}
                );
    }

    private static List<String> finStatDebtCapKeyRatioSectionList() {
        return (new List<String>{
                                '1. Interest Bearing Debt / Equity',
                                '2. IBD / EBITDA',
                                '3. Long Term Debt/EBITDA',
                                '4. Interest Cover Ratio ("ICR")  (EBIT / Int Paid)',
                                '5. Total Asset Turnover',
                                '6. Operating Profit Margin'}
                );
    }
}