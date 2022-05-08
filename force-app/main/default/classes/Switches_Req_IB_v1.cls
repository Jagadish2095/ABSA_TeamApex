/**
* Integration Request Bean for Switches
* @author Edgar Blount
* @created 2020-09-25
*/
public class Switches_Req_IB_v1 extends Base_IB 
{
	public String channel {get;set;}
	public String state {get;set;}
	public String switchType {get;set;}
	public String accountNumber {get;set;}
	public String frequency {get;set;}
	public Boolean overdue {get;set;}
	public Object notes {get;set;}
	public String amount {get;set;}
	public String dueDate {get;set;}
		
	public String originEmployeeName {get;set;}
	public String originEmployeeSurname {get;set;}
	public String originEmployeeNumber {get;set;}
	public String originSiteCode {get;set;}
	public String originSiteName {get;set;}

	public String previousAccountNumber {get;set;}
	public String previousAccountType {get;set;}
	public String previousBranch {get;set;}
	public String previousInstitution {get;set;}
	public List<String> triggers {get;set;}

	public static Switches_Req_IB_v1 parse(String json) {
		return (Switches_Req_IB_v1) System.JSON.deserialize(json, Switches_Req_IB_v1.class);
	}

	public static Switches_Req_IB_v1 createDummyRequest() 
	{        
        Switches_Req_IB_v1 requestBean = new Switches_Req_IB_v1();

		requestBean.accountNumber = 'ref1234567890';
		requestBean.amount = '450';
		requestBean.channel = 'Salesforce';
		requestBean.dueDate = '2020-09-30';
		requestBean.frequency = 'MONTHLY';
		requestBean.originEmployeeName = 'Edgar';
		requestBean.originEmployeeNumber = 'AB01145';
		requestBean.originEmployeeSurname = 'Blount';
		requestBean.originSiteCode = 'tferwr';
		requestBean.originSiteName = 'Midrand';
		requestBean.previousAccountNumber = '90512345678';
		requestBean.previousAccountType = 'SAVINGS';
		requestBean.previousBranch = 'MIDRAND';
		requestBean.previousInstitution = 'FNB';
		requestBean.switchType = 'SALARY';

        return requestBean;
	}
	
}