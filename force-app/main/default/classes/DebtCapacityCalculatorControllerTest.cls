/**
 * @description       : Test class for General Debt Capacity Callout Component
 * @author            : Tawanda M.
 * @group             :
 * @last modified on  : 09-28-2021
 * @last modified by  : Tawanda M.
 **/
@isTest
private class DebtCapacityCalculatorControllerTest {
  @isTest
  public static void myUnitTest() {
    //Create an Opportunity Record
    Opportunity opp = new Opportunity();

    opp.Name = 'Test Opportunity';
    opp.StageName = 'New';
    opp.CloseDate = System.today();
    opp.DC_General_Calculator_Request__c = '{"data":{"channelCalculatorDTO":{"debtCapacityGeneralCalculatorDTO":{"overdraftFacilityDTO":{"overdraftTerm":12,"overdraftIntrestRate":12,"overdraftBalance":15000},"loanDetailsDTO":[{"term":12,"loanType":"1","loanAmount":1000,"intrestRate":12},{"term":12,"loanType":"3","loanAmount":1000,"intrestRate":12}],"generalDTOs":[{"presentKeyRatiosDTO":{"termInmonths":0,"dgBucket":0},"overdraftFacilityDTO":null,"minimumAnnualPaymentsDTO":{"previousYearCurrentPortion":0},"loanDetailsDTO":null,"incomeStatementDTO":{"saleAmount":3500000,"rentExpense":0,"nonRecurringEvents":0,"netProfit":2560000,"ebit":433456,"depreciationAmortAmount":700000},"debtCapacityInitialDTO":{"year":2020,"useInCalculation":true,"tenure":11,"statementDate":"2020-05-04","GeneralType":0,"currenctDGBucket":"1 to 4","clientName":""},"cashflowStatementDTO":{"taxPaidReceived":230000,"receivables":3932222,"payables":1000,"netIncreaseDecreaseWorkingCapital":0,"inventory":1000,"grossInterestPaid":9382221,"freeCashFlow":0,"divdendPaidRecieved":1000,"capex":1000},"balanceSheetDTO":{"totalAssets":1000,"shareholdersLoans":1000,"overdrafts":300000,"other":1000,"loans":1200000,"interCoLoans":10000,"intangibleAssets":1000,"GeneralBalanceSheetDTO":{"lowerOfPurchasePriceValuation":0,"assets":0},"equity":1000,"cpfOfBonds":1000,"cash":1000,"caf":10000}}]}}}}';

    //Insert
    insert opp;

    //Request Dummy String
    String debtCalRequest = '[{"balanceSheetDTO":{"caf":10000,"cash":1000,"cpfOfBonds":1000,"equity":1000,"GeneralBalanceSheetDTO":{"assets":0,"lowerOfPurchasePriceValuation":0},"intangibleAssets":1000,"interCoLoans":10000,"loans":1200000,"other":1000,"overdrafts":300000,"shareholdersLoans":1000,"totalAssets":1000},"cashflowStatementDTO":{"capex":1000,"divdendPaidRecieved":1000,"freeCashFlow":0,"grossInterestPaid":9382221,"inventory":1000,"netIncreaseDecreaseWorkingCapital":0,"payables":1000,"receivables":3932222,"taxPaidReceived":230000},"debtCapacityInitialDTO":{"clientName":"","currenctDGBucket":"1 to 4","GeneralType":0,"statementDate":"2020-05-04","tenure":11,"useInCalculation":true,"year":2020},"incomeStatementDTO":{"depreciationAmortAmount":700000,"ebit":433456,"netProfit":2560000,"nonRecurringEvents":0,"rentExpense":0,"saleAmount":3500000},"minimumAnnualPaymentsDTO":{"previousYearCurrentPortion":0},"presentKeyRatiosDTO":{"dgBucket":0,"termInmonths":0}}]';
    String dummyResponse = '{"data":{"overDraft":1800.0,"calculationBaseDTOLs":[{"incomeRespStatementDTO":{"year":"2020","salesAnnualised":3818181.8181818184,"ebitAnnualised":472861.0909090909,"ebitA":1133456.0,"ebitAAnnualised":1236497.4545454546,"depreciationAmortisationAnnualised":763636.3636363636,"netProfitBeforeTaxAnnualised":2792727.272727273},"cashFlowRespStatementDTO":{"grossIntrestPaidPaidAnnualised":10235150.181818182,"netIncreaseDecreaseWorkingCapital":-3932222.0,"netIncreaseDecreaseWorkingCapitalPaidAnnualised":-4289696.7272727275,"taxPaidAnnualised":250909.0909090909,"dividendPaidAnnualised":1090.909090909091,"freeCashFlow":-3030766.0,"freeCashFlowAnnualised":-3306290.1818181816,"capexAnnualised":1090.909090909091},"balanceSheetRespStatementDTO":{"interestBearingDebt":1523000.0},"minimumAnnualPaymentsRespDTO":{"minimumAnnualPayments":9382221.0,"interestPaid":9382221.0},"presentRatiosDTO":{"maxNetIBD":1.2308961853540556,"minDSCR":-0.323032893810538,"icrRatio":0.05039969650140312}}],"interestBearingDebtRespDTO":[{"loanType":"TERMLOAN","capitalPortionPayableNextTweleve":1000.0,"interestPayableNextTweleve":66.18546414010052,"installPayableNextTweleve":1066.1854641401005,"monthlyInstall":88.8487886783417},{"loanType":"MBBL","capitalPortionPayableNextTweleve":1000.0,"interestPayableNextTweleve":66.18546414010052,"installPayableNextTweleve":1066.1854641401005,"monthlyInstall":88.8487886783417}],"totalNewDTO":{"capitalPortionGrandTotal":2000.0,"intrestPaybleGrandTotal":1932.370928280201,"loansOverDraftGrandTotal":17000.0,"installmentPaybleGrandTotal":3932.370928280201},"expectedRatiosDTO":{"maxNetIBDRatio":1.2446446972798237,"minDSCRRatio":-0.3229088314100295,"minICRRatio":0.04619100104670242,"expectedOutcomeDTO":{"maxNetIBDOutcome":"Approve","minDSCROutcome":"Decline","minIcrRatioOutcome":"Decline"}},"requiredRatioGeneralDTO":{"maxNetIBDReq":2.5,"minDSCRReq":1.25,"minIcrRatioReq":2.0}},"errors":[]}';
    //Start Test
    Test.startTest();

    List<DebtCapacity_General_Controller.LoanBucket> loandata = new List<DebtCapacity_General_Controller.LoanBucket>{DebtCapacity_General_Controller.getEmptyLoanData()};

    //Call Call method
    DebtCapacityCalculatorController.generalCalculate(opp.Id, debtCalRequest, JSON.serialize(loandata));
    DebtCapacityCalculatorController.CalculateResponseWrappper respData = DebtCapacityCalculatorController.getRespData(
      (DebtCapacityGeneral_Resp_IB_v1) JSON.deserialize(
        dummyResponse,
        DebtCapacityGeneral_Resp_IB_v1.class
      ),
      debtCalRequest,
      new List<DebtCapacity_General_Controller.LoanDetailsDTO>{new DebtCapacity_General_Controller.LoanDetailsDTO('1', 0 ,0 ,0)},
      new DebtCapacity_General_Controller.OverdraftFacilityDTO(0, 0, 0)
    );
    //Stop Test
    System.assert(respData != null);
    Test.stopTest();
    
  }
}