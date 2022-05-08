/**
* Integration Response Bean for Switches
* @author Edgar Blount
* @created 2020-09-25
*/
public class Switches_Resp_IB_v1  extends Base_IB
{
	//public String status;
    //public Integer statusCode;
	//public String message;	

	public String createdBy; 
	public String lastModifiedBy;
	public String creationDate; 
	public String lastModifiedDate; 
	public String state; 
	public String switchType; 
	public String accountNumber; 
	public String frequency; 
	public String dueDate; 
	public Double amount; 
	public String notes; 
	public String referenceNumber; 
	public String reason; 
	public String nextPremiumDate;
	public String allocatedTo; 
	public String followUp; 
	public String previousAccountNumber; 
	public String previousAccountType; 
	public String previousBranch; 
	public String previousInstitution; 
	public String channel; 
	public String originEmployeeName;
	public String originEmployeeSurname; 
	public String originEmployeeNumber;
	public String originSiteCode; 
	public String originSiteName; 
	public Boolean valid;
	public String primaryTrigger; 
	public String friendlyState;
	public String formattedDueDate; 
	public Integer age; 
	public Boolean overdue;
	public List<String> triggers;
	public Boolean channelValid;
	public Links x_links; // in json: _links

    public class Links {
		public Self self; 
		public Self switchRequest; 
		public Self history;
		public Self letter; 
		public Self download; 
		public Self follow_up; // in json: follow-up
		public Self institution;
		public Self customer;	
	}	
	
	public class Self 
	{
		public String href;		
	}    

	public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"follow-up":', '"follow_up":');
        fieldNameSubstitutionMap.put('"_links":', '"x_links":');        
    }
}