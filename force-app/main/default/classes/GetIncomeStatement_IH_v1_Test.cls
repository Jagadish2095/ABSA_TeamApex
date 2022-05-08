/**
 * @description       : 
 * @author            : Englarmerdge Mongwe
 * @last modified on  : 2021-06-15
 * @last modified by  : Englarmerdge Mongwe
 * Modifications Log 
 * Ver   Date         Author                Modification
 * 1.0   2021-06-15   Englarmerdge Mongwe   Initial Version
**/


 @IsTest
public class GetIncomeStatement_IH_v1_Test {
    public static final String POSITIVE_RESPONSE_BODY = '[{"Name":"MR JH BRINK","IDRegisrationNo":"6908115218081","CustomerKey":"BRINKJH060","FinancialCustomerID":3288,"ID":5110,"NetSales":null,"CostofGoodsSold":null,"GrossProfit":null,"OperatingExpenses":null,"Depreciation":null,"Amortisation":null,"CapitalOrdinaryCreditPayments":null,"CapitalPaymentsonAssetFinance":null,"PurchaseorCapitalPaymentsonFixedProperty":null,"Salaries":null,"OtherExpenses":null,"VAT":null,"IncomeFromOperations":null,"ExtraordinaryIncome":null,"OtherIncome":null,"ProfitBeforeInterestandTax":null,"GrossInterestExpenses":null,"Interest_AssetFinance":null,"Interest_LoansandOtherFinance":null,"ProfitBeforeTax":null,"IncomeTax":null,"NetProfit":null,"Dividends":null,"RetainedEarnings_EndofYear":null,"Drawings":null,"MembersorShareholdersEmoluments":null,"HighestShortfallAmountYear":null,"HighestDebitBalanceAmountYear":null,"CreatedDate":1595515886000,"FinancialBalanceIncomeStatementID":5158,"MonthwithHighestShortfallYear":null,"MonthwithHighestDebitBalanceYear":null,"ExtraordinaryIncomeDescription":null,"EBITDA":null},{"Name":"MR JH BRINK","IDRegisrationNo":"6908115218081","CustomerKey":"BRINKJH060","FinancialCustomerID":3288,"ID":5111,"NetSales":null,"CostofGoodsSold":null,"GrossProfit":null,"OperatingExpenses":null,"Depreciation":null,"Amortisation":null,"CapitalOrdinaryCreditPayments":null,"CapitalPaymentsonAssetFinance":null,"PurchaseorCapitalPaymentsonFixedProperty":null,"Salaries":null,"OtherExpenses":null,"VAT":null,"IncomeFromOperations":null,"ExtraordinaryIncome":null,"OtherIncome":null,"ProfitBeforeInterestandTax":null,"GrossInterestExpenses":null,"Interest_AssetFinance":null,"Interest_LoansandOtherFinance":null,"ProfitBeforeTax":null,"IncomeTax":null,"NetProfit":null,"Dividends":null,"RetainedEarnings_EndofYear":null,"Drawings":null,"MembersorShareholdersEmoluments":null,"HighestShortfallAmountYear":null,"HighestDebitBalanceAmountYear":null,"CreatedDate":1595515886000,"FinancialBalanceIncomeStatementID":5159,"MonthwithHighestShortfallYear":null,"MonthwithHighestDebitBalanceYear":null,"ExtraordinaryIncomeDescription":null,"EBITDA":null},{"Name":"MR JH BRINK","IDRegisrationNo":"6908115218081","CustomerKey":"BRINKJH060","FinancialCustomerID":3288,"ID":5112,"NetSales":null,"CostofGoodsSold":null,"GrossProfit":null,"OperatingExpenses":null,"Depreciation":null,"Amortisation":null,"CapitalOrdinaryCreditPayments":null,"CapitalPaymentsonAssetFinance":null,"PurchaseorCapitalPaymentsonFixedProperty":null,"Salaries":null,"OtherExpenses":null,"VAT":null,"IncomeFromOperations":null,"ExtraordinaryIncome":null,"OtherIncome":null,"ProfitBeforeInterestandTax":null,"GrossInterestExpenses":null,"Interest_AssetFinance":null,"Interest_LoansandOtherFinance":null,"ProfitBeforeTax":null,"IncomeTax":null,"NetProfit":null,"Dividends":null,"RetainedEarnings_EndofYear":null,"Drawings":null,"MembersorShareholdersEmoluments":null,"HighestShortfallAmountYear":null,"HighestDebitBalanceAmountYear":null,"CreatedDate":1595515886000,"FinancialBalanceIncomeStatementID":5160,"MonthwithHighestShortfallYear":null,"MonthwithHighestDebitBalanceYear":null,"ExtraordinaryIncomeDescription":null,"EBITDA":null},{"Name":"MR JH BRINK","IDRegisrationNo":"6908115218081","CustomerKey":"BRINKJH060","FinancialCustomerID":3288,"ID":5113,"NetSales":null,"CostofGoodsSold":null,"GrossProfit":null,"OperatingExpenses":null,"Depreciation":null,"Amortisation":null,"CapitalOrdinaryCreditPayments":null,"CapitalPaymentsonAssetFinance":null,"PurchaseorCapitalPaymentsonFixedProperty":null,"Salaries":null,"OtherExpenses":null,"VAT":null,"IncomeFromOperations":null,"ExtraordinaryIncome":null,"OtherIncome":null,"ProfitBeforeInterestandTax":null,"GrossInterestExpenses":null,"Interest_AssetFinance":null,"Interest_LoansandOtherFinance":null,"ProfitBeforeTax":null,"IncomeTax":null,"NetProfit":null,"Dividends":null,"RetainedEarnings_EndofYear":null,"Drawings":null,"MembersorShareholdersEmoluments":null,"HighestShortfallAmountYear":null,"HighestDebitBalanceAmountYear":null,"CreatedDate":1595515886000,"FinancialBalanceIncomeStatementID":5161,"MonthwithHighestShortfallYear":null,"MonthwithHighestDebitBalanceYear":null,"ExtraordinaryIncomeDescription":null,"EBITDA":null}]';

    @TestSetup
    static void makeData(){
        IntegrationTestDataFactory.insertIntegrationSettings(StringConstants.JITTERBIT2, new List<String>{GetIncomeStatement_IH_v1.INTEGRATION_SERVICE_NAME});
    }

    @isTest static void testPositive() {
        // Set mock callout class
        incStatementTestMock();

        Test.startTest();

        GetIncomeStatement_Resp_IB_v1 responseBean = callHandlerMethod();
        System.assertEquals(200, responseBean.statusCode);

        Test.stopTest();
    }

    /**
    * @description : Method to set the test mock
    * @author Englarmerdge Mongwe | 2021-06-15 
    **/
    public static void incStatementTestMock() {
        Test.setMock(HttpCalloutMock.class, new Sys_Utilities_Integration_Mock_ApiRest(StringConstants.POSITIVE_STRING, POSITIVE_RESPONSE_BODY));
    }

    private static GetIncomeStatement_Resp_IB_v1 callHandlerMethod() {
        GetIncomeStatement_Req_IB_v1 dummyBean = GetIncomeStatement_Req_IB_v1.createDummyRequest();
        GetIncomeStatement_Resp_IB_v1 responseBean = GetIncomeStatement_IH_v1.GetIncomeStatement(dummyBean.client_code);
        GetIncomeStatement_IU_v1.mapRequestFields(dummyBean.client_code);
        return responseBean;
    }
}