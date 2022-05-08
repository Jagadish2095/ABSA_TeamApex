/**
 * @description       : Response Integration Bean for GetIncomeStatement Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-15
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-15   Englarmerdge Mongwe   Initial Version
**/


public class GetIncomeStatement_Resp_IB_v1 extends Base_IB {
    public List<Body> body;
    /**
 * @description       : Inner class with params
 * @author            : Englarmerdge Mongwe
 **/
	public class Body {
		public String Name;
		public String IDRegisrationNo;
		public String CustomerKey;
		public Integer FinancialCustomerID;
		public Integer ID;
		public Object NetSales;
		public Object CostofGoodsSold;
		public Object GrossProfit;
		public Object OperatingExpenses;
		public Object Depreciation;
		public Object Amortisation;
		public Object CapitalOrdinaryCreditPayments;
		public Object CapitalPaymentsonAssetFinance;
		public Object PurchaseorCapitalPaymentsonFixedProperty;
		public Object Salaries;
		public Object OtherExpenses;
		public Object VAT;
		public Object IncomeFromOperations;
		public Object ExtraordinaryIncome;
		public Object OtherIncome;
		public Object ProfitBeforeInterestandTax;
		public Object GrossInterestExpenses;
		public Object Interest_AssetFinance;
		public Object Interest_LoansandOtherFinance;
		public Object ProfitBeforeTax;
		public Object IncomeTax;
		public Object NetProfit;
		public Object Dividends;
		public Object RetainedEarnings_EndofYear;
		public Object Drawings;
		public Object MembersorShareholdersEmoluments;
		public Object HighestShortfallAmountYear;
		public Object HighestDebitBalanceAmountYear;
		public Long CreatedDate;
		public Integer FinancialBalanceIncomeStatementID;
		public Object MonthwithHighestShortfallYear;
		public Object MonthwithHighestDebitBalanceYear;
		public Object ExtraordinaryIncomeDescription;
		public Object EBITDA;
	}
}