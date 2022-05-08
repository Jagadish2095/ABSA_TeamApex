/**
 * @description       : Test Class for Debt Capacity MBBL calculator
 * @author            : Tawanda M.
 * @group             : 
 * @last modified on  : 09-28-2021
 * @last modified by  : Tawanda M.
 * Modifications Log 
 * Ver   Date         Author       Modification
 * 1.0   19-07-2021   Tawanda M.   Initial Version
**/
@isTest
public class DebtCapacity_MBBL_ControllerTest {
    @isTest
    public static void testInitialiseMBBLInputData(){
        Test.startTest();
        DebtCapacity_MBBL_Controller.MBBLDataStructure data = DebtCapacity_MBBL_Controller.getEmptyMBBLData();
        System.assert(data != null);
        Test.stopTest();
    }

    @isTest
    public static void testInitialiseMBBLLoanInputData(){
        Test.startTest();
        DebtCapacity_MBBL_Controller.LoanBucket data = DebtCapacity_MBBL_Controller.getEmptyLoanData();
        System.assert(data != null);
        Test.stopTest();
    }

    @isTest
    public static void testFetchMBBLDataFromObject(){
        Account acc = new Account();
        acc.Name = 'Test Account For Complex Credit';
        Insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Complex Credit Opportunity';
        opp.AccountId = acc.Id;
        opp.StageName = 'Confirm Client Eligibility';
        opp.CloseDate = Date.today().addMonths(2);
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Complex Credit Onboarding').getRecordTypeId();
        Insert opp;

        Test.startTest();
        //Get Empty Data, save to new opportunity and fetch table data
        DebtCapacity_MBBL_Controller.MBBLDataStructure data = DebtCapacity_MBBL_Controller.getEmptyMBBLData();
        String jsonData = JSON.serialize(data);
        DebtCapacity_MBBL_Controller.saveNewData(jsonData, opp.Id);
        System.assert(data != null);
        Test.stopTest();
    }

    @isTest
    public static void testSaveAndEditAndFetchMBBLDataToObject(){
        Account acc = new Account();
        acc.Name = 'Test Account For Complex Credit';
        Insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Complex Credit Opportunity';
        opp.AccountId = acc.Id;
        opp.StageName = 'Confirm Client Eligibility';
        opp.CloseDate = Date.today().addMonths(2);
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Complex Credit Onboarding').getRecordTypeId();
        Insert opp;

        Test.startTest();
        //Get Empty Data, save to new opportunity and fetch table data
        DebtCapacity_MBBL_Controller.MBBLDataStructure data = DebtCapacity_MBBL_Controller.getEmptyMBBLData();
        data.debtCapacityInitialDTO.year = 2021;
        DebtCapacity_MBBL_Controller.saveNewData(JSON.serialize(data), opp.Id);
        //Add another item to the object
        data.debtCapacityInitialDTO.year = 2022;
        DebtCapacity_MBBL_Controller.saveNewData(JSON.serialize(data), opp.Id);
        //Add another item to the object
        data.debtCapacityInitialDTO.year = 2023;
        DebtCapacity_MBBL_Controller.saveNewData(JSON.serialize(data), opp.Id);

        //Fetch data that is in the record right now
        DebtCapacity_MBBL_Controller.getTableData(opp.Id);

        //Convert to list and save as data is stored in list form in object even when is only single item
        List<DebtCapacity_MBBL_Controller.MBBLDataStructure> dataList = new List<DebtCapacity_MBBL_Controller.MBBLDataStructure>{data};
        String jsonListData = JSON.serialize(dataList);
        DebtCapacity_MBBL_Controller.editExistData(jsonListData, opp.Id);

        System.assert(data != null);
        Test.stopTest();
    }

    @isTest(SeeAllData=true)
    public static void testCalculateMBBLResults(){
        Account acc = new Account();
        acc.Name = 'Test Account For Complex Credit';
        Insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Complex Credit Opportunity';
        opp.AccountId = acc.Id;
        opp.StageName = 'Confirm Client Eligibility';
        opp.CloseDate = Date.today().addMonths(2);
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Complex Credit Onboarding').getRecordTypeId();
        Insert opp;

        Test.startTest();
        //Get Empty Data, save to new opportunity and fetch table data
        DebtCapacity_MBBL_Controller.MBBLDataStructure data = DebtCapacity_MBBL_Controller.getEmptyMBBLData();
        data.debtCapacityInitialDTO.year = 2021;
        data.debtCapacityInitialDTO.useInCalculation = true;
        DebtCapacity_MBBL_Controller.saveNewData(JSON.serialize(data), opp.Id);
        //Add another item to the object
        data.debtCapacityInitialDTO.year = 2022;
        data.debtCapacityInitialDTO.useInCalculation = true;
        DebtCapacity_MBBL_Controller.saveNewData(JSON.serialize(data), opp.Id);

        //Fetch data that is in the record right now
        DebtCapacity_MBBL_Controller.ReturnedMBBLData wrapperData = DebtCapacity_MBBL_Controller.getTableData(opp.Id);

        List<DebtCapacity_MBBL_Controller.LoanBucket> loandata = new List<DebtCapacity_MBBL_Controller.LoanBucket>{DebtCapacity_MBBL_Controller.getEmptyLoanData()};
        
        //Calculate
        DebtCapacity_MBBL_Controller.CalculateMBBLResult result = DebtCapacity_MBBL_Controller.mbblCalculate(opp.Id, JSON.serialize(wrapperData.mbblData), JSON.serialize(loandata));
        System.assert(result != null);
        Test.stopTest();
    }

