/**
 * @description       : Class to manage callouts and layout structure for DC General Calculator Results
 * @author            : Amit G.
 * @group             : 
 * @last modified on  : 2021-09-28
 * @last modified by  : Tawanda M.
**/
public class DebtCapacityCalculatorController {

    public static final Map<String, String> LoanTypes = new Map<String, String>{
        '1' => 'Term Loan',
        '2' => 'CPF',
        '3' => 'MBBL',
        '4' => 'CAF',
        '5' => 'Overdraft'
    };

    /**
    * @description Response Wrapper for General DC Callout sent to Aura component
    * @author Tawanda M. | 07-20-2021 
    **/
    public class CalculateGenResult{
        @AuraEnabled
        public Boolean success;
        @AuraEnabled
        public List<String> message;
        @AuraEnabled
        public CalculateResponseWrappper data;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param success
        * @param message
        * @param data
        **/
        public CalculateGenResult(Boolean success, List<String> message, CalculateResponseWrappper data){
            this.success = success;
            this.message = message;
            this.data = data;
        }
    }

    /**
    * @description Response Wrapper for General Callout
    * @author Tawanda M. | 07-20-2021 
    **/
    public class CalculateResponseWrappper{
        @AuraEnabled
        public Map<String, List<String>> normalResultTable;
        @AuraEnabled
        public Map<String, List<String>> loanResultTable;
        @AuraEnabled
        public Map<String, List<String>> expectedKRTable;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param normalResultTable
        * @param loanResultTable
        * @param expectedKRTable
        **/
        public CalculateResponseWrappper(Map<String, List<String>> normalResultTable, Map<String, List<String>> loanResultTable, Map<String, List<String>> expectedKRTable){
            this.normalResultTable = normalResultTable;
            this.loanResultTable = loanResultTable;
            this.expectedKRTable = expectedKRTable;
        }
    }

