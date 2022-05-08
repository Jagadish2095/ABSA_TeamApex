/*
 * Response Integration Bean for HanisValidate Service
 * @author Prashant Jain
 * @created 2020-02-12
 */

public class HanisValidate_Resp_IB_v1 extends Base_IB {

    public String status{get;set;}
    public Integer statusCode{get;set;}
    public String message{get;set;}

	public String transactionID{get;set;}
	public String idNumber{get;set;}
	public String name{get;set;}
	public String surname{get;set;}
	public Boolean hasSmartCard{get;set;}
	public String dateIssued{get;set;}
	public Integer idSequenceNo{get;set;}
	public Boolean deadIndicator{get;set;}
	public Boolean idBlocked{get;set;}
	public String dateOfDeath{get;set;}
	public String maritalStatus{get;set;}
	public String dateOfMarriage{get;set;}
	public String image{get;set;}
	public Boolean onHanis{get;set;}
	public Boolean onNpr{get;set;}
	public String birthPlaceCountryCode{get;set;}
	public Integer errorCode{get;set;}
	public String Cert{get;set;}
	public String sessionID{get;set;}
}