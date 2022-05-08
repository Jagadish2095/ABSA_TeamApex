/**
 * @description       : Class that houses Aura methods for DebtCapacity MBBL calculator
 * @author            : Tawanda M.
 * @group             : 
 * @last modified on  : 09-28-2021
 * @last modified by  : Tawanda M.
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   19-07-2021   Tawanda M.   Initial Version
**/
public class DebtCapacity_MBBL_Controller {

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
    * @description Custom Exception Class
    * @author Tawanda M. | 07-20-2021 
    **/
    public class MBBLException extends Exception{}

    public static final Map<Integer, String> MBBLTypes = new Map<Integer, String>{
        1 => 'Specialised',
        2 => 'Non Specialised'
    };

    public static final Map<Integer, String> PropertyTypes = new Map<Integer, String>{
        1 => 'Below Average',
        2 => 'Average',
        3 => 'Above Average'
    };

    public static final Map<String, String> LoanTypes = new Map<String, String>{
        '1' => 'Term Loan',
        '2' => 'CPF',
        '3' => 'MBBL',
        '4' => 'CAF',
        '5' => 'Overdraft'
    };

    /**
    * @description Response Wrapper for MBBL Callout
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
    * @description Response Wrapper for MBBL Callout sent to Aura component
    * @author Tawanda M. | 07-20-2021 
    **/
    public class CalculateMBBLResult{
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
        public CalculateMBBLResult(Boolean success, List<String> message, CalculateResponseWrappper data){
            this.success = success;
            this.message = message;
            this.data = data;
        }
    }

    /**
    * @description MBBL Input Data returned to Aura component
    * @author Tawanda M. | 07-20-2021 
    **/
    public class ReturnedMBBLData{
        @AuraEnabled
        public List<MBBLDataStructure> mbblData;
        @AuraEnabled
        public Map<String, List<String>> data;
        @AuraEnabled
        public List<LoanBucket> loanData;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param mbblData
        * @param data
        * @param loanData
        **/
        public ReturnedMBBLData(List<MBBLDataStructure> mbblData, Map<String, List<String>> data, List<LoanBucket> loanData){
            this.mbblData = mbblData;
            this.data = data;
            this.loanData = loanData;
        }
    }

    /**
    * @description MBBL Data Structure
    * @author Tawanda M. | 07-20-2021 
    **/
    public class MBBLDataStructure{
        @AuraEnabled
        public Integer propertyRatings;
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
        /* @AuraEnabled
        public LoanDetailsDTO loanDetailsDTO;
        @AuraEnabled
        public OverdraftFacilityDTO overdraftFacilityDTO; */
        @AuraEnabled
        public PresentKeyRatiosDTO presentKeyRatiosDTO;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param propertyRatings
        * @param debtCapacityInitialDTO
        * @param incomeStatementDTO
        * @param cashflowStatementDTO
        * @param balanceSheetDTO
        * @param minimumAnnualPaymentsDTO
        * @param presentKeyRatiosDTO
        **/
        public MBBLDataStructure(
            Integer propertyRatings,
            DebtCapacityInitialDTO debtCapacityInitialDTO, 
            IncomeStatementDTO incomeStatementDTO, 
            CashflowStatementDTO cashflowStatementDTO,
            BalanceSheetDTO balanceSheetDTO,
            MinimumAnnualPaymentsDTO minimumAnnualPaymentsDTO,
            /* LoanDetailsDTO loanDetailsDTO,
            OverdraftFacilityDTO overdraftFacilityDTO, */
            PresentKeyRatiosDTO presentKeyRatiosDTO){
                this.propertyRatings = propertyRatings;
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
    * @description Part of MBBL Data Structure
    * @author Tawanda M. | 07-20-2021 
    **/
    public class BalanceSheetDTO {
        @AuraEnabled
		public MbblBalanceSheetDTO mbblBalanceSheetDTO;
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
        * @param mbblBalanceSheetDTO 
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
            MbblBalanceSheetDTO mbblBalanceSheetDTO, 
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
                this.mbblBalanceSheetDTO = mbblBalanceSheetDTO;
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
    * @description Part of MBBL Data Structure
    * @author Tawanda M. | 07-20-2021 
    **/
    public class MbblBalanceSheetDTO {
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
        public MbblBalanceSheetDTO(Decimal assets, Decimal lowerOfPurchasePriceValuation){
            this.assets = assets;
            this.lowerOfPurchasePriceValuation = lowerOfPurchasePriceValuation;
        }
	}

    /**
    * @description Part of MBBL Data Structure
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
        * @param receivables
        * @param payables
        * @param inventory
        * @param capex 
        **/
        public CashflowStatementDTO(
            Decimal grossInterestPaid, 
            Decimal netIncreaseDecreaseWorkingCapital, 
            Decimal taxPaidReceived, 
            Decimal divdendPaidRecieved, 
            Decimal receivables,
            Decimal payables,
            Decimal inventory,
            Decimal capex){
                this.grossInterestPaid = grossInterestPaid;
                this.netIncreaseDecreaseWorkingCapital = netIncreaseDecreaseWorkingCapital;
                this.taxPaidReceived = taxPaidReceived;
                this.divdendPaidRecieved = divdendPaidRecieved;
                this.capex = capex;
                this.receivables = receivables;
                this.inventory = inventory;
                this.payables = payables;
        }
	}

    /**
    * @description Part of MBBL Data Structure
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
		public Integer mbblType;
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
        * @param mbblType 
        * @param currenctDGBucket 
        * @param useInCalculation 
        * @param clientName 
        **/
        public DebtCapacityInitialDTO(
            Integer tenure, 
            Integer year, 
            String statementDate, 
            Integer mbblType, 
            String currenctDGBucket,
            Boolean useInCalculation,
            String clientName){
            this.tenure = tenure;
            this.year = year;
            this.statementDate = statementDate;
            this.mbblType = mbblType;
            this.currenctDGBucket = currenctDGBucket;
            this.useInCalculation = useInCalculation;
            this.clientName = clientName;
        }
	}

