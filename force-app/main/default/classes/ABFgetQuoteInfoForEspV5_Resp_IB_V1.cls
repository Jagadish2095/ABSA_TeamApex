/*
* Integration Response Bean for ABFgetQuoteInfoForEspV5 Service to get Calculated the Quotes for Term Loan
* @author Himanshu Nimje
* @created 2020-12-02
*/

public class ABFgetQuoteInfoForEspV5_Resp_IB_V1 extends Base_IB {
    
        @AuraEnabled public NBSAPDPO NBSAPDPO;
        @AuraEnabled public NBSMSGO3 NBSMSGO3;
        @AuraEnabled public PLSA71O PLSA71O;
        
    
    public class NBSAPDPO {
        public outputHeaders outputHeaders;
    }
     public class outputHeaders{
        @AuraEnabled  public String serviceVersion;
        @AuraEnabled  public String returnCode;
        @AuraEnabled  public String echoKey;
        @AuraEnabled  public String reasonCode;
        @AuraEnabled  public String version;
    }
    
    public class NBSMSGO3{
        public outputErrorMessage outputErrorMessage;
    }
    public class outputErrorMessage{
        @AuraEnabled  public String outputErrorMessage;
        @AuraEnabled  public outputErrorMessageTable[] outputErrorMessageTable;
        @AuraEnabled  public String systemErrorTxt;
        @AuraEnabled  public String numberUserErrors;
        @AuraEnabled  public String numberUserMessages;
    }
    public class outputErrorMessageTable{
        @AuraEnabled public String  errorMessageCode;
        @AuraEnabled public String errorMessageIndicator; 
        @AuraEnabled public String errorMessageText;  
        @AuraEnabled public String errorMessageClass;     
    }
      
    public class PLSA71O{
        public outputCopybookLayout outputCopybookLayout;
    }
    public class outputCopybookLayout{
        @AuraEnabled  public String outputCreditlifeBenefitDetails;
        @AuraEnabled  public String outputDateLastInstalment;
        @AuraEnabled  public String outputRegularCapitalAndInterestInstalmentAmount;
        @AuraEnabled  public String  outputDateLastCapitalAndInterestInstalment;
        @AuraEnabled  public String outputTermLoanType;
        @AuraEnabled  public String outputCreditlifeNetPremium;
        @AuraEnabled  public String  outputNumberOfCapitalAndInterestInstalments;
        @AuraEnabled  public String outputSuretyInfo;
        @AuraEnabled  public String outputInterestAndFeesCreditlife;
        @AuraEnabled  public String  outputCreditlifePolicyFee;
        @AuraEnabled  public String outputOtherConditions;
        @AuraEnabled  public String outputHighestInterestOnlyInstamentAmount;
        @AuraEnabled  public String  outputSchemeType;
        @AuraEnabled  public String outputTotalInstalmentAmount;
        @AuraEnabled  public String  outputSettlementIndicator;
        @AuraEnabled  public String outputTotalCostOfCredit;
        @AuraEnabled  public String outputProductCode;
        @AuraEnabled  public String  outputPaymentMethodDescription;
        @AuraEnabled  public String outputNCAIndicator;
        @AuraEnabled  public String outputCreditLife;
        @AuraEnabled  public String  outputEmpowermentCode;
        @AuraEnabled  public String outputDateFirstInterestOnlyInstalment;
        @AuraEnabled  public String outputCreditlifePremium;
        @AuraEnabled  public String  outputMaxRateType;
        @AuraEnabled  public String outputTotalAmountRepay;
        @AuraEnabled  public String outpuComplexStructureIndicator;
        @AuraEnabled  public String outputSMSInfoRequiredIndicator;
        @AuraEnabled  public String outputVersionNumber;
        @AuraEnabled  public String outputTotalCreditLife;
        @AuraEnabled  public String outputRateFactorSign;
        @AuraEnabled  public String outputApplicationNbr;
        @AuraEnabled  public String outputCreditlifeSchemeCode;
        @AuraEnabled  public String outputCreditlifeCommission;
        @AuraEnabled  public String outputVisibleCreditLimitIndicator;
        @AuraEnabled  public String outputInitiationFee;
        @AuraEnabled  public String outputSecurityRequestIndicator;
        @AuraEnabled  public String outputTotalAllInstalmentAmount;
        @AuraEnabled  public String outputSkipPaymentsAmount;
        @AuraEnabled  public String outputAgreementType;
        @AuraEnabled  public String outputSettlementAmount;
        @AuraEnabled  public String outputBrokenPeriodIndicator;
        @AuraEnabled  public String outputNLRReferenceNbr;
        @AuraEnabled  public String outputLoanAmount;
        @AuraEnabled  public String outputNumberOfInstalments;
        @AuraEnabled  public String outputEffectiveInterestRate;
        @AuraEnabled  public String outputNumberOfInterestOnlyInstalments;
        @AuraEnabled  public String outputFinalInstalmentAmount;
        @AuraEnabled  public String outputCreditlifeBusnessIndicator;
        @AuraEnabled  public String outputRateFactorValue;
        @AuraEnabled  public String outputTotalServiceFee;
        @AuraEnabled  public String outputServiceFee;
        @AuraEnabled  public String outputRegularInstalmentAmount;
        @AuraEnabled  public String outputBrokenPeriodInstalmentAmount;
        @AuraEnabled  public String outputQuoteNbr;
        @AuraEnabled  public String outputSchemeCode;
        @AuraEnabled  public String outputContractDate;
        @AuraEnabled  public String outputTotalInterestOnlyInstalmentAmount;
        @AuraEnabled  public String outputChannelQuoteCreated;
        @AuraEnabled  public String outputRateType;
        @AuraEnabled  public String outputTotalSettlementAmount;
        @AuraEnabled  public String outputTotalInterestAndCapitalInstalmentAmount;
        @AuraEnabled  public String outputPurposeOfLoanCode;
        @AuraEnabled  public String outputNumberOfSkipPayments;
        @AuraEnabled  public String outputSkipMonths;
        @AuraEnabled  public String outputInitiationFeePaymentMethod;
        @AuraEnabled  public String outputDateLastInterestOnlyInstalment;
        @AuraEnabled  public String outputTotalFinanceCharges;
        @AuraEnabled  public String outputInstalmentIncludingCreditlife;
        @AuraEnabled  public String outputAccountType;
        @AuraEnabled  public String outputInstalmentFrequencyDescription;
        @AuraEnabled  public String outputDateFirstInstalment;
        @AuraEnabled  public String outputCostOfCreditMultiple;
        @AuraEnabled  public String outputDateFirstCapitalAndInterestInstalment;
        @AuraEnabled  public String outputPaymentMethod;
        @AuraEnabled  public String outputTotalAmountDeferred;
        @AuraEnabled  public String outputInstalmentFrequency;
        @AuraEnabled  public String outputCreditlifeRequestIndicator;
        @AuraEnabled  public String outpuCreditlifeSchemeNbr;
        @AuraEnabled  public String outputNumberOfRegularInstalments;
        

    }
}