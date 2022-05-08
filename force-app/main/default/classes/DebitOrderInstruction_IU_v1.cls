public class DebitOrderInstruction_IU_v1 
{	
	public static DebitOrderInstruction_Req_IB_v1 mapRequestFields(String WillNo, Integer FeeCode, Decimal Amount, String PaymentDate, String BankName, Integer BranchCode, String BranchName, String AccountNumber, String AccountType)
    {           
        DebitOrderInstruction_Req_IB_v1 reqBean = new DebitOrderInstruction_Req_IB_v1();
                
	    reqBean.WillNo = WillNo;
	    reqBean.FeeCode = FeeCode;
	    reqBean.Amount = Amount;
	    reqBean.PaymentDate = PaymentDate;
	    reqBean.BankName = BankName;
	    reqBean.BranchCode = BranchCode;
	    reqBean.BranchName = BranchName;
	    reqBean.AccountNumber = AccountNumber;
	    reqBean.AccountType = AccountType;
       
        System.debug('Debit Order Instruction Request Bean: ' + reqBean);
        return reqBean;
    }
    
    /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: DebitOrderInstruction_Resp_IB_v1 bean object
     */
    public static DebitOrderInstruction_Resp_IB_v1 mapResponseFields(HttpResponse responseP)
    {              
        DebitOrderInstruction_Resp_IB_v1 bean = new DebitOrderInstruction_Resp_IB_v1();
        DebitOrderInstruction_Resp_IB_v1 responseBean = (DebitOrderInstruction_Resp_IB_v1)bean.deserialize(responseP.getBody(), DebitOrderInstruction_Resp_IB_v1.class);
        
        responseBean.status = responseP.getStatus();
        responseBean.statusCode = responseP.getStatusCode();
        responseBean.message = '';
        
        System.debug('Debit Order Instruction Response Bean: ' + responseBean);
        
        return responseBean;
    }
    
    /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
     * @param: Status Code
     * @param: Status
     * @param: message
     * @return: DebitOrderInstruction_Resp_IB_v1 bean object
     * */    
    public static DebitOrderInstruction_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP)
    {        
        DebitOrderInstruction_Resp_IB_v1 responseBean = new DebitOrderInstruction_Resp_IB_v1();
        responseBean.status = statusP;
        responseBean.statusCode = statusCodeP;
        responseBean.message = messageP;
        
        return responseBean;
    }    
}