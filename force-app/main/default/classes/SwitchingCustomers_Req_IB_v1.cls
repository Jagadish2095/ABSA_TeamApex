/**
* Integration Request for Switching Customers
* @author André Pietersen
* @created 2020-10-01
*/
public class SwitchingCustomers_Req_IB_v1 extends Base_IB 
{
    public String state {get; set;}
    public String name {get; set;}
    public String surname {get; set;}
    public String identifier {get; set;}
    public String email {get; set;}
    public String telephoneNumber {get; set;}
    public String mobileNumber {get; set;}
    public String communicationMethod {get; set;}
    public String bankAccountNumber {get; set;}
    public String bankAccountType {get; set;}
    public String bankBranch {get; set;}
    public String previousAccountNumber {get; set;}
    public String previousAccountType {get; set;}
    public String previousBranch {get; set;}
    public String previousInstitution {get; set;}
    public String preferredLanguage {get; set;}

    public static SwitchingCustomers_Req_IB_v1 createDummyRequest() 
    {
        SwitchingCustomers_Req_IB_v1 requestBean = new SwitchingCustomers_Req_IB_v1();

        requestBean.state = 'NOT_WELCOMED';
        requestBean.name = 'rtretre';
        requestBean.surname = 'retertet';
        requestBean.identifier = '6005051994173';
        requestBean.email = 'aaa@aaa.com';
        requestBean.telephoneNumber = null;
        requestBean.mobileNumber = '0821234567';
        requestBean.communicationMethod = 'SMS';
        requestBean.bankAccountNumber = '8798797897897';
        requestBean.bankAccountType = 'SAVINGS';
        requestBean.bankBranch = '45444';
        requestBean.previousAccountNumber = '789789789789';
        requestBean.previousAccountType = 'SAVINGS';
        requestBean.previousBranch = '2346';
        requestBean.previousInstitution = 'MTN';
        requestBean.preferredLanguage = 'ENG';

        return requestBean;
    }
}