/**
 * @description       : Request JSON Structure for Debt Capacity General Service
 * @author            : Amit G.
 * @group             : 
 * @last modified on  : 08-16-2021
 * @last modified by  : Tawanda M.
**/
public class DebtCapacityGeneral_Req_IB_v1 extends Base_IB {
    public Data data;

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class Data {
        public ChannelCalculatorDTO channelCalculatorDTO;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class DebtCapacityGeneralCalculatorDTO {
        public List<GeneralDTOs> GeneralDTOs;
        public List<LoanDetailsDTO> loanDetailsDTO;
        public OverdraftFacilityDTO overdraftFacilityDTO;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class GeneralDTOs {
        public DebtCapacityInitialDTO debtCapacityInitialDTO;
        public IncomeStatementDTO incomeStatementDTO;
        public CashflowStatementDTO cashflowStatementDTO;
        public BalanceSheetDTO balanceSheetDTO;
        public MinimumAnnualPaymentsDTO minimumAnnualPaymentsDTO;
        /* public PresentKeyRatiosDTO presentKeyRatiosDTO; */
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class LoanDetailsDTO_Z {
        public Integer loanType;
        public Decimal loanAmount;
        public Integer term;
        public Decimal intrestRate;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class CashflowStatementDTO {
        public Decimal grossInterestPaid;
        public Decimal netIncreaseDecreaseWorkingCapital;
        public Decimal taxPaidReceived;
        public Decimal divdendPaidRecieved;
        public Decimal capex;
        public Decimal receivables;
		public Decimal payables;
		public Decimal inventory;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class GeneralBalanceSheetDTO {
        public Decimal assets;
        public Decimal lowerOfPurchasePriceValuation;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class ChannelCalculatorDTO {
        public DebtCapacityGeneralCalculatorDTO debtCapacityGeneralCalculatorDTO;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class DebtCapacityInitialDTO {
        public Integer tenure;
        public Integer year;
        public String statementDate;
        public Integer GeneralType;
        public String currenctDGBucket;
        public Boolean useInCalculation;
        public String clientName;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class IncomeStatementDTO {
        public Decimal saleAmount;
        public Decimal depreciationAmortAmount;
        public Decimal netProfit;
        public Decimal rentExpense;
        public Decimal nonRecurringEvents;
        public Decimal ebit;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class BalanceSheetDTO {
        public GeneralBalanceSheetDTO GeneralBalanceSheetDTO;
        public Decimal intangibleAssets;
        public Decimal cash;
        public Decimal loans;
        public Decimal cpfOfBonds;
        public Decimal caf;
        public Decimal interCoLoans;
        public Decimal shareholdersLoans;
        public Decimal overdrafts;
        public Decimal other;
        public Decimal equity;
        public Decimal totalAssets;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class LoanDetailsDTO {
        public Integer loanType;
        public Decimal loanAmount;
        public Integer term;
        public Decimal intrestRate;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class PresentKeyRatiosDTO {
        public Decimal dgBucket;
        public Decimal termInmonths;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class MinimumAnnualPaymentsDTO {
        public Decimal previousYearCurrentPortion;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class OverdraftFacilityDTO {
        public Decimal overdraftBalance;
        public Decimal overdraftTerm;
        public Double overdraftIntrestRate;
    }
}