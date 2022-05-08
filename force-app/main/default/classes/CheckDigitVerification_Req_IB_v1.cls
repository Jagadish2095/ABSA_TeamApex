public class CheckDigitVerification_Req_IB_v1 extends Base_IB {
    
    public String accountNumber;
    public String branchCode;
    public String accountType;
    public String transactionType;
    public String cdvRequired;
    public String expiryDate;
    public String channel;
    public String application;
    public String msgLanguage;
    public String msgTarget;
    public String trace;
    
    public void createDummyRequest(){
        
        this.accountNumber = '0000009050515220';
        this.branchCode = '632005';
        this.accountType = '01';
        this.transactionType = 'DR';
        this.cdvRequired = '';
        this.expiryDate = '0';
        this.channel = 'Sales';
        this.application = 'Salesforce';
        this.msgLanguage = 'E';
        this.msgTarget = 'STD';
        this.trace = 'N';
        
    }
}