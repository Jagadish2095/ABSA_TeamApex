/**
 * @description       : Response Integration Bean for GetBalanceSheet Service
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-15
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-15   Englarmerdge Mongwe   Initial Version
**/


public class GetBalanceSheet_Resp_IB_v1 extends Base_IB {
    public List<Body> body;
    /**
 * @description       : Inner class with params
 * @author            : Englarmerdge Mongwe
 **/
	public class Body {
		public String Name;
		public String CIF_No;
		public String IDRegisrationNo;
		public String Curreny;
		public Integer ID;
		public Integer FinancialCustomerID;
		public String FinancialStatementDate;
		public Double FixedPropertiesandImprovements_OwnerValuation;
		public Double FixedPropertiesandImprovements_BranchValuation;
		public Double FixedPropertiesandImprovements_CreditValuation;
		public Double SharesinPrivateCompanyOrCCInterest_OwnerValution;
		public Double SharesinPrivateCompanyOrCCInterest_BranchValuation;
		public Double SharesinPrivateCompanyOrCCInterest_CreditValuation;
		public Double LoanAccountsToBusiness_OwnerValuation;
		public Double LoanAccountsToBusiness_BranchValuation;
		public Double LoanAccountsToBusiness_CreditValuation;
		public Double LocalFinancialInstrumentsListed_OwnerValuation;
		public Double LocalFinancialInstrumentsListed_BranchValuation;
		public Double LocalFinancialInstrumentsListed_CreditValuation;
		public Double CashInvestments_OwnerValuation;
		public Double CashInvestments_BranchValuation;
		public Double CashInvestments_CreditValuation;
		public Double TotalForeignAssets_OwnerValuation;
		public Double TotalForeignAssets_BranchValuation;
		public Double TotalForeignAssets_CreditValuation;
		public Double NetCapitalofBusiness_OwnerValuation;
		public Double NetCapitalofBusiness_BranchValuation;
		public Double NetCapitalofBusiness_CreditValuation;
		public Double EquipmentMachineryImplements_OwnerValuation;
		public Double EquipmentMachineryImplements_BranchValuation;
		public Double EquipmentMachineryImplements_CreditValuation;
		public Double MotorVehiclesCaravansBoats_OwnerValuation;
		public Double MotorVehiclesCaravansBoats_BranchValuation;
		public Double MotorVehiclesCaravansBoats_CreditValuation;
		public Double Debtors_OwnerValuation;
		public Double Debtors_BranchValuation;
		public Double Debtors_CreditValuation;
		public Double Stock_OwnerValuation;
		public Double Stock_BranchValuation;
		public Double Stock_CreditValuation;
		public Double Livestock_OwnerValuation;
		public Double Livestock_BranchValuation;
		public Double Livestock_CreditValuation;
		public Double CashOnHand_OwnerValuation;
		public Double CashOnHand_BranchValuation;
		public Double CashOnHand_CreditValuation;
		public Double PersonalEffects_OwnerValuation;
		public Double PersonalEffects_BranchValuation;
		public Double PersonalEffects_CreditValuation;
		public Double OtherAssets_OwnerValuation;
		public Double OtherAssets_BranchValuation;
		public Double OtherAssets_CreditValuation;
		public Double ShareholdersEquity_Historical;
		public Double ShareholdersEquity_Current;
		public Double ShareholdersEquity_CurrentAdjusted;
		public Double TotalForeignLiabilities_Historical;
		public Double TotalForeignLiabilities_Current;
		public Double TotalForeignLiabilities_CurrentAdjusted;
		public Double MortgageBonds_Historical;
		public Double MortgageBonds_Current;
		public Double MortgageBonds_CurrentAdjusted;
		public Double LoanAccounts_Historical;
		public Double LoanAccounts_Current;
		public Double LoanAccounts_CurrentAdjusted;
		public Double BankOverdraft_Historical;
		public Double BankOverdraft_Current;
		public Double BankOverdraft_CurrentAdjusted;
		public Double CreditCards_Historical;
		public Double CreditCards_Current;
		public Double CreditCards_CurrentAdjusted;
		public Double Creditors_Historical;
		public Double Creditors_Current;
		public Double Creditors_CurrentAdjusted;
		public Double OtherLiabilities_Historical;
		public Double OtherLiabilities_Current;
		public Double OtherLiabilities_CurrentAdjusted;
		public Double FixedPropertiesBonded_Historical;
		public Double FixedPropertiesBonded_Current;
		public Double FixedPropertiesBonded_CurrentAdjusted;
		public Double FixedPropertiesUnbonded_Historical;
		public Double FixedPropertiesUnbonded_Current;
		public Double FixedPropertiesUnbonded_CurrentAdjusted;
		public Double FixedPropertiesInformal_Historical;
		public Double FixedPropertiesInformal_Current;
		public Double FixedPropertiesInformal_CurrentAdjusted;
		public Double TotalBondRegistered_Historical;
		public Double TotalBondRegistered_Current;
		public Double TotalBondRegistered_CurrentAdjusted;
		public Double NotarialBondAmount_Historical;
		public Double NotarialBondAmount_Current;
		public Double NotarialBondAmount_CurrentAdjusted;
		public Boolean IsDeedsOfficeSearchAvailable;
		public Long DateOfDeedsOfficeSearch;
		public Boolean IsOutcomePositive;
		public Double TotalAssets_OwnerValuation;
		public Double TotalAssets_BranchValuation;
		public Double TotalAssets_CreditValuation;
		public Double TotalLiabilities_Historical;
		public Double TotalLiabilities_Current;
		public Double TotalLiabilities_CurrentAdjusted;
		public Double NetWorth_Historical;
		public Double NetWorth_Current;
		public Double NetWorth_CurrentAdjusted;
		public Double TotalPropertiesBondDetails_Historical;
		public Double TotalPropertiesBondDetails_Current;
		public Double TotalPropertiesBondDetails_CurrentAdjusted;
		public Long ModifyDate;
		public Boolean IsActive;
		public Object AccountNumber;
		public Object OwnersNetWorth_Current;
	}
}