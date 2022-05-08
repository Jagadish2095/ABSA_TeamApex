/**
 * @description       : Class to handle data inputs for DC General Calculator
 * @author            : Amit G.
 * @group             : 
 * @last modified on  : 2021-09-28
 * @last modified by  : Tawanda M.
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   07-20-2021   Tawanda M.   Initial Version
**/
public class DebtCapacity_General_Controller {


    /**
    * @description Structure to hold load data independant of financial data
    * @author Tawanda M. | 07-20-2021 
    **/
	public class LoanBucket {
        @AuraEnabled
		public String loanType;
        @AuraEnabled
		public Decimal loanAmount;
        @AuraEnabled
		public Integer term;
        @AuraEnabled
		public Decimal intrestRate;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param loanType 
        * @param loanAmount 
        * @param term 
        * @param intrestRate 
        **/
        public LoanBucket(String loanType, Decimal loanAmount, Integer term, Decimal intrestRate){
            this.loanType = loanType;
            this.loanAmount = loanAmount;
            this.term = term;
            this.intrestRate = intrestRate;
        }
	}

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class ReturnedGeneralData{
        @AuraEnabled
        public List<GeneralDataStructure> GeneralData;
        @AuraEnabled
        public Map<String, List<String>> data;
        @AuraEnabled
        public List<LoanBucket> loanData;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param GeneralData
        * @param data
        * @param loanData
        **/
        public ReturnedGeneralData(List<GeneralDataStructure> GeneralData, Map<String, List<String>> data, List<LoanBucket> loanData){
            this.GeneralData = GeneralData;
            this.data = data;
            this.loanData = loanData;
        }
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class GeneralDataStructure{
        @AuraEnabled
        public DebtCapacityInitialDTO debtCapacityInitialDTO;
        @AuraEnabled
        public IncomeStatementDTO incomeStatementDTO;
        @AuraEnabled
        public CashflowStatementDTO cashflowStatementDTO;
        @AuraEnabled
        public BalanceSheetDTO balanceSheetDTO;
        @AuraEnabled
        public MinimumAnnualPaymentsDTO minimumAnnualPaymentsDTO;
        @AuraEnabled
        public LoanDetailsDTO loanDetailsDTO;
        @AuraEnabled
        public OverdraftFacilityDTO overdraftFacilityDTO;
        @AuraEnabled
        public PresentKeyRatiosDTO presentKeyRatiosDTO;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param debtCapacityInitialDTO
        * @param incomeStatementDTO
        * @param cashflowStatementDTO
        * @param balanceSheetDTO
        * @param minimumAnnualPaymentsDTO
        * @param presentKeyRatiosDTO
        **/
        public GeneralDataStructure(
            DebtCapacityInitialDTO debtCapacityInitialDTO, 
            IncomeStatementDTO incomeStatementDTO, 
            CashflowStatementDTO cashflowStatementDTO,
            BalanceSheetDTO balanceSheetDTO,
            MinimumAnnualPaymentsDTO minimumAnnualPaymentsDTO,
            /* LoanDetailsDTO loanDetailsDTO,
            OverdraftFacilityDTO overdraftFacilityDTO, */
            PresentKeyRatiosDTO presentKeyRatiosDTO){
                this.debtCapacityInitialDTO = debtCapacityInitialDTO;
                this.incomeStatementDTO = incomeStatementDTO;
                this.cashflowStatementDTO = cashflowStatementDTO;
                this.balanceSheetDTO = balanceSheetDTO;
                this.minimumAnnualPaymentsDTO = minimumAnnualPaymentsDTO;
                /* this.loanDetailsDTO = loanDetailsDTO;
                this.overdraftFacilityDTO = overdraftFacilityDTO; */
                this.presentKeyRatiosDTO = presentKeyRatiosDTO;
        }
    }

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class BalanceSheetDTO {
        @AuraEnabled
		public GeneralBalanceSheetDTO GeneralBalanceSheetDTO;
        @AuraEnabled
		public Decimal intangibleAssets;
        @AuraEnabled
		public Decimal cash;
        @AuraEnabled
		public Decimal loans;
        @AuraEnabled
		public Decimal cpfOfBonds;
        @AuraEnabled
		public Decimal caf;
        @AuraEnabled
		public Decimal interCoLoans;
        @AuraEnabled
		public Decimal shareholdersLoans;
        @AuraEnabled
		public Decimal overdrafts;
        @AuraEnabled
		public Decimal other;
        @AuraEnabled
		public Decimal equity;
        @AuraEnabled
		public Decimal totalAssets;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param GeneralBalanceSheetDTO
        * @param intangibleAssets
        * @param cash
        * @param loans
        * @param cpfOfBonds
        * @param caf
        * @param interCoLoans
        * @param shareholdersLoans
        * @param overdrafts
        * @param other
        * @param equity
        * @param totalAssets
        **/
        public BalanceSheetDTO(
            GeneralBalanceSheetDTO GeneralBalanceSheetDTO, 
            Decimal intangibleAssets, 
            Decimal cash, 
            Decimal loans, 
            Decimal cpfOfBonds, 
            Decimal caf, 
            Decimal interCoLoans, 
            Decimal shareholdersLoans, 
            Decimal overdrafts, 
            Decimal other, 
            Decimal equity, 
            Decimal totalAssets){
                this.GeneralBalanceSheetDTO = GeneralBalanceSheetDTO;
                this.intangibleAssets = intangibleAssets;
                this.cash = cash;
                this.loans = loans;
                this.cpfOfBonds = cpfOfBonds;
                this.caf = caf;
                this.interCoLoans = interCoLoans;
                this.shareholdersLoans = shareholdersLoans;
                this.overdrafts = overdrafts;
                this.other = other;
                this.equity = equity;
                this.totalAssets = totalAssets;
            }
	}

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
    public class GeneralBalanceSheetDTO {
        @AuraEnabled
		public Decimal assets;
        @AuraEnabled
		public Decimal lowerOfPurchasePriceValuation;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param assets
        * @param lowerOfPurchasePriceValuation
        **/
        public GeneralBalanceSheetDTO(Decimal assets, Decimal lowerOfPurchasePriceValuation){
            this.assets = assets;
            this.lowerOfPurchasePriceValuation = lowerOfPurchasePriceValuation;
        }
	}

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
	public class CashflowStatementDTO {
        @AuraEnabled
		public Decimal grossInterestPaid;
        @AuraEnabled
		public Decimal netIncreaseDecreaseWorkingCapital;
        @AuraEnabled
		public Decimal taxPaidReceived;
        @AuraEnabled
		public Decimal divdendPaidRecieved;
        @AuraEnabled
		public Decimal capex;
        @AuraEnabled
		public Decimal freeCashFlow;
        @AuraEnabled
		public Decimal receivables;
        @AuraEnabled
		public Decimal payables;
        @AuraEnabled
		public Decimal inventory;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param grossInterestPaid
        * @param netIncreaseDecreaseWorkingCapital
        * @param taxPaidReceived
        * @param divdendPaidRecieved
        * @param capex
        * @param receivables
        * @param payables
        * @param inventory
        * @param freeCashFlow
        **/
        public CashflowStatementDTO(
            Decimal grossInterestPaid, 
            Decimal netIncreaseDecreaseWorkingCapital, 
            Decimal taxPaidReceived, 
            Decimal divdendPaidRecieved, 
            Decimal capex,
            Decimal receivables,
            Decimal payables,
            Decimal inventory,
            Decimal freeCashFlow){
                this.grossInterestPaid = grossInterestPaid;
                this.netIncreaseDecreaseWorkingCapital = netIncreaseDecreaseWorkingCapital;
                this.taxPaidReceived = taxPaidReceived;
                this.divdendPaidRecieved = divdendPaidRecieved;
                this.capex = capex;
                this.freeCashFlow = freeCashFlow;
                this.receivables = receivables;
                this.inventory = inventory;
                this.payables = payables;
        }
	}

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
	public class DebtCapacityInitialDTO {
        @AuraEnabled
		public Integer tenure;
        @AuraEnabled
		public Integer year;
        @AuraEnabled
		public String statementDate;
        @AuraEnabled
		public Integer GeneralType;
        @AuraEnabled
		public String currenctDGBucket;
        @AuraEnabled
		public Boolean useInCalculation;
        @AuraEnabled
		public String clientName;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param tenure 
        * @param year 
        * @param statementDate 
        * @param GeneralType 
        * @param currenctDGBucket
        * @param useInCalculation
        * @param clientName
        **/
        public DebtCapacityInitialDTO(
            Integer tenure, 
            Integer year, 
            String statementDate, 
            Integer GeneralType, 
            String currenctDGBucket,
            Boolean useInCalculation,
            String clientName){
            this.tenure = tenure;
            this.year = year;
            this.statementDate = statementDate;
            this.GeneralType = GeneralType;
            this.currenctDGBucket = currenctDGBucket;
            this.useInCalculation = useInCalculation;
            this.clientName = clientName;
        }
	}

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
	public class IncomeStatementDTO {
        @AuraEnabled
		public Decimal saleAmount;
        @AuraEnabled
		public Decimal depreciationAmortAmount;
        @AuraEnabled
		public Decimal netProfit;
        @AuraEnabled
		public Decimal rentExpense;
        @AuraEnabled
		public Integer nonRecurringEvents;
        @AuraEnabled
		public Decimal ebit;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param saleAmount 
        * @param depreciationAmortAmount 
        * @param netProfit 
        * @param rentExpense 
        * @param nonRecurringEvents 
        * @param ebit
        **/
        public IncomeStatementDTO(
            Integer saleAmount, 
            Integer depreciationAmortAmount, 
            Integer netProfit, 
            Integer rentExpense, 
            Integer nonRecurringEvents, 
            Integer ebit){
                this.saleAmount = saleAmount;
                this.depreciationAmortAmount = depreciationAmortAmount;
                this.netProfit = netProfit;
                this.rentExpense = rentExpense;
                this.nonRecurringEvents = nonRecurringEvents;
                this.ebit = ebit;
        }
	}

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
	public class LoanDetailsDTO {
        @AuraEnabled
		public String loanType;
        @AuraEnabled
		public Decimal loanAmount;
        @AuraEnabled
		public Integer term;
        @AuraEnabled
		public Decimal intrestRate;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param loanType
        * @param loanAmount
        * @param term
        * @param intrestRate
        **/
        public LoanDetailsDTO(String loanType, Decimal loanAmount, Integer term, Decimal intrestRate){
            this.loanType = loanType;
            this.loanAmount = loanAmount;
            this.term = term;
            this.intrestRate = intrestRate;
        }
	}

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
	public class PresentKeyRatiosDTO {
        @AuraEnabled
		public Integer dgBucket;
        @AuraEnabled
		public Integer termInmonths;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param dgBucket
        * @param termInmonths
        **/
        public PresentKeyRatiosDTO(Integer dgBucket, Integer termInmonths){
            this.dgBucket = dgBucket;
            this.termInmonths = termInmonths;
        }
	}

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
	public class MinimumAnnualPaymentsDTO {
        @AuraEnabled
		public Integer previousYearCurrentPortion;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param previousYearCurrentPortion
        **/
        public MinimumAnnualPaymentsDTO(Integer previousYearCurrentPortion){
            this.previousYearCurrentPortion = previousYearCurrentPortion;
        }
	}

    /**
    * @description Structure Element
    * @author Tawanda M. | 07-20-2021 
    **/
	public class OverdraftFacilityDTO {
        @AuraEnabled
		public Decimal overdraftBalance;
        @AuraEnabled
		public Decimal overdraftTerm;
        @AuraEnabled
		public Decimal overdraftIntrestRate;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param overdraftBalance
        * @param overdraftTerm
        * @param overdraftIntrestRate
        **/
        public OverdraftFacilityDTO(Decimal overdraftBalance, Decimal overdraftTerm, Decimal overdraftIntrestRate){
            this.overdraftBalance = overdraftBalance;
            this.overdraftTerm = overdraftTerm;
            this.overdraftIntrestRate = overdraftIntrestRate;
        }
	}


    /**
    * @description Get New Input Data
    * @author Tawanda M. | 08-16-2021 
    * @return GeneralDataStructure 
    **/
    @AuraEnabled
    public static GeneralDataStructure getNewData(){
        try{
            //Init General Data
            MinimumAnnualPaymentsDTO minAnn = new MinimumAnnualPaymentsDTO(0);
            PresentKeyRatiosDTO presKey = new PresentKeyRatiosDTO(0,0);
            IncomeStatementDTO incState = new IncomeStatementDTO(0,0,0,0,0,0);
            DebtCapacityInitialDTO dcap = new DebtCapacityInitialDTO(0,0,'',0,'',false,'');
            CashflowStatementDTO cashFl = new CashflowStatementDTO(0,0,0,0,0,0,0,0,0);
            GeneralBalanceSheetDTO GeneralBalSh = new GeneralBalanceSheetDTO(0,0);
            BalanceSheetDTO balShDTO = new BalanceSheetDTO(GeneralBalSh, 0,0,0,0,0,0,0,0,0,0,0);

            GeneralDataStructure dataStructure = new GeneralDataStructure(dcap, incState, cashFl, balShDTO, minAnn, presKey);
            return dataStructure;
        }
        catch(Exception e){
            return null;
        }
    }

    /**
    * @description Method used to INIT Loan Data
    * @author Tawanda M. | 07-20-2021 
    * @return LoanDetailsDTO 
    **/
    @AuraEnabled
    public static LoanBucket getEmptyLoanData(){
        try{
            //Init Loan Data
            LoanBucket loanData = new LoanBucket('1', 0, 0, 0);
            return loanData;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description Save New Input Data
    * @author Tawanda M. | 08-16-2021 
    * @param data 
    * @param opportunityId 
    **/
    @AuraEnabled
    public static void saveNewData(String data, String opportunityId){
        GeneralDataStructure newData = (GeneralDataStructure) JSON.deserialize(data, GeneralDataStructure.class);

         Opportunity opp = [Select Id, DC_General_Calculator_Request__c from Opportunity where Id =: opportunityId];
         //Opportunity opp = [Select Id, DC_General_Calculator_Request__c from Opportunity where Id ='0065r0000031ALhAAM'];
        if(opp.DC_General_Calculator_Request__c == null){
            opp.DC_General_Calculator_Request__c = '{"data":{"channelCalculatorDTO":{"debtCapacityGeneralCalculatorDTO":{"generalDTOs":' + JSON.serialize(new List<GeneralDataStructure>{newData}) + '}}}}';
        }
        else{
            String requestData = opp.DC_General_Calculator_Request__c.replace('{"data":{"channelCalculatorDTO":{"debtCapacityGeneralCalculatorDTO":{"generalDTOs":','');
            requestData = requestData.substring(0, requestData.length() - 4);
            List<GeneralDataStructure> existingData = (List<GeneralDataStructure>) JSON.deserialize(requestData, List<GeneralDataStructure>.class);
            existingData.add(newData);
            opp.DC_General_Calculator_Request__c = '{"data":{"channelCalculatorDTO":{"debtCapacityGeneralCalculatorDTO":{"generalDTOs":' + JSON.serialize(existingData) + '}}}}';
        }
        Update opp;
    }

    /**
    * @description Edit Existing Data
    * @author Tawanda M. | 08-16-2021 
    * @param data 
    * @param opportunityId 
    **/
    @AuraEnabled
    public static void editExistData(String data, String opportunityId){
        List<GeneralDataStructure> existingData = (List<GeneralDataStructure>) JSON.deserialize(data, List<GeneralDataStructure>.class);
        existingData = sortGeneralReqData(existingData);
        Opportunity opp = [Select Id, DC_General_Calculator_Request__c from Opportunity where Id =: opportunityId];
        //Opportunity opp = [Select Id, DC_General_Calculator_Request__c from Opportunity where Id ='0065r0000031ALhAAM'];
        opp.DC_General_Calculator_Request__c = '{"data":{"channelCalculatorDTO":{"debtCapacityGeneralCalculatorDTO":{"generalDTOs":' + JSON.serialize(existingData) + '}}}}';
        Update opp;
    }

    /**
    * @description Save loan data seperately
    * @author Tawanda M. | 08-30-2021 
    * @param data 
    * @param opportunityId 
    **/
    @AuraEnabled
    public static void saveLoan(String data, String opportunityId){
        try{
            Opportunity opp = [Select Id, DC_General_Calculator_Request__c, DC_General_Loan_Bucket__c from Opportunity where Id =: opportunityId];
            opp.DC_General_Loan_Bucket__c = data;
            Update opp;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /**
    * @description Get Table Data
    * @author Tawanda M. | 08-16-2021 
    * @param opportunityId 
    * @return ReturnedGeneralData 
    **/
    @AuraEnabled
    public static ReturnedGeneralData getTableData(String opportunityId){
        Map<String, List<String>> tableData = new Map<String, List<String>>();
        //Set Maps
        tableData.put('Financial Statement Period Ending', new List<String>());
        tableData.put('Number of Months in Financial Statements', new List<String>());
        tableData.put('TTC DG Category', new List<String>());
        tableData.put('Income Statement', new List<String>());
        tableData.put('Sales', new List<String>());
        tableData.put('Depreciation / Amortisation', new List<String>());
        tableData.put('Earnings before interest & tax (EBIT) (+ / -)', new List<String>());
        tableData.put('Net Profit (+) / Loss (-)', new List<String>());
        tableData.put('Cash Flow Statement', new List<String>());
        tableData.put('Interest paid (+) / Interest received (-)', new List<String>());
        tableData.put('Tax paid (+) / Tax received (-)', new List<String>());
        tableData.put('Dividend paid (+) / Dividend received (-)', new List<String>());
        tableData.put('Receivables', new List<String>());
        tableData.put('Payables', new List<String>());
        tableData.put('Inventory', new List<String>());
        tableData.put('Capex (Maintain only; not Expand)', new List<String>());
        tableData.put('Balance Sheet', new List<String>());
        tableData.put('Intangible Assets', new List<String>());
        tableData.put('Total Assets', new List<String>());
        tableData.put('Cash', new List<String>());
        tableData.put('Loans', new List<String>());
        tableData.put('Current Portion of Previous Years IBD', new List<String>());
        tableData.put('CPF/Bonds', new List<String>());
        tableData.put('Inter-Co Loans', new List<String>());
        tableData.put('Shareholder\'s Loans', new List<String>());
        tableData.put('Overdrafts', new List<String>());
        tableData.put('Other', new List<String>());
        tableData.put('Equity', new List<String>());
        tableData.put('Include In Calculation', new List<String>());

         Opportunity opp =[Select Id, DC_General_Calculator_Request__c, DC_General_Loan_Bucket__c from Opportunity where Id =: opportunityId];
        //Opportunity opp = [Select Id, DC_General_Calculator_Request__c from Opportunity where Id ='0065r0000031ALhAAM']; 
        if(opp.DC_General_Calculator_Request__c != null){
            String requestData = opp.DC_General_Calculator_Request__c.replace('{"data":{"channelCalculatorDTO":{"debtCapacityGeneralCalculatorDTO":{"generalDTOs":','');
            requestData = requestData.substring(0, requestData.length() - 4);
            List<GeneralDataStructure> existingData = (List<GeneralDataStructure>) JSON.deserialize(requestData, List<GeneralDataStructure>.class);
            if(existingData.isEmpty()){
                return null;
            }
            for(GeneralDataStructure data : existingData){
                //Set table data
                  
               tableData.get('Financial Statement Period Ending').add(String.valueOf(data.debtCapacityInitialDTO.year));
                tableData.get('Number of Months in Financial Statements').add(String.valueOf(data.debtCapacityInitialDTO.tenure));
                tableData.get('TTC DG Category').add(String.valueOf(data.debtCapacityInitialDTO.currenctDGBucket));
                tableData.get('Income Statement').add(String.valueOf(''));
                tableData.get('Sales').add(String.valueOf(data.incomeStatementDTO.saleAmount));
                tableData.get('Depreciation / Amortisation').add(String.valueOf(data.incomeStatementDTO.depreciationAmortAmount));
                tableData.get('Earnings before interest & tax (EBIT) (+ / -)').add(String.valueOf(data.incomeStatementDTO.ebit));
                tableData.get('Net Profit (+) / Loss (-)').add(String.valueOf(data.incomeStatementDTO.netProfit));
                tableData.get('Cash Flow Statement').add(String.valueOf(''));
                tableData.get('Interest paid (+) / Interest received (-)').add(String.valueOf(data.cashflowStatementDTO.grossInterestPaid));
                tableData.get('Tax paid (+) / Tax received (-)').add(String.valueOf(data.cashflowStatementDTO.taxPaidReceived));
                tableData.get('Dividend paid (+) / Dividend received (-)').add(String.valueOf(data.cashflowStatementDTO.divdendPaidRecieved));
                tableData.get('Receivables').add(String.valueOf(data.cashflowStatementDTO.receivables));
                tableData.get('Payables').add(String.valueOf(data.cashflowStatementDTO.payables));
                tableData.get('Inventory').add(String.valueOf(data.cashflowStatementDTO.inventory));
                tableData.get('Capex (Maintain only; not Expand)').add(String.valueOf(data.cashflowStatementDTO.capex));
                tableData.get('Balance Sheet').add(String.valueOf(''));
                tableData.get('Intangible Assets').add(String.valueOf(data.balanceSheetDTO.intangibleAssets));
                tableData.get('Total Assets').add(String.valueOf(data.balanceSheetDTO.totalAssets));
                tableData.get('Cash').add(String.valueOf(data.balanceSheetDTO.cash));
                tableData.get('Loans').add(String.valueOf(data.balanceSheetDTO.loans));
                tableData.get('Current Portion of Previous Years IBD').add(String.valueOf(data.minimumAnnualPaymentsDTO.previousYearCurrentPortion));
                tableData.get('CPF/Bonds').add(String.valueOf(data.balanceSheetDTO.cpfOfBonds));
                tableData.get('Inter-Co Loans').add(String.valueOf(data.balanceSheetDTO.interCoLoans));
                tableData.get('Shareholder\'s Loans').add(String.valueOf(data.balanceSheetDTO.shareholdersLoans));
                tableData.get('Overdrafts').add(String.valueOf(data.balanceSheetDTO.overdrafts));
                tableData.get('Other').add(String.valueOf(data.balanceSheetDTO.other));
                tableData.get('Equity').add(String.valueOf(data.balanceSheetDTO.equity));
                tableData.get('Include In Calculation').add(String.valueOf(data.debtCapacityInitialDTO.useInCalculation));
            }
            List<LoanBucket> currentLoans = new List<LoanBucket>();
            if(opp.DC_General_Loan_Bucket__c != null){
                currentLoans = (List<LoanBucket>) JSON.deserialize(opp.DC_General_Loan_Bucket__c ,List<LoanBucket>.class);
            }
            return new ReturnedGeneralData(existingData,tableData, currentLoans);
        }
        else{
            return null;
        }
    }

    
    /**
    * @description Sort Data
    * @author Tawanda M. | 08-16-2021 
    * @param inputArr 
    * @return List<GeneralDataStructure> 
    **/
    public static List<GeneralDataStructure> sortGeneralReqData(List<GeneralDataStructure> inputArr){
        Integer len = inputArr.size();
            for (Integer i = 0; i < len; i++) {
                for (Integer j = 0; j < len; j++) {
                    if((j + 1) != len){
                        if (inputArr[j].debtCapacityInitialDTO.year < inputArr[j + 1].debtCapacityInitialDTO.year) {
                            GeneralDataStructure tmp = inputArr[j];
                            inputArr[j] = inputArr[j + 1];
                            inputArr[j + 1] = tmp;
                        }
                    }
                }
            }
        return inputArr;
    }
}