/*
* Response Integration Bean for NHGetAccountDetailv3 Service
* @author Mashudu Raidmi
* @created 2020-08-11
*/
public class NHGetAccountDetailv3_Resp_IB_v1 extends Base_IB{
    
    
    @AuraEnabled public String status;
    @AuraEnabled public Integer statusCode;
    @AuraEnabled public String message;
    
    @AuraEnabled public NHgetAccountDetailV3Response NHgetAccountDetailV3Response;		
    public class NHgetAccountDetailV3Response{	
        @AuraEnabled public nhc039o nhc039o;
        @AuraEnabled public nbsapdpo nbsapdpo;
    }	
    public class nhc039o{	
        @AuraEnabled	public String mlAdvanceAmount;
        @AuraEnabled	public String mlArrearAmount;
        @AuraEnabled	public String cqDrInterestRate;
        @AuraEnabled	public String mlAvailableAmount;
        @AuraEnabled	public String cqCrInterestRate;
        @AuraEnabled	public String mlInterestRate;
        @AuraEnabled	public String cqUnclearedCheques;
        @AuraEnabled	public String mlOutstandingBalance;
        @AuraEnabled	public String cqReturnedCheques;
        @AuraEnabled	public String mlPaymentDate;
        @AuraEnabled	public String cqPostDatedTrans;
        @AuraEnabled	public String mlPaymentDue;
        @AuraEnabled	public String cqOverdraftLimit;
        @AuraEnabled	public String mlUnclearedEffects;
        @AuraEnabled	public String cqMarkedChequeAmnt;
        @AuraEnabled	public String mlRemainingTerm;
        @AuraEnabled	public String cqExpiryDate;
        @AuraEnabled	public String svAccountBalance;
        @AuraEnabled	public String cqDrInterestDue;
        @AuraEnabled	public String svAuthHoldAmount;
        @AuraEnabled	public String cqDateOpened;
        @AuraEnabled	public String svAvailableAmount;
        @AuraEnabled	public String cqCrInterestDue;
        @AuraEnabled	public String svBonusInterest;
        @AuraEnabled	public String cqAvailableAmount;
        @AuraEnabled	public String svCrInterestDue;
        @AuraEnabled	public String cqAuthHoldAmount;
        @AuraEnabled	public String svCrdInterestRate;
        @AuraEnabled	public String cqAuthAmount;
        @AuraEnabled	public String svDateOpened;
        @AuraEnabled	public String cqAccountBalance;
        @AuraEnabled	public String svPostDatedTrans;
        @AuraEnabled	public String camsPaymentDueDate;
        @AuraEnabled	public String svReturnedCheques;
        @AuraEnabled	public String camsMinAmntPayable;
        @AuraEnabled	public String svUnclearedCheques;
        @AuraEnabled	public String camsFullAmntPayable;
        @AuraEnabled	public String svPndngNoticeTot;
        @AuraEnabled	public String camsExpiryDate;
        @AuraEnabled	public String svCessionAmount;
        @AuraEnabled	public String camsDebitIntRate;
        @AuraEnabled	public String pblOutstandingBal;
        @AuraEnabled	public String camsCreditLimit;
        @AuraEnabled	public String pblAvailableAmount;
        @AuraEnabled	public String camsCreditIntRate;
        @AuraEnabled	public String pblUnclearedEffects;
        @AuraEnabled	public String camsTotalAccountBal;
        @AuraEnabled	public String pblArrearAmount;
        @AuraEnabled	public String camsBudgetBalance;
        @AuraEnabled	public String pblAdvanceAmount;
        @AuraEnabled	public String camsAvailableAmount;
        @AuraEnabled	public String pblPaymentDue;
        @AuraEnabled	public String camsAuthorisedAmount;
        @AuraEnabled	public String pblPaymentDate;
        @AuraEnabled	public String camsArrearAmount;
        @AuraEnabled	public String pblInterestRate;
        @AuraEnabled	public String camsStraightBalance;
        @AuraEnabled	public String pblTermOfLoan;
        @AuraEnabled	public String tdSubaccountBalance;
        @AuraEnabled	public String advAmount;
        @AuraEnabled	public String tdPostDatedTrans;
        @AuraEnabled	public String balOutstanding;
        @AuraEnabled	public String tdNextCapDate;
        @AuraEnabled	public String contractDate;
        @AuraEnabled	public String tdMaturityDate;
        @AuraEnabled	public String instalment;
        @AuraEnabled	public String tdInterestRate;
        @AuraEnabled	public String interestRate;
        @AuraEnabled	public String tdDateOpened;
        @AuraEnabled	public String repaymentDay;
        @AuraEnabled	public String tdCapFrequency;
        @AuraEnabled	public String unclearedCheques;
        @AuraEnabled	public String tdBonusRate;
        @AuraEnabled	public String vfOutstandingBal;
        @AuraEnabled	public String tdAvailableAmount;
        @AuraEnabled	public String vfArticleDescrip;
        @AuraEnabled	public String tdAmountCeded;
        @AuraEnabled	public String vfOriginalAmount;
        @AuraEnabled	public String tdAccruedInterest;
        @AuraEnabled	public String vfOriginalTerm;
        @AuraEnabled	public String tdAccruedBonus;
        @AuraEnabled	public String vfRemainingTerm;
        @AuraEnabled	public String tdAccountStatus;
        @AuraEnabled	public String vfPaymFrequency;
        @AuraEnabled	public String tdAccountBalance;
        @AuraEnabled	public String vfPaymMethod;
        @AuraEnabled	public String productCode;
        @AuraEnabled	public String vfIslamIndicator;
        @AuraEnabled	public String productType;
        @AuraEnabled	public String vfInstalmentAmount;
        @AuraEnabled	public String productName;
        @AuraEnabled	public String vfNextInstalDate;
        @AuraEnabled	public String rdesc;
        @AuraEnabled	public String vfResidualValue;
        @AuraEnabled	public String rcdeReason;
        @AuraEnabled	public String vfEstiSettleValue;
        @AuraEnabled	public String rcdeSource;
        @AuraEnabled	public String vfContractStartDate;
        @AuraEnabled	public String rcdeType;
        @AuraEnabled	public String vfContractEndDate;
        @AuraEnabled	public String rcde;
        @AuraEnabled	public String vfIntRate;
        @AuraEnabled	public String stpAmt;
        @AuraEnabled	public String stpExp;
        @AuraEnabled	public String vfIntRateDesc;
    }	
    public class nbsapdpo{	
        @AuraEnabled	public String echoKey;
        @AuraEnabled	public String reasonCode;
        @AuraEnabled	public String serviceVersion;
        @AuraEnabled	public String returnCode;
        @AuraEnabled	public String version;
    }	
    
    public  NHGetAccountDetailv3_Resp_IB_v1 (){}
    
}