    /**
    * @description Part of MBBL Data Structure
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
		public Decimal nonRecurringEvents;
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
            Decimal saleAmount, 
            Decimal depreciationAmortAmount, 
            Decimal netProfit, 
            Decimal rentExpense, 
            Decimal nonRecurringEvents, 
            Decimal ebit){
                this.saleAmount = saleAmount;
                this.depreciationAmortAmount = depreciationAmortAmount;
                this.netProfit = netProfit;
                this.rentExpense = rentExpense;
                this.nonRecurringEvents = nonRecurringEvents;
                this.ebit = ebit;
        }
	}

    /**
    * @description Part of MBBL Data Structure
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
    * @description Part of MBBL Data Structure
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
    * @description Part of MBBL Data Structure
    * @author Tawanda M. | 07-20-2021 
    **/
	public class MinimumAnnualPaymentsDTO {
        @AuraEnabled
		public Decimal previousYearCurrentPortion;

        /**
        * @description Constructor
        * @author Tawanda M. | 07-20-2021 
        * @param previousYearCurrentPortion 
        **/
        public MinimumAnnualPaymentsDTO(Decimal previousYearCurrentPortion){
            this.previousYearCurrentPortion = previousYearCurrentPortion;
        }
	}

    /**
    * @description Part of MBBL Data Structure
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
    * @description Method used to INIT financial data
    * @author Tawanda M. | 07-20-2021 
    * @return MBBLDataStructure 
    **/
    @AuraEnabled
    public static MBBLDataStructure getEmptyMBBLData(){
        try{
            //Init MBBL Data
            OverdraftFacilityDTO overFac = new OverdraftFacilityDTO(0,0,0);
            MinimumAnnualPaymentsDTO minAnn = new MinimumAnnualPaymentsDTO(0);
            PresentKeyRatiosDTO presKey = new PresentKeyRatiosDTO(0,0);
            LoanDetailsDTO loanDet = new LoanDetailsDTO('1',0,0,0);
            IncomeStatementDTO incState = new IncomeStatementDTO(0,0,0,0,0,0);
            DebtCapacityInitialDTO dcap = new DebtCapacityInitialDTO(0,0,'',1,'',false,'');
            CashflowStatementDTO cashFl = new CashflowStatementDTO(0,0,0,0,0,0,0,0);
            MbblBalanceSheetDTO mbblBalSh = new MbblBalanceSheetDTO(0,0);
            BalanceSheetDTO balShDTO = new BalanceSheetDTO(mbblBalSh, 0,0,0,0,0,0,0,0,0,0,0);

            MBBLDataStructure dataStructure = new MBBLDataStructure(1, dcap, incState, cashFl, balShDTO, minAnn, presKey);
            return dataStructure;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
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
    * @description Method used to save new finanical data
    * @author Tawanda M. | 07-20-2021 
    * @param data 
    * @param opportunityId 
    **/
    @AuraEnabled
    public static void saveNewData(String data, String opportunityId){
        try{
            MBBLDataStructure newData = (MBBLDataStructure) JSON.deserialize(data, MBBLDataStructure.class);

            Opportunity opp = [Select Id, DC_MBBL_Calculator_Request__c from Opportunity where Id =: opportunityId];
            if(opp != null){
                if(opp.DC_MBBL_Calculator_Request__c == null){
                    opp.DC_MBBL_Calculator_Request__c = '{"data":{"channelCalculatorDTO":{"debtCapacityMbblCalculatorDTO":{"mbblDTOs":' + JSON.serialize(new List<MBBLDataStructure>{newData}) + '}}}}';
                }
                else{
                    String requestData = opp.DC_MBBL_Calculator_Request__c.replace('{"data":{"channelCalculatorDTO":{"debtCapacityMbblCalculatorDTO":{"mbblDTOs":','');
                    requestData = requestData.substring(0, requestData.length() - 4);
                    List<MBBLDataStructure> existingData = (List<MBBLDataStructure>) JSON.deserialize(requestData, List<MBBLDataStructure>.class);
                    existingData.add(newData);
                    existingData = sortMBBLReqData(existingData);
                    opp.DC_MBBL_Calculator_Request__c = '{"data":{"channelCalculatorDTO":{"debtCapacityMbblCalculatorDTO":{"mbblDTOs":' + JSON.serialize(existingData) + '}}}}';
                }
                Update opp;
            }
            else{
                throw new MBBLException('There is no opportunity with this ID');
            }
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description Method called from Aura that provides full data structure for all financial years and places it into the field on record
    * @author Tawanda M. | 07-20-2021 
    * @param data 
    * @param opportunityId 
    **/
    @AuraEnabled
    public static void editExistData(String data, String opportunityId){
        try{
            List<MBBLDataStructure> existingData = (List<MBBLDataStructure>) JSON.deserialize(data, List<MBBLDataStructure>.class);
            existingData = sortMBBLReqData(existingData);
            Opportunity opp = [Select Id, DC_MBBL_Calculator_Request__c from Opportunity where Id =: opportunityId];
            if(opp != null){
                opp.DC_MBBL_Calculator_Request__c = '{"data":{"channelCalculatorDTO":{"debtCapacityMbblCalculatorDTO":{"mbblDTOs":' + JSON.serialize(existingData) + '}}}}';
                Update opp;
            }
            else{
                throw new MBBLException('There is no opportunity with this ID');
            }
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
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
            Opportunity opp = [Select Id, DC_MBBL_Calculator_Request__c, DC_MBBL_Loan_Bucket__c from Opportunity where Id =: opportunityId];
            opp.DC_MBBL_Loan_Bucket__c = data;
            Update opp;
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
    * @description Fetch iterable table data for calculator inputs
    * @author Tawanda M. | 07-20-2021 
    * @param opportunityId 
    * @return ReturnedMBBLData 
    **/
    @AuraEnabled
    public static ReturnedMBBLData getTableData(String opportunityId){
        try{
            Map<String, List<String>> tableData = new Map<String, List<String>>();
            //Set Maps
            tableData.put('Financial Statement Period Ending', new List<String>());
            tableData.put('Number of Months in Financial Statements', new List<String>());
            tableData.put('TTC DG Category', new List<String>());
            tableData.put('MBBL Type', new List<String>());
            tableData.put('Property Rating', new List<String>());
            tableData.put('Income Statement', new List<String>());
            tableData.put('Sales', new List<String>());
            tableData.put('Depreciation / Amortisation', new List<String>());
            // tableData.put('Earnings before interest & tax (EBIT) (+ / -)', new List<String>());
            tableData.put('Rent Expense', new List<String>());
            tableData.put('Non-recurring income (-) / Non-recurring expenses (+)', new List<String>());
            tableData.put('Net Profit (+) / Loss (-)', new List<String>());
            tableData.put('Cash Flow Statement', new List<String>());
            tableData.put('Interest paid (+) / Interest received (-)', new List<String>());
            tableData.put('Tax Paid / Received', new List<String>());
            tableData.put('Dividend paid / received', new List<String>());
            tableData.put('Receivables', new List<String>());
            tableData.put('Payables', new List<String>());
            tableData.put('Inventory', new List<String>());
            tableData.put('Balance Sheet', new List<String>());
            tableData.put('Assets', new List<String>());
            tableData.put('Cash', new List<String>());
            tableData.put('Lower of Purchase Price / Valuation', new List<String>());
            tableData.put('Intangible Assets', new List<String>());
            tableData.put('Loans', new List<String>());
            tableData.put('CPF/Bonds', new List<String>());
            tableData.put('CAF', new List<String>());
            tableData.put('Inter-Co Loans', new List<String>());
            tableData.put('Shareholder\'s Loans', new List<String>());
            tableData.put('Overdraft', new List<String>());
            tableData.put('Other', new List<String>());
            tableData.put('Equity', new List<String>());
            tableData.put('Minimum Annual Payments (MAP)', new List<String>());
            tableData.put('Previous Year\'s Current Portion', new List<String>());
            // tableData.put('Present Key Ratios', new List<String>());
            // tableData.put('DG Bucket', new List<String>());
            // tableData.put('Terms In Months', new List<String>());
            tableData.put('Include In Calculation', new List<String>());

            Opportunity opp = [Select Id, DC_MBBL_Calculator_Request__c, DC_MBBL_Loan_Bucket__c from Opportunity where Id =: opportunityId];
            if(opp.DC_MBBL_Calculator_Request__c != null){
                String requestData = opp.DC_MBBL_Calculator_Request__c.replace('{"data":{"channelCalculatorDTO":{"debtCapacityMbblCalculatorDTO":{"mbblDTOs":','');
                requestData = requestData.substring(0, requestData.length() - 4);
                List<MBBLDataStructure> existingData = (List<MBBLDataStructure>) JSON.deserialize(requestData, List<MBBLDataStructure>.class);
                if(existingData.isEmpty()){
                    return null;
                }
                //Sort
                existingData = sortMBBLReqData(existingData);
                for(MBBLDataStructure data : existingData){
                    //Set table data
                    tableData.get('Financial Statement Period Ending').add(String.valueOf(data.debtCapacityInitialDTO.year));
                    tableData.get('Number of Months in Financial Statements').add(String.valueOf(data.debtCapacityInitialDTO.tenure));
                    tableData.get('TTC DG Category').add(String.valueOf(data.debtCapacityInitialDTO.currenctDGBucket));
                    tableData.get('MBBL Type').add(MBBLTypes.get(data.debtCapacityInitialDTO.mbblType));
                    tableData.get('Property Rating').add(PropertyTypes.get(data.propertyRatings));
                    tableData.get('Income Statement').add(String.valueOf(''));
                    tableData.get('Sales').add(String.valueOf(data.incomeStatementDTO.saleAmount));
                    tableData.get('Depreciation / Amortisation').add(String.valueOf(data.incomeStatementDTO.depreciationAmortAmount));
                    // tableData.get('Earnings before interest & tax (EBIT) (+ / -)').add(String.valueOf(data.incomeStatementDTO.ebit));
                    tableData.get('Rent Expense').add(String.valueOf(data.incomeStatementDTO.rentExpense));
                    tableData.get('Non-recurring income (-) / Non-recurring expenses (+)').add(String.valueOf(data.incomeStatementDTO.nonRecurringEvents));
                    tableData.get('Net Profit (+) / Loss (-)').add(String.valueOf(data.incomeStatementDTO.netProfit));
                    tableData.get('Cash Flow Statement').add(String.valueOf(''));
                    tableData.get('Interest paid (+) / Interest received (-)').add(String.valueOf(data.cashflowStatementDTO.grossInterestPaid));
                    tableData.get('Tax Paid / Received').add(String.valueOf(data.cashflowStatementDTO.taxPaidReceived));
                    tableData.get('Dividend paid / received').add(String.valueOf(data.cashflowStatementDTO.divdendPaidRecieved));
                    tableData.get('Receivables').add(String.valueOf(data.cashflowStatementDTO.receivables));
                    tableData.get('Payables').add(String.valueOf(data.cashflowStatementDTO.payables));
                    tableData.get('Inventory').add(String.valueOf(data.cashflowStatementDTO.inventory));
                    tableData.get('Balance Sheet').add(String.valueOf(''));
                    tableData.get('Assets').add(String.valueOf(data.balanceSheetDTO.mbblBalanceSheetDTO.assets));
                    tableData.get('Cash').add(String.valueOf(data.balanceSheetDTO.cash));
                    tableData.get('Lower of Purchase Price / Valuation').add(String.valueOf(data.balanceSheetDTO.mbblBalanceSheetDTO.lowerOfPurchasePriceValuation));
                    tableData.get('Intangible Assets').add(String.valueOf(data.balanceSheetDTO.intangibleAssets));
                    tableData.get('Loans').add(String.valueOf(data.balanceSheetDTO.loans));
                    tableData.get('CPF/Bonds').add(String.valueOf(data.balanceSheetDTO.cpfOfBonds));
                    tableData.get('CAF').add(String.valueOf(data.balanceSheetDTO.caf));
                    tableData.get('Inter-Co Loans').add(String.valueOf(data.balanceSheetDTO.interCoLoans));
                    tableData.get('Shareholder\'s Loans').add(String.valueOf(data.balanceSheetDTO.shareholdersLoans));
                    tableData.get('Overdraft').add(String.valueOf(data.balanceSheetDTO.overdrafts));
                    tableData.get('Other').add(String.valueOf(data.balanceSheetDTO.other));
                    tableData.get('Equity').add(String.valueOf(data.balanceSheetDTO.equity));
                    tableData.get('Minimum Annual Payments (MAP)').add(String.valueOf(''));
                    tableData.get('Previous Year\'s Current Portion').add(String.valueOf(data.minimumAnnualPaymentsDTO.previousYearCurrentPortion));
                    // tableData.get('Present Key Ratios').add(String.valueOf(''));
                    //  tableData.get('DG Bucket').add(String.valueOf(data.presentKeyRatiosDTO.dgBucket));
                    //  tableData.get('Terms In Months').add(String.valueOf(data.presentKeyRatiosDTO.termInmonths));
                    tableData.get('Include In Calculation').add(String.valueOf(data.debtCapacityInitialDTO.useInCalculation));
                }
                List<LoanBucket> currentLoans = new List<LoanBucket>();
                if(opp.DC_MBBL_Loan_Bucket__c != null){
                    currentLoans = (List<LoanBucket>) JSON.deserialize(opp.DC_MBBL_Loan_Bucket__c ,List<LoanBucket>.class);
                }
                return new ReturnedMBBLData(existingData,tableData, currentLoans);
            }
            else{
                return null;
            }
        }
        catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }

    
    /**
    * @description Method used to parse response data from Jitterbit endpoint into iterable structure for aura component
    * @author Tawanda M. | 09-28-2021 
    * @param respParsedData 
    * @param opportunityId 
    * @param currentRequestData 
    * @param loansList 
    * @param ovrFacility 
    * @return CalculateResponseWrappper 
    **/
    @AuraEnabled
    public static CalculateResponseWrappper getRespData(DebtCapacityMBBL_Resp_IB_v1 respParsedData, String opportunityId, String currentRequestData, List<LoanDetailsDTO> loansList, OverdraftFacilityDTO ovrFacility){
        try{
            Map<String, List<String>> tableData = new Map<String, List<String>>();
            Map<String, List<String>> loanTableData = new Map<String, List<String>>();
            Map<String, List<String>> keyRatiosTableData = new Map<String, List<String>>();
            //Set Maps
            tableData.put('TTC DG Category', new List<String>());
            tableData.put('MBBL Type', new List<String>());
            tableData.put('Number of Months in Financial Statements', new List<String>());
            tableData.put('Items', new List<String>());
            tableData.put('Income Statement', new List<String>());
            tableData.put('Sales', new List<String>());
            tableData.put('EBITDA', new List<String>());
            tableData.put('Depreciation / Amortisation', new List<String>());
            tableData.put('Earnings before interest & tax (EBIT) (+ / -)', new List<String>());
            tableData.put('Rent Expense', new List<String>());
            tableData.put('Net Profit (+) / Loss (-)', new List<String>());
            tableData.put('Cash Flow Statement', new List<String>());
            tableData.put('Interest paid (+) / Interest received (-)', new List<String>());
            tableData.put('Net increase(+) / decrease (-) in Working Capital', new List<String>());
            tableData.put('Tax paid (+) / Tax received (-)', new List<String>());
            tableData.put('Dividend paid (+) /Dividend received (-)', new List<String>());
            tableData.put('Free Cash Flow', new List<String>());
            tableData.put('Balance Sheet', new List<String>());
            tableData.put('Intangible Assets', new List<String>());
            tableData.put('Total Assets', new List<String>());
            tableData.put('Assets', new List<String>());
            tableData.put('Existing Interest Bearing Debt (IBD)', new List<String>());
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
            tableData.put('Interest Bearing Debt: Equity', new List<String>());
            tableData.put('IBD/EBITDA', new List<String>());
            tableData.put('Operating Profit Margin', new List<String>());
            tableData.put('LTV Non Specialised', new List<String>());
            tableData.put('LTV Specialised', new List<String>());
            tableData.put('Interest Cover Ratio (ICR) = (EBIT / Net Int Paid)', new List<String>());
            tableData.put('Property Ratings', new List<String>());

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
            keyRatiosTableData.put('Max IBD/EBITDA', new List<String>());
            keyRatiosTableData.put('DG Bucket of the Trading Entity', new List<String>());
            keyRatiosTableData.put('Max Term', new List<String>());
            keyRatiosTableData.put('Max LTV Non Specialised', new List<String>());
            keyRatiosTableData.put('Max LTV Specialised', new List<String>());
            keyRatiosTableData.put('Property Ratings', new List<String>());
            keyRatiosTableData.put('Debt Service Cover Ratio', new List<String>());

            //Opportunity opp = [Select Id, DC_MBBL_Calculator_Request__c from Opportunity where Id =: opportunityId];
            //String mbblReqData = opp.DC_MBBL_Calculator_Request__c.replace('{"data":{"channelCalculatorDTO":{"debtCapacityMbblCalculatorDTO":{"mbblDTOs":','');
            //mbblReqData = mbblReqData.substring(0, mbblReqData.length() - 4);
            List<MBBLDataStructure> requestData = (List<MBBLDataStructure>) JSON.deserialize(currentRequestData, List<MBBLDataStructure>.class);
            //Sort both request and result
            requestData = sortMBBLReqData(requestData);
            respParsedData.data.calculationBaseDTOLs = sortMBBLRespData(respParsedData.data.calculationBaseDTOLs);

            for(Integer i = 0; i < respParsedData.data.calculationBaseDTOLs.size(); i++){
                DebtCapacityMBBL_Resp_IB_v1.CalculationBaseDTOLs currentData = respParsedData.data.calculationBaseDTOLs[i];
                //Set table data
                //for each year, add to list the value and the annualised value next to each other, empty value if it does not exist
                tableData.get('TTC DG Category').add(String.valueOf(requestData[i].debtCapacityInitialDTO.currenctDGBucket));
                tableData.get('MBBL Type').add(MBBLTypes.get(requestData[i].debtCapacityInitialDTO.mbblType));
                tableData.get('Number of Months in Financial Statements').add(String.valueOf(requestData[i].debtCapacityInitialDTO.tenure));
                tableData.get('Items').add(String.valueOf('Audited AFS at ' + requestData[i].debtCapacityInitialDTO.year));
                tableData.get('Income Statement').add(String.valueOf(''));
                tableData.get('Sales').add(String.valueOf(requestData[i].incomeStatementDTO.saleAmount));
                tableData.get('EBITDA').add(String.valueOf(currentData.incomeRespStatementDTO.ebitA));
                tableData.get('Depreciation / Amortisation').add(String.valueOf(requestData[i].incomeStatementDTO.depreciationAmortAmount));
                tableData.get('Earnings before interest & tax (EBIT) (+ / -)').add(String.valueOf(currentData.incomeRespStatementDTO.ebit));
                tableData.get('Rent Expense').add(String.valueOf(requestData[i].incomeStatementDTO.rentExpense));
                tableData.get('Net Profit (+) / Loss (-)').add(String.valueOf(requestData[i].incomeStatementDTO.netProfit));
                tableData.get('Cash Flow Statement').add(String.valueOf(''));
                tableData.get('Interest paid (+) / Interest received (-)').add(String.valueOf(requestData[i].cashflowStatementDTO.grossInterestPaid));
                //Show value only on latest year
                if(i == 0){
                    tableData.get('Net increase(+) / decrease (-) in Working Capital').add(String.valueOf(currentData.cashFlowRespStatementDTO.netIncreaseDecreaseWorkingCapital));
                }
                else{
                    tableData.get('Net increase(+) / decrease (-) in Working Capital').add(String.valueOf(0));
                }
                tableData.get('Tax paid (+) / Tax received (-)').add(String.valueOf(requestData[i].cashflowStatementDTO.taxPaidReceived));
                tableData.get('Dividend paid (+) /Dividend received (-)').add(String.valueOf(requestData[i].cashflowStatementDTO.divdendPaidRecieved));
                tableData.get('Free Cash Flow').add(String.valueOf(currentData.cashFlowRespStatementDTO.freeCashFlow));
                tableData.get('Balance Sheet').add(String.valueOf(''));
                tableData.get('Intangible Assets').add(String.valueOf(requestData[i].balanceSheetDTO.intangibleAssets));
                tableData.get('Total Assets').add(String.valueOf(currentData.balanceSheetRespStatementDTO.totalAssets));
                tableData.get('Assets').add(String.valueOf(requestData[i].balanceSheetDTO.mbblBalanceSheetDTO.assets));
                tableData.get('Existing Interest Bearing Debt (IBD)').add(String.valueOf(currentData.balanceSheetRespStatementDTO.interestBearingDebt));
                tableData.get('Loans').add(String.valueOf(requestData[i].balanceSheetDTO.loans));
                tableData.get('CPF/Bonds').add(String.valueOf(requestData[i].balanceSheetDTO.cpfOfBonds));
                tableData.get('Inter-Co Loans').add(String.valueOf(requestData[i].balanceSheetDTO.interCoLoans));
                tableData.get('Shareholder\'s Loans').add(String.valueOf(requestData[i].balanceSheetDTO.shareholdersLoans));
                tableData.get('Overdrafts').add(String.valueOf(requestData[i].balanceSheetDTO.overdrafts));
                tableData.get('Other').add(String.valueOf(requestData[i].balanceSheetDTO.other));
                tableData.get('Total Equity').add(String.valueOf(currentData.balanceSheetRespStatementDTO.totalEquity));
                tableData.get('Minimum Annual Payments (MAP)').add(String.valueOf(currentData.minimumAnnualPaymentsRespDTO.minimumAnnualPayments));
                tableData.get('Interest Paid (for period)').add(String.valueOf(currentData.minimumAnnualPaymentsRespDTO.interestPaid));
                tableData.get('Current Portion of Previous Years IBD').add(String.valueOf(requestData[i].minimumAnnualPaymentsDTO.previousYearCurrentPortion));
                tableData.get('Present Key Ratios').add(String.valueOf(''));
                tableData.get('Interest Bearing Debt: Equity').add(String.valueOf(currentData.presentRatiosDTO.ibdEquityRatio));
                tableData.get('IBD/EBITDA').add(String.valueOf(currentData.presentRatiosDTO.ibdEbitaRatio));
                tableData.get('Operating Profit Margin').add(String.valueOf(currentData.presentRatiosDTO.opmRatio));
                tableData.get('LTV Non Specialised').add(String.valueOf(currentData.presentRatiosDTO.nonSpeciaRatio));
                tableData.get('LTV Specialised').add(String.valueOf(currentData.presentRatiosDTO.speciaRatio));
                tableData.get('Interest Cover Ratio (ICR) = (EBIT / Net Int Paid)').add(String.valueOf(currentData.presentRatiosDTO.icrRatio));
                tableData.get('Property Ratings').add(String.valueOf(currentData.presentRatiosDTO.propertyRating));

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
                    keyRatiosTableData.get('Max IBD/EBITDA').add(String.valueOf((respParsedData.data.expectedRatiosDTO.maxIBD == null) ? 0.0 : respParsedData.data.expectedRatiosDTO.maxIBD));
                    keyRatiosTableData.get('DG Bucket of the Trading Entity').add(String.valueOf(0.0));
                    keyRatiosTableData.get('Max Term').add(String.valueOf((respParsedData.data.expectedRatiosDTO.maxTerm == null) ? 0.0 : respParsedData.data.expectedRatiosDTO.maxTerm));
                    keyRatiosTableData.get('Max LTV Non Specialised').add(String.valueOf((respParsedData.data.expectedRatiosDTO.maxLtvNonSP == null) ? 0.0 : respParsedData.data.expectedRatiosDTO.maxLtvNonSP));
                    keyRatiosTableData.get('Max LTV Specialised').add(String.valueOf((respParsedData.data.expectedRatiosDTO.maxLtvSpecial == null) ? 0.0 : respParsedData.data.expectedRatiosDTO.maxLtvSpecial));
                    keyRatiosTableData.get('Property Ratings').add(String.valueOf((respParsedData.data.expectedRatiosDTO.propertyRating == null) ? '0.0' : respParsedData.data.expectedRatiosDTO.propertyRating));
                    keyRatiosTableData.get('Debt Service Cover Ratio').add(String.valueOf((respParsedData.data.expectedRatiosDTO.debtServiceCoverRation == null) ? 0.0 : respParsedData.data.expectedRatiosDTO.debtServiceCoverRation));
                }

                //Annualised Values
                tableData.get('TTC DG Category').add(String.valueOf(''));
                tableData.get('MBBL Type').add(String.valueOf(''));
                tableData.get('Number of Months in Financial Statements').add(String.valueOf(''));
                tableData.get('Items').add(String.valueOf('Annualised'));
                tableData.get('Income Statement').add(String.valueOf(''));
                tableData.get('Sales').add(String.valueOf(currentData.incomeRespStatementDTO.salesAnnualised));
                tableData.get('EBITDA').add(String.valueOf(currentData.incomeRespStatementDTO.ebitAAnnualised));
                tableData.get('Depreciation / Amortisation').add(String.valueOf(currentData.incomeRespStatementDTO.depreciationAmortisationAnnualised));
                tableData.get('Earnings before interest & tax (EBIT) (+ / -)').add(String.valueOf(currentData.incomeRespStatementDTO.ebitAnnualised));
                tableData.get('Rent Expense').add(String.valueOf(currentData.incomeRespStatementDTO.rentExpenseAnnualised));
                tableData.get('Net Profit (+) / Loss (-)').add(String.valueOf(currentData.incomeRespStatementDTO.netProfitBeforeTaxAnnualised));
                tableData.get('Cash Flow Statement').add(String.valueOf(''));
                tableData.get('Interest paid (+) / Interest received (-)').add(String.valueOf(currentData.cashFlowRespStatementDTO.grossIntrestPaidAnnualised));
                //Show value only on latest year
                if(i == 0){
                    tableData.get('Net increase(+) / decrease (-) in Working Capital').add(String.valueOf(currentData.cashFlowRespStatementDTO.netIncreaseDecreaseWorkingCapitalAnnualised));
                }
                else{
                    tableData.get('Net increase(+) / decrease (-) in Working Capital').add(String.valueOf(0));
                }
                tableData.get('Tax paid (+) / Tax received (-)').add(String.valueOf(currentData.cashFlowRespStatementDTO.taxPaidAnnualised));
                tableData.get('Dividend paid (+) /Dividend received (-)').add(String.valueOf(currentData.cashFlowRespStatementDTO.dividendPaidAnnualised));
                tableData.get('Free Cash Flow').add(String.valueOf(currentData.cashFlowRespStatementDTO.freeCashFlowAnnualised));
                tableData.get('Balance Sheet').add(String.valueOf(''));
                tableData.get('Intangible Assets').add(String.valueOf(''));
                tableData.get('Total Assets').add(String.valueOf(''));
                tableData.get('Assets').add(String.valueOf(''));
                tableData.get('Existing Interest Bearing Debt (IBD)').add(String.valueOf(''));
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
                tableData.get('Interest Bearing Debt: Equity').add(String.valueOf(''));
                tableData.get('IBD/EBITDA').add(String.valueOf(''));
                tableData.get('Operating Profit Margin').add(String.valueOf(''));
                tableData.get('LTV Non Specialised').add(String.valueOf(''));
                tableData.get('LTV Specialised').add(String.valueOf(''));
                tableData.get('Interest Cover Ratio (ICR) = (EBIT / Net Int Paid)').add(String.valueOf(''));
                tableData.get('Property Ratings').add(String.valueOf(''));

                //Only view first year's results for expected key ratios
                if(i == 0){
                    //Required Key Ratios
                    keyRatiosTableData.get('Expected Key Ratios (after adding new IBD)').add(String.valueOf('Required Ratios'));
                    keyRatiosTableData.get('Max IBD/EBITDA').add(String.valueOf((respParsedData.data.requiredRatioMbblDTO.maxIBD == null) ? '0.0' : String.valueOf(respParsedData.data.requiredRatioMbblDTO.maxIBD)));
                    keyRatiosTableData.get('DG Bucket of the Trading Entity').add(String.valueOf((respParsedData.data.requiredRatioMbblDTO.dgBucket == null) ? '0.0' : String.valueOf(respParsedData.data.requiredRatioMbblDTO.dgBucket)));
                    keyRatiosTableData.get('Max Term').add(String.valueOf((respParsedData.data.requiredRatioMbblDTO.maxTerm == null) ? '0.0' : String.valueOf(respParsedData.data.requiredRatioMbblDTO.maxTerm)));
                    keyRatiosTableData.get('Max LTV Non Specialised').add(String.valueOf((respParsedData.data.requiredRatioMbblDTO.maxLtvNonSP == null) ? '0.0' : String.valueOf(respParsedData.data.requiredRatioMbblDTO.maxLtvNonSP)));
                    keyRatiosTableData.get('Max LTV Specialised').add(String.valueOf((respParsedData.data.requiredRatioMbblDTO.maxLtvSpecial == null) ? '0.0' : String.valueOf(respParsedData.data.requiredRatioMbblDTO.maxLtvSpecial)));
                    keyRatiosTableData.get('Property Ratings').add(String.valueOf((respParsedData.data.requiredRatioMbblDTO.propertyRating == null) ? '0.0' : String.valueOf(respParsedData.data.requiredRatioMbblDTO.propertyRating)));
                    keyRatiosTableData.get('Debt Service Cover Ratio').add(String.valueOf((respParsedData.data.requiredRatioMbblDTO.debtServiceCoverRation == null) ? '0.0' : String.valueOf(respParsedData.data.requiredRatioMbblDTO.debtServiceCoverRation)));
                    //Expected key ratios outcomes
                    keyRatiosTableData.get('Expected Key Ratios (after adding new IBD)').add(String.valueOf('Outcome'));
                    keyRatiosTableData.get('Max IBD/EBITDA').add(String.valueOf((respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxIbdOutcome == '' || respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxIbdOutcome == null) ? '0.0' : respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxIbdOutcome));
                    keyRatiosTableData.get('DG Bucket of the Trading Entity').add(String.valueOf((respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.dgBucketOutcome == '' || respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.dgBucketOutcome == null) ? '0.0' : respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.dgBucketOutcome));
                    keyRatiosTableData.get('Max Term').add(String.valueOf((respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxTermOutcome == '' || respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxTermOutcome == null) ? '0.0' : respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxTermOutcome));
                    keyRatiosTableData.get('Max LTV Non Specialised').add(String.valueOf((respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxLtvNonSPOutcome == '' || respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxLtvNonSPOutcome == null) ? '0.0' : respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxLtvNonSPOutcome));
                    keyRatiosTableData.get('Max LTV Specialised').add(String.valueOf((respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxLtvSpecialOutcome == '' || respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxLtvSpecialOutcome == null) ? '0.0' : respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.maxLtvSpecialOutcome));
                    keyRatiosTableData.get('Property Ratings').add(String.valueOf((respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.propertyRatingOutcome == '' || respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.propertyRatingOutcome == null) ? '0.0' : respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.propertyRatingOutcome));
                    keyRatiosTableData.get('Debt Service Cover Ratio').add(String.valueOf((respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.debtServiceCoverRationOutcome == '' || respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.debtServiceCoverRationOutcome == null) ? '0.0' : respParsedData.data.expectedRatiosDTO.expectedOutcomeDTO.debtServiceCoverRationOutcome));
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
    * @author Tawanda M. | 07-20-2021 
    * @param opportunityId 
    * @param currentData 
    * @param loanData 
    * @return CalculateMBBLResult 
    **/
    @AuraEnabled
    public static CalculateMBBLResult mbblCalculate(String opportunityId, String currentData, String loanData){
            try{
                CalculateMBBLResult result;
                OverdraftFacilityDTO ovrFacility;
                List<LoanDetailsDTO> loansList = new List<LoanDetailsDTO>();
                List<String> errorMessageList = new List<String>();
                String INTEGRATION_SERVICE_NAME = 'DebtCapacityMBBL';
                List<MBBLDataStructure> parsedData = (List<MBBLDataStructure>) JSON.deserialize(currentData, List<MBBLDataStructure>.class);

                List<MBBLDataStructure> sortedMBBLData = sortMBBLReqData(parsedData);
                if(loanData != null){
                    List<LoanBucket> loans = (List<LoanBucket>) JSON.deserialize(loanData, List<LoanBucket>.class);
                    for(LoanBucket loan : loans){
                    if(loan.loanType == '5'){
                        ovrFacility = new OverdraftFacilityDTO(loan.loanAmount,loan.term,loan.intrestRate);
                        ovrFacility.overdraftIntrestRate = loan.intrestRate;
                        ovrFacility.overdraftBalance = loan.loanAmount;
                        ovrFacility.overdraftTerm = loan.term;
                    }
                    else{
                        loansList.add(new LoanDetailsDTO(loan.loanType,loan.loanAmount,loan.term,loan.intrestRate));
                    }
                }   
                }
                //if sections are missing, add to payload as null data
                if(ovrFacility == null){
                    new OverdraftFacilityDTO(0,0,0);
                }
                if(loansList.isEmpty() == true){
                    loansList.add(new LoanDetailsDTO('1',0,12,0));
                    loansList.add(new LoanDetailsDTO('1',0,12,0));
                }
                else if(loansList.size() == 1){
                    loansList.add(new LoanDetailsDTO('1',0,12,0));
                }

                //Always take the most recent year's property rating
                Integer propertyRating = (sortedMBBLData[0].propertyRatings != null) ? sortedMBBLData[0].propertyRatings : 1;

                String jsonPayload = '{"data":{"channelCalculatorDTO":{"debtCapacityMbblCalculatorDTO":{"propertyRatings": '+propertyRating+', "overdraftFacilityDTO":'+ JSON.serialize(ovrFacility) +',"loanDetailsDTO":'+ JSON.serialize(loansList) +',"mbblDTOs":' + JSON.serialize(sortedMBBLData) + '}}}}';
                //Opportunity opp = [Select Id, DC_MBBL_Calculator_Request__c from Opportunity where Id =: opportunityId];
                DebtCapacityMBBL_Req_IB_v1 requestBean = (DebtCapacityMBBL_Req_IB_v1) JSON.deserialize(jsonPayload, DebtCapacityMBBL_Req_IB_v1.class);
                DebtCapacityMBBL_Resp_IB_v1 responseBean = (DebtCapacityMBBL_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, DebtCapacityMBBL_Resp_IB_v1.class);
                if(responseBean.message == null && (responseBean.statusCode == 200 || responseBean.statusCode == 201)){
                    if(!responseBean.errors.isEmpty()){
                        for(DebtCapacityMBBL_Resp_IB_v1.Errors err: responseBean.errors){
                            errorMessageList.add(err.details);
                        }
                        return new CalculateMBBLResult(false, errorMessageList , null);
                    }
                    //TODO: Check client side error handling when this is not there
                    else if(responseBean.data.calculationBaseDTOLs == null){
                        errorMessageList.add('Data returned from webservice is empty');
                        return new CalculateMBBLResult(false, errorMessageList, null);
                    }
                    else{
                        saveResult(JSON.serialize(responseBean), opportunityId);
                        return new CalculateMBBLResult(true, errorMessageList, getRespData(responseBean, opportunityId, JSON.serialize(sortedMBBLData), loansList, ovrFacility));
                    }
                }
                else if(responseBean.message != null){
                    //This is if no loan data is in the request. API does not accept that but returns errors as object not list causing exception
                    //Check message from integration framework and act accordingly
                    if(responseBean.message.contains('The LoanDetailsDTO field is required')){
                        errorMessageList.add('Atleast one normal loan type (Not Overdraft) scenario is required for each financial year.');
                        return new CalculateMBBLResult(false, errorMessageList , null);
                    }
                    else if(responseBean.message.contains('The OverdraftFacilityDTO field is required')){
                        errorMessageList.add('Atleast one overdraft loan type scenario is required for each financial year.');
                        return new CalculateMBBLResult(false, errorMessageList , null);
                    }
                    else if(responseBean.message.contains('Internal Server Error')){
                        errorMessageList.add('Internal Server Error: MBBL calculation has failed due to a webservice error.');
                        return new CalculateMBBLResult(false, errorMessageList , null);
                    }
                    else{
                        return new CalculateMBBLResult(false, errorMessageList , null);
                    }
                }
                else{
                    return new CalculateMBBLResult(true, errorMessageList , null);
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
    public static List<MBBLDataStructure> sortMBBLReqData(List<MBBLDataStructure> inputArr){
        try{
                Integer len = inputArr.size();
                for (Integer i = 0; i < len; i++) {
                    for (Integer j = 0; j < len; j++) {
                        if((j + 1) != len){
                            if (inputArr[j].debtCapacityInitialDTO.year < inputArr[j + 1].debtCapacityInitialDTO.year) {
                                MBBLDataStructure tmp = inputArr[j];
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
    public static List<DebtCapacityMBBL_Resp_IB_v1.CalculationBaseDTOLs> sortMBBLRespData(List<DebtCapacityMBBL_Resp_IB_v1.CalculationBaseDTOLs> inputArr){
        try{
            Integer len = inputArr.size();
            for (Integer i = 0; i < len; i++) {
                for (Integer j = 0; j < len; j++) {
                    if((j + 1) != len){
                        if (inputArr[j].incomeRespStatementDTO.year < inputArr[j + 1].incomeRespStatementDTO.year) {
                            DebtCapacityMBBL_Resp_IB_v1.CalculationBaseDTOLs tmp = inputArr[j];
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
        Opportunity opp = [Select Id, DC_MBBL_Calculator_Response__c from Opportunity where Id =: opportunityId];
        opp.DC_MBBL_Calculator_Response__c = resultString;
        Update opp;
    }
}