/**
 * @description       : Response JSON Structure for Debt Capacity General Service
 * @author            : Amit G.
 * @group             : 
 * @last modified on  : 08-16-2021
 * @last modified by  : Tawanda M.
**/
public class DebtCapacityGeneral_Resp_IB_v1 extends Base_IB {
    public Data data;
    public List<Errors> errors;

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class InterestBearingDebtRespDTO {
        public Decimal capitalPortionPayableNextTweleve;
        public Decimal interestPayableNextTweleve;
        public Decimal installPayableNextTweleve;
        public Decimal monthlyInstall;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class PresentRatiosDTO {
        public Decimal maxNetIBD;
        public Decimal minDSCR;
        public Decimal icrRatio;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class Data {
        public List<CalculationBaseDTOLs> calculationBaseDTOLs;
        public List<InterestBearingDebtRespDTO> interestBearingDebtRespDTO;
        public TotalNewDTO totalNewDTO;
        public ExpectedRatiosDTO expectedRatiosDTO;
        public Decimal overDraft;
        public RequiredRatioGeneralDTO requiredRatioGeneralDTO;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class RequiredRatioGeneralDTO {
        public Decimal maxNetIBDReq;
        public Decimal minDSCRReq;
        public Decimal minIcrRatioReq;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class CalculationBaseDTOLs {
        public IncomeRespStatementDTO incomeRespStatementDTO;
        public CashFlowRespStatementDTO cashFlowRespStatementDTO;
        public BalanceSheetRespStatementDTO balanceSheetRespStatementDTO;
        public MinimumAnnualPaymentsRespDTO minimumAnnualPaymentsRespDTO;
        /* public Decimal overDraft; */
        public PresentRatiosDTO presentRatiosDTO;  
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class MinimumAnnualPaymentsRespDTO {
        public Decimal minimumAnnualPayments;
        public Decimal interestPaid;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class CashFlowRespStatementDTO {
        public Decimal grossIntrestPaidPaidAnnualised;
        public Decimal netIncreaseDecreaseWorkingCapital;
        public Decimal netIncreaseDecreaseWorkingCapitalPaidAnnualised;
        public Decimal taxPaidAnnualised;
        public Decimal dividendPaidAnnualised;
        public Decimal freeCashFlow;
        public Decimal freeCashFlowAnnualised;
        public Decimal capexAnnualised;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class BalanceSheetRespStatementDTO {
        public Decimal interestBearingDebt;
        /* public Decimal totalAssets;
        public Decimal totalEquity;
        public Decimal intangibleAssets; */
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class Errors {
        public String details;
        public String source;
        public String code;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class IncomeRespStatementDTO {
        public String year;
        public Decimal salesAnnualised;
        public Decimal ebit;
        public Decimal ebitAnnualised;
        public Decimal ebitA;
        public Decimal ebitAAnnualised;
        public Decimal depreciationAmortisationAnnualised;
        public Decimal netProfitBeforeTaxAnnualised;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class ExpectedRatiosDTO {
        public Decimal maxNetIBDRatio;
        public Decimal minDSCRRatio;
        public Decimal minICRRatio;
        public Decimal maxNetIBDRatioSecondParam;
        public Decimal minICRSecondParameter;
        public Decimal minDSCRSecondParameter;
        public ExpectedOutcomeDTO expectedOutcomeDTO;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class TotalNewDTO {
        public Decimal capitalPortionGrandTotal;
        public Decimal intrestPaybleGrandTotal;
        public Decimal loansOverDraftGrandTotal;
        public Decimal installmentPaybleGrandTotal;
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class ExpectedOutcomeDTO {
        public String maxNetIBDOutcome;
        public String minDSCROutcome;
        public String minIcrRatioOutcome;
    }
}