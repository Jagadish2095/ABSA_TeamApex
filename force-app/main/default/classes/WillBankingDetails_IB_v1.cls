public class WillBankingDetails_IB_v1 extends Base_IB {
    
    public BankingDetailsRequest_cls BankingDetailsRequest;
    public BankingDetailsResponse_cls BankingDetailsResponse;
    
    public class BankingDetailsRequest_cls extends BankingDetails_cls{
        
    }
    
    public class BankingDetailsResponse_cls extends BankingDetails_cls{
        
        public String status;
        public Integer statusCode;
        public String message;
        public String RC;
        public String RCMessage;
    }
    
    public abstract class BankingDetails_cls{
        
        public String WillNo;
        public String BranchCode;
        public String BankName;
        public String SiteCode;
        public String BranchName;
        public String AccountType;
        public String AccountNumber;
        public String ClientName;
        public String EffectiveDate;
    }
    
}