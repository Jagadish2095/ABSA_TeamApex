/**
* Apex Integration Response Bean class for TOM Complaint service
* @author  Anka Ganta : Absa
* @since   2019-08-13
*
**/
public class TOMComplaint_Resp_IB_v1 extends Base_IB{
    
    public String RequesterReference;
	public String ProcessReference;
	public Integer StatusCode;
	public String StatusMessage;
    public String complaintNumber;
    public String tomCaseNumber;
    public String status;
    public String tomDecision;
    public String tomReason;
    public TOMComplaint_Resp_IB_v1(){}

}