    /**
    * @description Method used to parse response data from Jitterbit endpoint into iterable structure for aura component
    * @author Tawanda M. | 07-20-2021 
    * @param respParsedData 
    * @param currentRequestData 
    * @param loansList 
    * @param ovrFacility 
    * @return CalculateResponseWrappper 
    **/
    @AuraEnabled
    public static CalculateResponseWrappper getRespData(DebtCapacityGeneral_Resp_IB_v1 respParsedData, String currentRequestData, List<DebtCapacity_General_Controller.LoanDetailsDTO> loansList, DebtCapacity_General_Controller.OverdraftFacilityDTO ovrFacility){
        try{
            Map<String, List<String>> tableData = new Map<String, List<String>>();
            Map<String, List<String>> loanTableData = new Map<String, List<String>>();
            Map<String, List<String>> keyRatiosTableData = new Map<String, List<String>>();
            //Set Maps
            tableData.put('TTC DG Category', new List<String>());
            tableData.put('Number of Months in Financial Statements', new List<String>());
            tableData.put('Items', new List<String>());
            tableData.put('Income Statement', new List<String>());
            tableData.put('Sales', new List<String>());
            tableData.put('EBITDA', new List<String>());
            tableData.put('Depreciation / Amortisation', new List<String>());
            tableData.put('Earnings before interest & tax (EBIT) (+ / -)', new List<String>());
            tableData.put('Net Profit (+) / Loss (-)', new List<String>());
            tableData.put('Cash Flow Statement', new List<String>());
            tableData.put('Interest paid (+) / Interest received (-)', new List<String>());
            tableData.put('Net increase(+) / decrease (-) in Working Capital', new List<String>());
            tableData.put('Tax paid (+) / Tax received (-)', new List<String>());
            tableData.put('Dividend paid (+) / Dividend received (-)', new List<String>());
            tableData.put('Capex (Maintain only; not Expand)', new List<String>());
            tableData.put('Free Cash Flow', new List<String>());
            tableData.put('Balance Sheet', new List<String>());
            tableData.put('Intangible Assets', new List<String>());
            tableData.put('Total Assets', new List<String>());
            tableData.put('Cash', new List<String>());
            tableData.put('Existing Interest Bearing Debt', new List<String>());
            tableData.put('Loans', new List<String>());
            tableData.put('CPF/Bonds', new List<String>());
            tableData.put('Inter-Co Loans', new List<String>());
            tableData.put('Shareholder\'s Loans', new List<String>());
            tableData.put('Overdrafts', new List<String>());
            tableData.put('Other', new List<String>());
            tableData.put('Total Equity', new List<String>());
            tableData.put('Minimum Annual Payments (MAP)', new List<String>());
            tableData.put('Interest Paid (for period)', new List<String>());
            tableData.put('Current Portion of Previous Years IBD', new List<String>());
            tableData.put('Present Key Ratios', new List<String>());
            tableData.put('Max Net IBD = (IBD - Cash) / EBITDA', new List<String>());
            tableData.put('Interest Cover Ratio (ICR) = (EBIT / Net Int Paid)', new List<String>());
            tableData.put('Min DSCR = (FCF / MAP)', new List<String>());

            //Set loan table maps
            loanTableData.put('New Interest Bearing Debt (Current Year)', new List<String>());
            loanTableData.put('Loan', new List<String>());
            loanTableData.put('Type of Loan', new List<String>());
            loanTableData.put('Loan Amount', new List<String>());
            loanTableData.put('Term', new List<String>());
            loanTableData.put('Client Interest Rate %', new List<String>());
            loanTableData.put('Monthly Installments', new List<String>());
            loanTableData.put('Installments Payable next 12 months on new IBD', new List<String>());
            loanTableData.put('Interest Payable on new IBD', new List<String>());
            loanTableData.put('Capital Portion Repayable', new List<String>());
            loanTableData.put('Overdraft Facility', new List<String>());
            loanTableData.put('Average overdraft balance over next 12 months', new List<String>());
            loanTableData.put('Term (OD)', new List<String>());
            loanTableData.put('Client Interest Rate % (OD)', new List<String>());
            loanTableData.put('Interest Payable on new IBD (OD)', new List<String>());
            loanTableData.put('Total New', new List<String>());
            loanTableData.put('Loan Amount (TN)', new List<String>());
            loanTableData.put('Installments Payable next 12 months on new IBD (TN)', new List<String>());
            loanTableData.put('Interest Payable on new IBD (TN)', new List<String>());
            loanTableData.put('Capital Portion Repayable (TN)', new List<String>());

            //Set key ratios maps
            keyRatiosTableData.put('Expected Key Ratios (after adding new IBD)', new List<String>());
            keyRatiosTableData.put('Max IBD / EBITDA', new List<String>());
            keyRatiosTableData.put('Min ICR = (EBIT / Net Int Paid)', new List<String>());
            keyRatiosTableData.put('Min DSCR = (FCF / MAP)', new List<String>());

            List<DebtCapacity_General_Controller.GeneralDataStructure> requestData = (List<DebtCapacity_General_Controller.GeneralDataStructure>) JSON.deserialize(currentRequestData, List<DebtCapacity_General_Controller.GeneralDataStructure>.class);
            //Sort both request and result
            requestData = sortGeneralReqData(requestData);
            respParsedData.data.calculationBaseDTOLs = sortGeneralRespData(respParsedData.data.calculationBaseDTOLs);

            for(Integer i = 0; i < respParsedData.data.calculationBaseDTOLs.size(); i++){
                DebtCapacityGeneral_Resp_IB_v1.CalculationBaseDTOLs currentData = respParsedData.data.calculationBaseDTOLs[i];
                //Set table data
                //for each year, add to list the value and the annualised value next to each other, empty value if it does not exist
                tableData.get('TTC DG Category').add(String.valueOf(requestData[i].debtCapacityInitialDTO.currenctDGBucket));
                tableData.get('Number of Months in Financial Statements').add(String.valueOf(requestData[i].debtCapacityInitialDTO.tenure));
                tableData.get('Items').add(String.valueOf('Audited AFS at ' + requestData[i].debtCapacityInitialDTO.year));
                tableData.get('Income Statement').add(String.valueOf(''));
                tableData.get('Sales').add(String.valueOf(requestData[i].incomeStatementDTO.saleAmount));
                tableData.get('EBITDA').add(String.valueOf(currentData.incomeRespStatementDTO.ebitA));
                tableData.get('Depreciation / Amortisation').add(String.valueOf(requestData[i].incomeStatementDTO.depreciationAmortAmount));
                tableData.get('Earnings before interest & tax (EBIT) (+ / -)').add(String.valueOf(requestData[i].incomeStatementDTO.ebit));
                tableData.get('Net Profit (+) / Loss (-)').add(String.valueOf(requestData[i].incomeStatementDTO.netProfit));
                tableData.get('Cash Flow Statement').add(String.valueOf(''));
                tableData.get('Interest paid (+) / Interest received (-)').add(String.valueOf(requestData[i].cashflowStatementDTO.grossInterestPaid));
                tableData.get('Net increase(+) / decrease (-) in Working Capital').add(String.valueOf(currentData.cashFlowRespStatementDTO.netIncreaseDecreaseWorkingCapital));
                tableData.get('Tax paid (+) / Tax received (-)').add(String.valueOf(requestData[i].cashflowStatementDTO.taxPaidReceived));
                tableData.get('Dividend paid (+) / Dividend received (-)').add(String.valueOf(requestData[i].cashflowStatementDTO.divdendPaidRecieved));
                tableData.get('Capex (Maintain only; not Expand)').add(String.valueOf(requestData[i].cashflowStatementDTO.capex));
                tableData.get('Free Cash Flow').add(String.valueOf(currentData.cashFlowRespStatementDTO.freeCashFlow));
                tableData.get('Balance Sheet').add(String.valueOf(''));
                tableData.get('Intangible Assets').add(String.valueOf(requestData[i].balanceSheetDTO.intangibleAssets));
                //Confirm mapping
                tableData.get('Total Assets').add(String.valueOf(currentData.balanceSheetRespStatementDTO.interestBearingDebt));
                tableData.get('Cash').add(String.valueOf(requestData[i].balanceSheetDTO.cash));
                tableData.get('Existing Interest Bearing Debt').add(String.valueOf(currentData.balanceSheetRespStatementDTO.interestBearingDebt));
                tableData.get('Loans').add(String.valueOf(requestData[i].balanceSheetDTO.loans));
                tableData.get('CPF/Bonds').add(String.valueOf(requestData[i].balanceSheetDTO.cpfOfBonds));
                tableData.get('Inter-Co Loans').add(String.valueOf(requestData[i].balanceSheetDTO.interCoLoans));
                tableData.get('Shareholder\'s Loans').add(String.valueOf(requestData[i].balanceSheetDTO.shareholdersLoans));
                tableData.get('Overdrafts').add(String.valueOf(requestData[i].balanceSheetDTO.overdrafts));
                tableData.get('Other').add(String.valueOf(requestData[i].balanceSheetDTO.other));
                //Please confirm mapping
                tableData.get('Total Equity').add(String.valueOf(currentData.balanceSheetRespStatementDTO.interestBearingDebt));
                tableData.get('Minimum Annual Payments (MAP)').add(String.valueOf(currentData.minimumAnnualPaymentsRespDTO.minimumAnnualPayments));
                tableData.get('Interest Paid (for period)').add(String.valueOf(currentData.minimumAnnualPaymentsRespDTO.interestPaid));
                tableData.get('Current Portion of Previous Years IBD').add(String.valueOf(requestData[i].minimumAnnualPaymentsDTO.previousYearCurrentPortion));
                tableData.get('Present Key Ratios').add(String.valueOf(''));
                tableData.get('Max Net IBD = (IBD - Cash) / EBITDA').add(String.valueOf(currentData.presentRatiosDTO.maxNetIBD));
                tableData.get('Interest Cover Ratio (ICR) = (EBIT / Net Int Paid)').add(String.valueOf(currentData.presentRatiosDTO.icrRatio));
                tableData.get('Min DSCR = (FCF / MAP)').add(String.valueOf(currentData.presentRatiosDTO.minDSCR));

                //Loan data
                loanTableData.get('New Interest Bearing Debt (Current Year)').add(String.valueOf(''));
                loanTableData.get('Loan').add(String.valueOf(''));
                loanTableData.get('Type of Loan').add(String.valueOf(LoanTypes.get(loansList[i].loanType)));
                loanTableData.get('Loan Amount').add(String.valueOf(loansList[i].loanAmount));
                loanTableData.get('Term').add(String.valueOf(loansList[i].term));
                loanTableData.get('Client Interest Rate %').add(String.valueOf(loansList[i].intrestRate));
                loanTableData.get('Monthly Installments').add(String.valueOf(respParsedData.data.interestBearingDebtRespDTO[i].monthlyInstall));
                loanTableData.get('Installments Payable next 12 months on new IBD').add(String.valueOf(respParsedData.data.interestBearingDebtRespDTO[i].installPayableNextTweleve));
                loanTableData.get('Interest Payable on new IBD').add(String.valueOf(respParsedData.data.interestBearingDebtRespDTO[i].interestPayableNextTweleve));
                loanTableData.get('Capital Portion Repayable').add(String.valueOf(respParsedData.data.interestBearingDebtRespDTO[i].capitalPortionPayableNextTweleve));
                loanTableData.get('Overdraft Facility').add(String.valueOf(''));
                if(respParsedData.data.calculationBaseDTOLs.size() == 1 && loansList.size() > 1){
                    loanTableData.get('New Interest Bearing Debt (Current Year)').add(String.valueOf(''));
                    loanTableData.get('Loan').add(String.valueOf(''));
                    loanTableData.get('Type of Loan').add(String.valueOf(LoanTypes.get(loansList[i + 1].loanType)));
                    loanTableData.get('Loan Amount').add(String.valueOf(loansList[i + 1].loanAmount));
                    loanTableData.get('Term').add(String.valueOf(loansList[i + 1].term));
                    loanTableData.get('Client Interest Rate %').add(String.valueOf(loansList[i + 1].intrestRate));
                    loanTableData.get('Monthly Installments').add(String.valueOf(respParsedData.data.interestBearingDebtRespDTO[i + 1].monthlyInstall));
                    loanTableData.get('Installments Payable next 12 months on new IBD').add(String.valueOf(respParsedData.data.interestBearingDebtRespDTO[i + 1].installPayableNextTweleve));
                    loanTableData.get('Interest Payable on new IBD').add(String.valueOf(respParsedData.data.interestBearingDebtRespDTO[i + 1].interestPayableNextTweleve));
                    loanTableData.get('Capital Portion Repayable').add(String.valueOf(respParsedData.data.interestBearingDebtRespDTO[i + 1].capitalPortionPayableNextTweleve));
                    loanTableData.get('Overdraft Facility').add(String.valueOf(''));
                    loanTableData.get('Total New').add(String.valueOf(''));
                }
                if(i == 0){
                    loanTableData.get('Average overdraft balance over next 12 months').add(String.valueOf(ovrFacility.overdraftBalance));
                    loanTableData.get('Term (OD)').add(String.valueOf(ovrFacility.overdraftTerm));
                    loanTableData.get('Client Interest Rate % (OD)').add(String.valueOf(ovrFacility.overdraftIntrestRate));
                    loanTableData.get('Interest Payable on new IBD (OD)').add(String.valueOf(respParsedData.data.overDraft));
                    loanTableData.get('Total New').add(String.valueOf(''));
                    loanTableData.get('Loan Amount (TN)').add(String.valueOf(respParsedData.data.totalNewDTO.loansOverDraftGrandTotal));
                    loanTableData.get('Installments Payable next 12 months on new IBD (TN)').add(String.valueOf(respParsedData.data.totalNewDTO.installmentPaybleGrandTotal));
                    loanTableData.get('Interest Payable on new IBD (TN)').add(String.valueOf(respParsedData.data.totalNewDTO.intrestPaybleGrandTotal));
                    loanTableData.get('Capital Portion Repayable (TN)').add(String.valueOf(respParsedData.data.totalNewDTO.capitalPortionGrandTotal));
                }
                else{
                    loanTableData.get('Average overdraft balance over next 12 months').add(String.valueOf(''));
                    loanTableData.get('Term (OD)').add(String.valueOf(''));
                    loanTableData.get('Client Interest Rate % (OD)').add(String.valueOf(''));
                    loanTableData.get('Interest Payable on new IBD (OD)').add(String.valueOf(''));
                    loanTableData.get('Total New').add(String.valueOf(''));
                    loanTableData.get('Loan Amount (TN)').add(String.valueOf(''));
                    loanTableData.get('Installments Payable next 12 months on new IBD (TN)').add(String.valueOf(''));
                    loanTableData.get('Interest Payable on new IBD (TN)').add(String.valueOf(''));
                    loanTableData.get('Capital Portion Repayable (TN)').add(String.valueOf(''));
                }

                //Only view first year's results for expected key ratios
                if(i == 0){
                    //Expected key ratios calculated
                    keyRatiosTableData.get('Expected Key Ratios (after adding new IBD)').add(String.valueOf('Ratio Results'));
                    keyRatiosTableData.get('Max IBD / EBITDA').add(String.valueOf((respParsedData.data.expectedRatiosDTO.maxNetIBDRatio == null) ? 0.0 : respParsedData.data.expectedRatiosDTO.maxNetIBDRatio));
                    keyRatiosTableData.get('Min ICR = (EBIT / Net Int Paid)').add(String.valueOf((respParsedData.data.expectedRatiosDTO.minICRRatio == null) ? 0.0 : respParsedData.data.expectedRatiosDTO.minICRRatio));
                    keyRatiosTableData.get('Min DSCR = (FCF / MAP)').add(String.valueOf((respParsedData.data.expectedRatiosDTO.minDSCRRatio == null) ? 0.0 : respParsedData.data.expectedRatiosDTO.minDSCRRatio));
                }

                //Annualised Values
                tableData.get('TTC DG Category').add(String.valueOf(''));
                tableData.get('Number of Months in Financial Statements').add(String.valueOf(''));
                tableData.get('Items').add(String.valueOf('Annualised'));
                tableData.get('Income Statement').add(String.valueOf(''));
                tableData.get('Sales').add(String.valueOf(currentData.incomeRespStatementDTO.salesAnnualised));
                tableData.get('EBITDA').add(String.valueOf(currentData.incomeRespStatementDTO.ebitAAnnualised));
                tableData.get('Depreciation / Amortisation').add(String.valueOf(currentData.incomeRespStatementDTO.depreciationAmortisationAnnualised));
                tableData.get('Earnings before interest & tax (EBIT) (+ / -)').add(String.valueOf(currentData.incomeRespStatementDTO.ebitAnnualised));
                tableData.get('Net Profit (+) / Loss (-)').add(String.valueOf(currentData.incomeRespStatementDTO.netProfitBeforeTaxAnnualised));
                tableData.get('Cash Flow Statement').add(String.valueOf(''));
                tableData.get('Interest paid (+) / Interest received (-)').add(String.valueOf(currentData.cashFlowRespStatementDTO.grossIntrestPaidPaidAnnualised));
                tableData.get('Net increase(+) / decrease (-) in Working Capital').add(String.valueOf(currentData.cashFlowRespStatementDTO.netIncreaseDecreaseWorkingCapitalPaidAnnualised));
                tableData.get('Tax paid (+) / Tax received (-)').add(String.valueOf(currentData.cashFlowRespStatementDTO.taxPaidAnnualised));
                tableData.get('Dividend paid (+) / Dividend received (-)').add(String.valueOf(currentData.cashFlowRespStatementDTO.dividendPaidAnnualised));
                tableData.get('Capex (Maintain only; not Expand)').add(String.valueOf(currentData.cashFlowRespStatementDTO.capexAnnualised));
                tableData.get('Free Cash Flow').add(String.valueOf(currentData.cashFlowRespStatementDTO.freeCashFlowAnnualised));
                tableData.get('Balance Sheet').add(String.valueOf(''));
                tableData.get('Intangible Assets').add(String.valueOf(''));
                tableData.get('Total Assets').add(String.valueOf(''));
                tableData.get('Cash').add(String.valueOf(''));
                tableData.get('Existing Interest Bearing Debt').add(String.valueOf(''));
                tableData.get('Loans').add(String.valueOf(''));
                tableData.get('CPF/Bonds').add(String.valueOf(''));
                tableData.get('Inter-Co Loans').add(String.valueOf(''));
                tableData.get('Shareholder\'s Loans').add(String.valueOf(''));
                tableData.get('Overdrafts').add(String.valueOf(''));
                tableData.get('Other').add(String.valueOf(''));
                tableData.get('Total Equity').add(String.valueOf(''));
                tableData.get('Minimum Annual Payments (MAP)').add(String.valueOf(''));
                tableData.get('Interest Paid (for period)').add(String.valueOf(''));
                tableData.get('Current Portion of Previous Years IBD').add(String.valueOf(''));
                tableData.get('Present Key Ratios').add(String.valueOf(''));
                tableData.get('Max Net IBD = (IBD - Cash) / EBITDA').add(String.valueOf(''));
                tableData.get('Interest Cover Ratio (ICR) = (EBIT / Net Int Paid)').add(String.valueOf(''));
                tableData.get('Min DSCR = (FCF / MAP)').add(String.valueOf(''));

                /*//Annualised loan values
                loanTableData.get('New Interest Bearing Debt (Current Year)').add(String.valueOf(''));
                loanTableData.get('Loan').add(String.valueOf(''));
                loanTableData.get('Type of Loan').add(String.valueOf(''));
                loanTableData.get('Loan Amount').add(String.valueOf(''));
                loanTableData.get('Term').add(String.valueOf(''));
                loanTableData.get('Client Interest Rate %').add(String.valueOf(''));
                loanTableData.get('Monthly Installments').add(String.valueOf(''));
                loanTableData.get('Installments Payable next 12 months on new IBD').add(String.valueOf(''));
                loanTableData.get('Interest Payable on new IBD').add(String.valueOf(''));
                loanTableData.get('Capital Portion Repayable').add(String.valueOf(''));
                loanTableData.get('Overdraft Facility').add(String.valueOf(''));
                loanTableData.get('Average overdraft balance over next 12 months').add(String.valueOf(''));
                loanTableData.get('Term (OD)').add(String.valueOf(''));
                loanTableData.get('Client Interest Rate % (OD)').add(String.valueOf(''));
                loanTableData.get('Interest Payable on new IBD (OD)').add(String.valueOf(''));
                loanTableData.get('Total New').add(String.valueOf(''));
                loanTableData.get('Loan Amount (TN)').add(String.valueOf(''));
                loanTableData.get('Installments Payable next 12 months on new IBD (TN)').add(String.valueOf(''));
                loanTableData.get('Interest Payable on new IBD (TN)').add(String.valueOf(''));
                loanTableData.get('Capital Portion Repayable (TN)').add(String.valueOf(''));
 */
                //Only view first year's results for expected key ratios
                if(i == 0){
                    //Required Key Ratios
                    keyRatiosTableData.get('Expected Key Ratios (after adding new IBD)').add(String.valueOf('Required Ratios'));
                    keyRatiosTableData.get('Max IBD / EBITDA').add(String.valueOf((respParsedData.data.requiredRatioGeneralDTO.maxNetIBDReq == null) ? '0.0' : String.valueOf(respParsedData.data.requiredRatioGeneralDTO.maxNetIBDReq )));
                    keyRatiosTableData.get('Min ICR = (EBIT / Net Int Paid)').add(String.valueOf((respParsedData.data.requiredRatioGeneralDTO.minIcrRatioReq  == null) ? '0.0' : String.valueOf(respParsedData.data.requiredRatioGeneralDTO.minIcrRatioReq )));
                    keyRatiosTableData.get('Min DSCR = (FCF / MAP)').add(String.valueOf((respParsedData.data.requiredRatioGeneralDTO.minDSCRReq  == null) ? '0.0' : String.valueOf(respParsedData.data.requiredRatioGeneralDTO.minDSCRReq )));
                    //Expected key ratios calculated
                    keyRatiosTableData.get('Expected Key Ratios (after adding new IBD)').add(String.valueOf('Outcome'));
                    keyRatiosTableData.get('Max IBD / EBITDA').add(String.valueOf((respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxNetIBDOutcome == null || respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxNetIBDOutcome == '') ? '0.0' : respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxNetIBDOutcome));
                    keyRatiosTableData.get('Min ICR = (EBIT / Net Int Paid)').add(String.valueOf((respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.minIcrRatioOutcome == null || respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.minIcrRatioOutcome == '') ? '0.0' : respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.minIcrRatioOutcome));
                    keyRatiosTableData.get('Min DSCR = (FCF / MAP)').add(String.valueOf((respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.minDSCROutcome == null || respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.minDSCROutcome == '') ? '0.0' : respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.minDSCROutcome));
                }

            }
            return new CalculateResponseWrappper(tableData,loanTableData,keyRatiosTableData);
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    /**
    * @description Method to send input data to MBBL Jitterbit endpoint 
    * @author Amit G. | 07-20-2021 
    * @param opportunityId 
    * @param currentData 
    * @param loanData 
    * @return CalculateGenResult 
    **/
    @AuraEnabled
    public static CalculateGenResult generalCalculate(String opportunityId, String currentData, String loanData){
            try{
                CalculateGenResult result;
                DebtCapacity_General_Controller.OverdraftFacilityDTO ovrFacility;
                List<DebtCapacity_General_Controller.LoanDetailsDTO> loansList = new List<DebtCapacity_General_Controller.LoanDetailsDTO>();
                List<String> errorMessageList = new List<String>();
                String INTEGRATION_SERVICE_NAME = 'DC Debtcapacitycal';
                List<DebtCapacity_General_Controller.GeneralDataStructure> parsedData = (List<DebtCapacity_General_Controller.GeneralDataStructure>) JSON.deserialize(currentData, List<DebtCapacity_General_Controller.GeneralDataStructure>.class);
                List<DebtCapacity_General_Controller.GeneralDataStructure> sortedGenData = sortGeneralReqData(parsedData);
                if(loanData != null){
                    List<DebtCapacity_General_Controller.LoanBucket> loans = (List<DebtCapacity_General_Controller.LoanBucket>) JSON.deserialize(loanData, List<DebtCapacity_General_Controller.LoanBucket>.class);
                    for(DebtCapacity_General_Controller.LoanBucket loan : loans){
                    if(loan.loanType == '5'){
                        ovrFacility = new DebtCapacity_General_Controller.OverdraftFacilityDTO(loan.loanAmount,loan.term,loan.intrestRate);
                        ovrFacility.overdraftIntrestRate = loan.intrestRate;
                        ovrFacility.overdraftBalance = loan.loanAmount;
                        ovrFacility.overdraftTerm = loan.term;
                    }
                    else{
                        loansList.add(new DebtCapacity_General_Controller.LoanDetailsDTO(loan.loanType,loan.loanAmount,loan.term,loan.intrestRate));
                    }

                    /* if(loan.loanType == '5'){
                        sortedGenData[0].overdraftFacilityDTO = new DebtCapacity_General_Controller.OverdraftFacilityDTO(0,0,0);
                        sortedGenData[0].overdraftFacilityDTO.overdraftIntrestRate = loan.intrestRate;
                        sortedGenData[0].overdraftFacilityDTO.overdraftBalance = loan.loanAmount;
                        sortedGenData[0].overdraftFacilityDTO.overdraftTerm = loan.term;
                    }
                    else if(sortedGenData[0].loanDetailsDTO == null){
                        sortedGenData[0].loanDetailsDTO = new DebtCapacity_General_Controller.LoanDetailsDTO('1',0,0,0);
                        sortedGenData[0].loanDetailsDTO.term = loan.term;
                        sortedGenData[0].loanDetailsDTO.loanAmount = loan.loanAmount;
                        sortedGenData[0].loanDetailsDTO.loanType = loan.loanType;
                        sortedGenData[0].loanDetailsDTO.intrestRate = loan.intrestRate;
                    }
                    else if(sortedGenData[1].loanDetailsDTO == null){
                        sortedGenData[1].loanDetailsDTO = new DebtCapacity_General_Controller.LoanDetailsDTO('1',0,0,0);
                        sortedGenData[1].loanDetailsDTO.term = loan.term;
                        sortedGenData[1].loanDetailsDTO.loanAmount = loan.loanAmount;
                        sortedGenData[1].loanDetailsDTO.loanType = loan.loanType;
                        sortedGenData[1].loanDetailsDTO.intrestRate = loan.intrestRate;
                    } */
                }   
                }
                //if sections are missing, add to payload as null data
                if(ovrFacility == null){
                    new DebtCapacity_General_Controller.OverdraftFacilityDTO(0,0,0);
                }
                if(loansList.isEmpty() == true){
                    loansList.add(new DebtCapacity_General_Controller.LoanDetailsDTO('1',0,12,0));
                    loansList.add(new DebtCapacity_General_Controller.LoanDetailsDTO('1',0,12,0));
                }
                else if(loansList.size() == 1){
                    loansList.add(new DebtCapacity_General_Controller.LoanDetailsDTO('1',0,12,0));
                }

                String jsonPayload = '{"data":{"channelCalculatorDTO":{"debtCapacityGeneralCalculatorDTO":{"overdraftFacilityDTO":'+ JSON.serialize(ovrFacility) +',"loanDetailsDTO":'+ JSON.serialize(loansList) +',"GeneralDTOs":' + JSON.serialize(sortedGenData) + '}}}}';
                //Opportunity opp = [Select Id, DC_MBBL_Calculator_Request__c from Opportunity where Id =: opportunityId];
                DebtCapacityGeneral_Req_IB_v1 requestBean = (DebtCapacityGeneral_Req_IB_v1) JSON.deserialize(jsonPayload, DebtCapacityGeneral_Req_IB_v1.class);
                DebtCapacityGeneral_Resp_IB_v1 responseBean = (DebtCapacityGeneral_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, DebtCapacityGeneral_Resp_IB_v1.class);
                if(responseBean.message == null && responseBean.statusCode == 200){
                    if(!responseBean.errors.isEmpty()){
                        for(DebtCapacityGeneral_Resp_IB_v1.Errors err: responseBean.errors){
                            errorMessageList.add(err.details);
                        }
                        return new CalculateGenResult(false, errorMessageList , null);
                    }
                    //TODO: Check client side error handling when this is not there
                    else if(responseBean.data.calculationBaseDTOLs == null){
                        errorMessageList.add('Data returned from webservice is empty');
                        return new CalculateGenResult(false, errorMessageList, null);
                    }
                    else{
                        saveResult(JSON.serialize(responseBean), opportunityId);
                        return new CalculateGenResult(true, errorMessageList, getRespData(responseBean, JSON.serialize(sortedGenData), loansList, ovrFacility));
                    }
                }
                else if(responseBean.message != null){
                    //This is if no loan data is in the request. API does not accept that but returns errors as object not list causing exception
                    //Check message from integration framework and act accordingly
                    if(responseBean.message.contains('The LoanDetailsDTO field is required')){
                        errorMessageList.add('Atleast one normal loan type (Not Overdraft) scenario is required for each financial year.');
                        return new CalculateGenResult(false, errorMessageList , null);
                    }
                    else if(responseBean.message.contains('The OverdraftFacilityDTO field is required')){
                        errorMessageList.add('Atleast one overtdraft loan type scenario is required for each financial year.');
                        return new CalculateGenResult(false, errorMessageList , null);
                    }
                    else if(responseBean.message.contains('Internal Server Error')){
                        errorMessageList.add('Internal Server Error: Debt Capacity calculation has failed due to a webservice error.');
                        return new CalculateGenResult(false, errorMessageList , null);
                    }
                    else{
                        return new CalculateGenResult(false, errorMessageList , null);
                    }
                }
                else{
                    return new CalculateGenResult(true, errorMessageList , null);
                }
            }
            catch(Exception e){
                throw new AuraHandledException(e.getMessage());
            }
    }

    /**
    * @description Bubble sort financial data
    * @author Tawanda M. | 07-20-2021 
    * @param inputArr 
    * @return //Bubble 
    **/
    @AuraEnabled
    public static List<DebtCapacity_General_Controller.GeneralDataStructure> sortGeneralReqData(List<DebtCapacity_General_Controller.GeneralDataStructure> inputArr){
        try{
                Integer len = inputArr.size();
                for (Integer i = 0; i < len; i++) {
                    for (Integer j = 0; j < len; j++) {
                        if((j + 1) != len){
                            if (inputArr[j].debtCapacityInitialDTO.year < inputArr[j + 1].debtCapacityInitialDTO.year) {
                                DebtCapacity_General_Controller.GeneralDataStructure tmp = inputArr[j];
                                inputArr[j] = inputArr[j + 1];
                                inputArr[j + 1] = tmp;
                            }
                        }
                    }
                }
            return inputArr;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }

    /**
    * @description Bubble sort results data
    * @author Tawanda M. | 07-20-2021 
    * @param inputArr 
    * @return //Bubble 
    **/
    @AuraEnabled
    public static List<DebtCapacityGeneral_Resp_IB_v1.CalculationBaseDTOLs> sortGeneralRespData(List<DebtCapacityGeneral_Resp_IB_v1.CalculationBaseDTOLs> inputArr){
        try{
            Integer len = inputArr.size();
            for (Integer i = 0; i < len; i++) {
                for (Integer j = 0; j < len; j++) {
                    if((j + 1) != len){
                        if (inputArr[j].incomeRespStatementDTO.year < inputArr[j + 1].incomeRespStatementDTO.year) {
                            DebtCapacityGeneral_Resp_IB_v1.CalculationBaseDTOLs tmp = inputArr[j];
                            inputArr[j] = inputArr[j + 1];
                            inputArr[j + 1] = tmp;
                        }
                    }
                }
            }
            return inputArr;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description Asynchronously update opportunity with result
    * @author Tawanda M. | 08-30-2021 
    * @param resultString 
    * @param opportunityId 
    **/
    @future(callout=true)
    public static void saveResult(String resultString, String opportunityId){
        Opportunity opp = [Select Id, DC_General_Calculator_Response__c from Opportunity where Id =: opportunityId];
        opp.DC_General_Calculator_Response__c = resultString;
        Update opp;
    }

}