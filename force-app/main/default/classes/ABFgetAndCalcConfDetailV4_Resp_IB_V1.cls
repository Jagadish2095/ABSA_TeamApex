/*
* Integration Response Bean for ABFgetAndCalcConfDetailV4 Service 
* @author Himanshu Nimje
* @created 2020-11-28
*/
public class ABFgetAndCalcConfDetailV4_Resp_IB_V1 extends Base_IB{
    
    public NBSAPDPO  NBSAPDPO;
    public PLPA01O PLPA01O;
    public MSGO MSGO;
    
    public class NBSAPDPO{
        public outputErrorHeaders  outputErrorHeaders;
    }
    public class outputErrorHeaders{
        public String  returnCode;
        public String outputServiceVersion;  
        public String reasonCode;  
    }
    
    
    public class PLPA01O{
        public outputHreasonCodeeaders  outputHreasonCodeeaders;   
    }
    public class outputHreasonCodeeaders{
        public String  totalDebtAmount;
        public String assuranceCompany; 
        public String rateFixedLinkedInd; 
        public String ceilingRate; 
        public String clSchemeCode; 
        public String paymentType; 
        public String totalLoanAmount; 
        public String initFeePayMethod; 
        public String firstRepaymentAmt; 
        public String repaymentFrequency; 
        public String monthlyServiceFee; 
        public String skipMonthIndicator; 
        public String usuaryActIndicator; 
        public String debitValType; 
        public String siteCode; 
        public String residualAmount; 
        public String firstCollectionDate; 
        public String originalLoanAmount; 
        public String initiationFeeAmount;
        public String baseRate;
        public String interestRateAdj;
        public String maxCollectionAmount;
        public String principleDebtAmount;
        public String regularRepaymentAmt;
        public String effectiveRate;
        public String contractTerm;
        public String initialAmount;
        public String financeType;
        public String interestRateTypeID;
        public String lastRepaymentAmt;
        public String totalSettlementAmount;
        public String regInstallAmount;
        public String financeCharges;
        
    }
    
    
    public class MSGO{
        public NBSMSGO3  NBSMSGO3;   
    }
    public class NBSMSGO3{
        public String  NBNMSGO3_NBR_USER_ERRS;
        public String NBSMSGO3_VERSION; 
        public String NBNMSGO3_SYS_ERR_TXT;  
        public String NBNMSGO3_NBR_USER_MSGS;  
        public NBNMSGO3_MSG_ENTRY[] NBNMSGO3_MSG_ENTRY;  
        
        
    }
    public class NBNMSGO3_MSG_ENTRY{
        public String  NBNMSGO3_MSG_ERR_IND;
        public String NBNMSGO3_MSG_TXT; 
        public String NBNMSGO3_MSG_CLASS;  
        public String NBNMSGO3_MSG_CODE;  
        
    }
}