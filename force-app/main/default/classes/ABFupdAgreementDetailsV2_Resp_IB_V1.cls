public class ABFupdAgreementDetailsV2_Resp_IB_V1 extends Base_IB{

   // public ABFupdAgreementDetailsV2Response ABFupdAgreementDetailsV2Response;
    
  //  public class ABFupdAgreementDetailsV2Response{
       public nbsapdpo nbsapdpo;
       public nbsmsgo nbsmsgo;
       public outputArea outputArea;
  //  }
    public class nbsapdpo{
      public string version;
      public string returnCode;
      public string reasonCode;
      public string serviceVersion;
      public string echoKey;
    }
    
    public class nbsmsgo{
      public String version;
      public string sysErrTxt;
      public String nbrUserMsgs;
      public String nbrUserErrs;
    }
   
    public class outputArea{
      public String creditLifePremium;
      public String monthlyServiceFee;
      public String repaymentCounter;
      public repaymentDetail[] repaymentDetail;
      public String applicationNbr;
      public String clientNameLine1;
      public String clientNameLine2;
      public String clientAddress;
      public String originalLoanAmount;
      public String contractTerm;
      public String repaymentFrequency;
      public String firstRepaymentAmt;
      public String lastRepaymentAmt;
      public String firstInstalmentDate;
      public String accountStatus;
      public String mandateNumber;
    }
    public class repaymentDetail{
        public String supplementaryAmount;
        public String supplementaryAmtInd;
        public String instalmentDate;
        public String instalmentAmount;
        public String capitalBalance;
        public String capitalAmount;
        public String interestAmount;
        public String instalmentPaidInd;
        public string activityInd;
        public String fixedLinkedInd;
        public String rate;
        public String rateDate;
        public String rateEscalation;
        public String rateId;
        public String rateIdRate;
        public String rateIdDate;
        public String capitalisationAmount;
        public String capitalisationDate;
        public String capitalisationBalance;
        public String repaymentNumber;
    }
    
    
}