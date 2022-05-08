public class DebitOrderInstruction_Req_IB_v1 extends Base_IB 
{
    public String WillNo;
    public Integer FeeCode;
    public Decimal Amount;
    public String PaymentDate;
    public String BankName;
    public Integer BranchCode;
    public String BranchName;
    public String AccountNumber;
    public String AccountType;
    
    public DebitOrderInstruction_Req_IB_v1 createDummyRequest()
    { 
    	DebitOrderInstruction_Req_IB_v1 reqBean = new DebitOrderInstruction_Req_IB_v1();
    	
	    reqBean.WillNo = '41860905606';
	    reqBean.FeeCode = 14;
	    reqBean.Amount = 270.00;
	    reqBean.PaymentDate = '03/02/2019';
	    reqBean.BankName = 'Standard Bank';
	    reqBean.BranchCode = 567898;
	    reqBean.BranchName = 'Cresta';
	    reqBean.AccountNumber = '9876765654';
	    reqBean.AccountType = 'Transmission';
	    
	    System.debug('RequestBean: ' + reqBean); 
	    
	    return reqBean;	        
    }
}