    @isTest
    public static void testResultsTableData(){
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account For Complex Credit';
        Insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Complex Credit Opportunity';
        opp.AccountId = acc.Id;
        opp.StageName = 'Confirm Client Eligibility';
        opp.CloseDate = Date.today().addMonths(2);
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Complex Credit Onboarding').getRecordTypeId();
        Insert opp;

        //Get Empty Data, save to new opportunity and fetch table data
        DebtCapacity_MBBL_Controller.MBBLDataStructure data = DebtCapacity_MBBL_Controller.getEmptyMBBLData();
        data.debtCapacityInitialDTO.year = 2012;
        data.debtCapacityInitialDTO.useInCalculation = true;
        DebtCapacity_MBBL_Controller.saveNewData(JSON.serialize(data), opp.Id);
        //Add another item to the object
        data.debtCapacityInitialDTO.year = 2013;
        data.debtCapacityInitialDTO.useInCalculation = true;
        DebtCapacity_MBBL_Controller.saveNewData(JSON.serialize(data), opp.Id);

        DebtCapacity_MBBL_Controller.ReturnedMBBLData wrapperData = DebtCapacity_MBBL_Controller.getTableData(opp.Id);

        String dummyResponse = '{"data":{"calculationBaseDTOLs":[{"incomeRespStatementDTO":{"year":"2021","salesAnnualised":17454545.454545453,"ebit":-11260000.0,"ebitAnnualised":-12283636.363636363,"ebitA":-10704000.0,"ebitAAnnualised":-11677090.909090908,"depreciationAmortisationAnnualised":545454.5454545454,"netProfitBeforeTaxAnnualised":-13090909.090909092,"rentExpenseAnnualised":61090.90909090909},"cashFlowRespStatementDTO":{"grossIntrestPaidAnnualised":436363.63636363635,"netIncreaseDecreaseWorkingCapitalAnnualised":0.0,"taxPaidAnnualised":196363.63636363635,"dividendPaidAnnualised":0.0,"freeCashFlow":-10884000.0,"freeCashFlowAnnualised":-11873454.545454545},"balanceSheetRespStatementDTO":{"interestBearingDebt":33020000.0,"totalAssets":12000000.0,"totalEquity":2028000.0},"minimumAnnualPaymentsRespDTO":{"minimumAnnualPayments":436363.63636363635,"interestPaid":400000.0},"presentRatiosDTO":{"ibdEquityRatio":8.22211155378486,"ibdEbitaRatio":-2.8277590931738916,"icrRatio":-25.804166666666667,"opmRatio":-70.375,"speciaRatio":0.006,"nonSpeciaRatio":0.0,"propertyRating":1.0}}],"interestBearingDebtRespDTO":[{"loanType":"TERMLOAN","capitalPortionPayableNextTweleve":12000.0,"interestPayableNextTweleve":794.2255696812008,"installPayableNextTweleve":12794.2255696812,"monthlyInstall":1066.1854641401},{"loanType":"MBBL","capitalPortionPayableNextTweleve":10000.0,"interestPayableNextTweleve":830.9974814188645,"installPayableNextTweleve":10830.997481418864,"monthlyInstall":902.583123451572}],"totalNewDTO":{"capitalPortionGrandTotal":22000.0,"intrestPaybleGrandTotal":31625.223051100067,"loansOverDraftGrandTotal":222000.0,"installmentPaybleGrandTotal":53625.22305110007},"expectedRatiosDTO":{"propertyRating":"1","maxIBD":-2.8467706776283013,"maxTerm":12.0,"maxLtvNonSP":0.0,"maxLtvSpecial":0.006,"rating":"Below Average","debtServiceCoverRation":-22.21274992456015,"expectedOutcomeDTO":{"propertyRatingOutcome":"Decline","maxIbdOutcome":"","dgBucketOutcome":"DG 1- 4","maxTermOutcome":"","maxLtvNonSPOutcome":"","maxLtvSpecialOutcome":"N/A","debtServiceCoverRationOutcome":"Too Low"}},"requiredRatioMbblDTO":{"propertyRating":">1","maxIBD":2.5,"maxTerm":"120","maxLtvNonSP":100.0,"maxLtvSpecial":100.0,"debtServiceCoverRation":0.0,"dgBucket":1},"overDraft":30000.0},"errors":[]}';
        DebtCapacity_MBBL_Controller.CalculateResponseWrappper tableData = DebtCapacity_MBBL_Controller.getRespData((DebtCapacityMBBL_Resp_IB_v1) JSON.deserialize(dummyResponse, DebtCapacityMBBL_Resp_IB_v1.class), opp.Id, JSON.serialize(wrapperData.mbblData), new List<DebtCapacity_MBBL_Controller.LoanDetailsDTO>{new DebtCapacity_MBBL_Controller.LoanDetailsDTO('1', 0 ,0 ,0)}, new DebtCapacity_MBBL_Controller.OverdraftFacilityDTO(0, 0, 0));
        System.assert(tableData != null);
        Test.stopTest();
    }

    @isTest
    public static void testSaveLoan(){
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'Test Account For Complex Credit';
        Insert acc;

        Opportunity opp = new Opportunity();
        opp.Name = 'Test Complex Credit Opportunity';
        opp.AccountId = acc.Id;
        opp.StageName = 'Confirm Client Eligibility';
        opp.CloseDate = Date.today().addMonths(2);
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Complex Credit Onboarding').getRecordTypeId();
        Insert opp;

        DebtCapacity_MBBL_Controller.LoanBucket loanData = DebtCapacity_MBBL_Controller.getEmptyLoanData();
        DebtCapacity_MBBL_Controller.saveLoan(JSON.serialize(loanData), opp.Id);
        System.assert(loanData != null);
        Test.stopTest();
        
    }
}