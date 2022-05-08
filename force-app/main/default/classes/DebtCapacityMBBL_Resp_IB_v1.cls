/**
 * @description       : Response JSON Structure for Debt Capacity MBBL Service
 * @author            : Tawanda M.
 * @group             : 
 * @last modified on  : 2021-09-28
 * @last modified by  : Tawanda M.
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   07-21-2021   Tawanda M.   Initial Version
**/
public class DebtCapacityMBBL_Resp_IB_v1 extends Base_IB {
  @AuraEnabled
  public Data data;
  @AuraEnabled
  public List<Errors> errors;

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
  **/
  public class Data {
    @AuraEnabled
    public List<CalculationBaseDTOLs> calculationBaseDTOLs;
    @AuraEnabled
    public List<InterestBearingDebtRespDTO> interestBearingDebtRespDTO;
    @AuraEnabled
    public TotalNewDTO totalNewDTO;
    @AuraEnabled
    public ExpectedRatiosDTO expectedRatiosDTO;
    @AuraEnabled
    public RequiredRatioMbblDTO requiredRatioMbblDTO;
    @AuraEnabled
    public Double overDraft;
  }

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
  **/
  public class RequiredRatioMbblDTO{
    @AuraEnabled
    public String propertyRating;
    @AuraEnabled
    public String maxIBD;
    @AuraEnabled
    public String maxTerm;
    @AuraEnabled
    public String maxLtvNonSP;
    @AuraEnabled
    public String maxLtvSpecial;
    @AuraEnabled
    public String debtServiceCoverRation;
    @AuraEnabled
    public String dgBucket;
  }

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
  **/
  public class CalculationBaseDTOLs {
    @AuraEnabled
    public IncomeRespStatementDTO incomeRespStatementDTO;
    @AuraEnabled
    public CashFlowRespStatementDTO cashFlowRespStatementDTO;
    @AuraEnabled
    public BalanceSheetRespStatementDTO balanceSheetRespStatementDTO;
    @AuraEnabled
    public MinimumAnnualPaymentsRespDTO minimumAnnualPaymentsRespDTO;
/*     @AuraEnabled
    public Double monthlyInstall;
    @AuraEnabled
    public Double ibdOverDraft; */
    @AuraEnabled
    public PresentRatiosDTO presentRatiosDTO;
    
  }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
  public class InterestBearingDebtRespDTO {
    @AuraEnabled
    public String loanType;
    @AuraEnabled
    public Double capitalPortionPayableNextTweleve;
    @AuraEnabled
    public Double interestPayableNextTweleve;
    @AuraEnabled
    public Double installPayableNextTweleve;
    @AuraEnabled
    public Double monthlyInstall;
  }

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
  public class PresentRatiosDTO {
    @AuraEnabled
    public Double ibdEquityRatio;
    @AuraEnabled
    public Double ibdEbitaRatio;
    @AuraEnabled
    public Double icrRatio;
    @AuraEnabled
    public Double opmRatio;
    @AuraEnabled
    public Double speciaRatio;
    @AuraEnabled
    public Double nonSpeciaRatio;
    @AuraEnabled
    public Double propertyRating;
  }

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
  public class MinimumAnnualPaymentsRespDTO {
    @AuraEnabled
    public Double minimumAnnualPayments;
    @AuraEnabled
    public Double interestPaid;
  }

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
  public class CashFlowRespStatementDTO {
    @AuraEnabled
    public Double grossIntrestPaidAnnualised;
    @AuraEnabled
    public Double netIncreaseDecreaseWorkingCapital;
    @AuraEnabled
    public Double netIncreaseDecreaseWorkingCapitalAnnualised;
    @AuraEnabled
    public Double taxPaidAnnualised;
    @AuraEnabled
    public Double dividendPaidAnnualised;
    @AuraEnabled
    public Double freeCashFlow;
    @AuraEnabled
    public Double freeCashFlowAnnualised;
  }

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
  public class BalanceSheetRespStatementDTO {
    @AuraEnabled
    public Double interestBearingDebt;
    @AuraEnabled
    public Double totalAssets;
    @AuraEnabled
    public Double totalEquity;
  }

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
  public class IncomeRespStatementDTO {
    @AuraEnabled
    public String year;
    @AuraEnabled
    public Double salesAnnualised;
    @AuraEnabled
    public Double ebit;
    @AuraEnabled
    public Double ebitAnnualised;
    @AuraEnabled
    public Double ebitA;
    @AuraEnabled
    public Double ebitAAnnualised;
    @AuraEnabled
    public Double depreciationAmortisationAnnualised;
    @AuraEnabled
    public Double netProfitBeforeTaxAnnualised;
    @AuraEnabled
    public Double rentExpenseAnnualised;
  }

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
  public class ExpectedRatiosDTO {
    @AuraEnabled
    public String propertyRating;
    @AuraEnabled
    public Double maxIBD;
    @AuraEnabled
    public Double maxTerm;
    @AuraEnabled
    public Double maxLtvNonSP;
    @AuraEnabled
    public Double maxLtvSpecial;
    @AuraEnabled
    public String rating;
    @AuraEnabled
    public Double debtServiceCoverRation;
    @AuraEnabled
    public ExpectedOutcomeDTO expectedOutcomeDTO;
  }

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
  public class TotalNewDTO {
    @AuraEnabled
    public Double capitalPortionGrandTotal;
    @AuraEnabled
    public Double intrestPaybleGrandTotal;
    @AuraEnabled
    public Double loansOverDraftGrandTotal;
    @AuraEnabled
    public Double installmentPaybleGrandTotal;
  }

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
  public class ExpectedOutcomeDTO {
    @AuraEnabled
    public String propertyRatingOutcome;
    @AuraEnabled
    public String maxIbdOutcome;
    @AuraEnabled
    public String dgBucketOutcome;
    @AuraEnabled
    public String maxTermOutcome;
    @AuraEnabled
    public String maxLtvNonSPOutcome;
    @AuraEnabled
    public String maxLtvSpecialOutcome;
    @AuraEnabled
    public String debtServiceCoverRationOutcome;
  }

  /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
  **/
  public class Errors {
    @AuraEnabled
    public String details;
    @AuraEnabled
    public String source;
    @AuraEnabled
    public String code;
  }
}