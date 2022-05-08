/*
* Integration Request Bean for ABFgetQuoteInfoForEspV5 Service to Calculate the Quotes for Term Loan
* @author Himanshu Nimje
* @created 2020-12-02
*/


public class ABFgetQuoteInfoForEspV5_Req_IB_V1 extends Base_IB {

        public NBSAPDPI NBSAPDPI;
        public NBSMSGI NBSMSGI;
        public PLSA71I PLSA71I;
    
    public class NBSAPDPI{
        public inputHeader inputHeader;
    }
    public class inputHeader{
        public String channelName;
        public String applicationName;
        public String traceIndicator;
    }
    
    public class NBSMSGI {
        public inputErrorMessage inputErrorMessage;
    }
    public class inputErrorMessage{
        public String inputMessageLanguage;
        public String inputMessageTarget;
        
    }
    
    
    public class PLSA71I{
        public inputCopybookLayout inputCopybookLayout;
    }
    
    public class inputCopybookLayout{
        public String inputClientCode; // CIF Number 
        public String inputAccountNbr;  // Term Loan Account Number From HlAlocateStck + LinkAccountToClient
        public String inputFinanceType; // Default :'01'
        public String inputLoanAmount;
        public String inputContractDate;
        public String inputFirstRepaymentDate;
        public String inputRepaymentFrequency;
        public String inputContractTerm;
        public String inputMortgageIndicator;
        public String inputRatePrimeIndicator;
        public String inputRateFixedIndicator;
        public String inputInterestRate;  // Prime Rate + Margin (Above ) Or Prime Rate -  Margin (Below )
        public String inputInitiationFee;
        public String inputServiceFee;
        public String inputSkipMonths;
        public String inputCreditLifeIndicator;
        public String inputDebitOrderIndicator;
        public String inputQuoteNumber;
        public String inputComplexStructureIndicator;
        public String inputInitiationFeeMethod;
        public String inputApplicationNbr;
        public String inputPurposeOfLoanCode;
        public String inputEmpowermentCode;
        public String inputMaxRateType;
        public String inputTotalSettlementAmount;
        public inputLoanToSettleInfo  inputLoanToSettleInfo;
        public String inputTermLoanType;
        public String inputChannelQuoteCreated;
        public String inputSchemeType;
        public String inputSchemeCode;
        public String inputCreditlifeSchemeCode;
        public String inputCreditlifePremium;
        public String inputNLRReferenceNbr;
        public String inputNCAIndicator;
        public String inputVisibleCreditIndicator;
        public string inputMargin;
        public string inputRateAbovebelow;
    }
    
    public class inputLoanToSettleInfo{
        public String inputLoanAccountToSettle;
        public String inputLoanSettlementAmount;
    }
    
    
      public static ABFgetQuoteInfoForEspV5_Req_IB_V1 createDummyRequest() {
        
        ABFgetQuoteInfoForEspV5_Req_IB_V1 requestBean = new ABFgetQuoteInfoForEspV5_Req_IB_V1();

        ABFgetQuoteInfoForEspV5_Req_IB_V1.NBSAPDPI NBSAPDPI = new ABFgetQuoteInfoForEspV5_Req_IB_V1.NBSAPDPI();
        ABFgetQuoteInfoForEspV5_Req_IB_V1.inputHeader inputHeader = new ABFgetQuoteInfoForEspV5_Req_IB_V1.inputHeader();
        inputHeader.channelName = 'DP';
        inputHeader.applicationName='DP';
        inputHeader.traceIndicator = 'Y';
        
        ABFgetQuoteInfoForEspV5_Req_IB_V1.NBSMSGI NBSMSGI = new ABFgetQuoteInfoForEspV5_Req_IB_V1.NBSMSGI();
        ABFgetQuoteInfoForEspV5_Req_IB_V1.inputErrorMessage inputErrorMessage = new ABFgetQuoteInfoForEspV5_Req_IB_V1.inputErrorMessage();
        inputErrorMessage.inputMessageLanguage = 'E';
        inputErrorMessage.inputMessageTarget = 'STD';
       
        
        ABFgetQuoteInfoForEspV5_Req_IB_V1.inputLoanToSettleInfo inputLoanToSettleInfo = new ABFgetQuoteInfoForEspV5_Req_IB_V1.inputLoanToSettleInfo();
        inputLoanToSettleInfo.inputLoanAccountToSettle ='0';
        inputLoanToSettleInfo.inputLoanSettlementAmount ='0';   
        
        ABFgetQuoteInfoForEspV5_Req_IB_V1.PLSA71I PLSA71I = new ABFgetQuoteInfoForEspV5_Req_IB_V1.PLSA71I();
        ABFgetQuoteInfoForEspV5_Req_IB_V1.inputCopybookLayout inputCopybookLayout = new ABFgetQuoteInfoForEspV5_Req_IB_V1.inputCopybookLayout();
        inputCopybookLayout.inputClientCode = 'WCC    451';
        inputCopybookLayout.inputAccountNbr ='3001537580';
        inputCopybookLayout.inputFinanceType ='01';
        inputCopybookLayout.inputLoanAmount = '855000.00';
        inputCopybookLayout.inputContractDate ='20201021';
        inputCopybookLayout.inputFirstRepaymentDate ='20201130';
        inputCopybookLayout.inputRepaymentFrequency ='1';
        inputCopybookLayout.inputContractTerm ='66';
        inputCopybookLayout.inputMortgageIndicator ='N';
        inputCopybookLayout.inputRatePrimeIndicator ='Y';
        inputCopybookLayout.inputRateFixedIndicator ='N';
        inputCopybookLayout.inputInterestRate ='7.25000';
        inputCopybookLayout.inputInitiationFee ='42350';
        inputCopybookLayout.inputServiceFee ='0';
        inputCopybookLayout.inputSkipMonths ='9';
        inputCopybookLayout.inputCreditLifeIndicator ='N';
        inputCopybookLayout.inputDebitOrderIndicator ='Y';
        inputCopybookLayout.inputQuoteNumber ='848160';
        inputCopybookLayout.inputComplexStructureIndicator ='N';
        inputCopybookLayout.inputInitiationFeeMethod ='P';
        inputCopybookLayout.inputApplicationNbr ='00';
        inputCopybookLayout.inputPurposeOfLoanCode ='2';
        inputCopybookLayout.inputEmpowermentCode='';
        inputCopybookLayout.inputMaxRateType ='60';
        inputCopybookLayout.inputTotalSettlementAmount ='0';
        inputCopybookLayout.inputLoanToSettleInfo=inputLoanToSettleInfo;
        inputCopybookLayout.inputTermLoanType ='TLON';
        inputCopybookLayout.inputChannelQuoteCreated ='E';
        inputCopybookLayout.inputSchemeType='';
        inputCopybookLayout.inputSchemeCode ='0';
        inputCopybookLayout.inputCreditlifeSchemeCode ='0';
        inputCopybookLayout.inputCreditlifePremium ='0';
        inputCopybookLayout.inputNLRReferenceNbr ='0';
        inputCopybookLayout.inputNCAIndicator ='0';
        inputCopybookLayout.inputVisibleCreditIndicator ='N';
        
        NBSAPDPI.inputHeader=inputHeader;
        NBSMSGI.inputErrorMessage=inputErrorMessage;
        PLSA71I.inputCopybookLayout=inputCopybookLayout;
        
        requestBean.NBSAPDPI = NBSAPDPI;
        requestBean.NBSMSGI = NBSMSGI;
        requestBean.PLSA71I = PLSA71I;
        
        return requestBean;
        
    }
  

}