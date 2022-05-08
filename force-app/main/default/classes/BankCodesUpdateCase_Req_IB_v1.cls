/*
* Request Integration Bean for BankCodesUpdateCase Service
* @author Thabo K Senkomane
* @created 2020-07-30
*/

public class BankCodesUpdateCase_Req_IB_v1 extends Base_IB {
    
    //registration fields for bank codes
    public String Id;
    public String Reference_Number;
    public String Reason;
    public String Status;
    public String Consultant_Notes_Comments;
    public Boolean Request_From_Absa_Business_Client;
    public Boolean Account_Conduct_Checked;
    public Boolean Account_Number_Confirmed;
    public Boolean Email_Address_Confirmed;
    public Boolean Request_From_Financial_Institution;
    public Boolean Name_Confirmed;
    public Boolean User_Type_Confirmed;
    public String Working_History;
    public String Reason_Combination;
    //requests fields for bank codes 
    public String Bank_Code_1;
    public String Bank_Code_2;
    public DateTime ClosedDate;
    public String AB_number;
    public String Request_Type;
    public DateTime Date_Issued;
    
    
    public static BankCodesUpdateCase_Req_IB_v1 createDummyRequest() {
        BankCodesUpdateCase_Req_IB_v1 requestBean = new BankCodesUpdateCase_Req_IB_v1();
        
 
        requestBean.Id = '5005E000007a4mnQAA';   
        requestBean.Reference_Number = 'REG-936';
        requestBean.Reason  = 'ewwwr';     
        requestBean.Status = 'Declined';    
        requestBean.Consultant_Notes_Comments = 'sdad';      
        requestBean.Request_From_Absa_Business_Client  = true;     
        requestBean.Account_Conduct_Checked  = true;     
        requestBean.Account_Number_Confirmed  = true;     
        requestBean.Email_Address_Confirmed = false;      
        requestBean.Request_From_Financial_Institution  = true;     
        requestBean.Name_Confirmed  = false;  
        requestBean.User_Type_Confirmed   = true;  
        requestBean.Working_History  = 'no comments'; 
        requestBean.Reason_Combination = '';
      /*  requestBean.Bank_Code_1 = '';
        requestBean.Bank_Code_2 = '';
        requestBean.ClosedDate = null;
        requestBean.AB_number = '';
        requestBean.Request_Type = '';
        requestBean.Date_Issued = null;*/
        return requestBean;
    }
  /*  public static BankCodesUpdateCase_Req_IB_v1 parse(String json) {
        return (BankCodesUpdateCase_Req_IB_v1) System.JSON.deserialize(json, BankCodesUpdateCase_Req_IB_v1.class);
    }*/
}