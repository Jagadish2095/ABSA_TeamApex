/**
* Integration Response for Switching Customers
* @author André Pietersen
* @created 2020-10-01
*/
public class SwitchingCustomers_Resp_IB_v1 extends Base_IB {
    //public String status;
    //public Integer statusCode;
    //public String message;

    public String createdBy; 
    public String lastModifiedBy; 
    public String creationDate;
    public String lastModifiedDate; 
    public String state; 
    public String name; 
    public String surname; 
    public String identifier; 
    public String email; 
    public String telephoneNumber; 
    public String mobileNumber; 
    public String ecmAttachmentKey; 
    public String title; 
    public String communicationMethod; 
    public String bankAccountNumber; 
    public String bankAccountType; 
    public Long bankBranch; 
    public String previousAccountNumber; 
    public String previousAccountType; 
    public String previousBranch; 
    public String previousInstitution; 
    public String preferredLanguage; 
    public String fullName;
    public List<String> triggers;
    public string gender; 
    public Links x_links; // in json: _links

    public class Links 
    {
        public HRef self; 
        public HRef customer; 
        public HRef history;
        public HRef welcome_trigger;
    }

    public class HRef 
    {
        public String href;
    }

    public override void setFieldNameSubstitutions() 
    {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"_links":', '"x_links":');     
    }
}