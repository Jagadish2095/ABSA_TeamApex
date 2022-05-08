/*
* Response Integration Bean for getMobileBeneficiaries Service
* @author Mashudu Raidimi
* @created 2020-08-26
*/
public class getMobileBeneficiaries_Resp_IB_v1 extends Base_IB{

    public class mobileNumberList{
        
        public String cellNo;
        public String ivrPaymentNo;
        public String description;
        public String cellProvider;
        
    }
    
    public list<mobileNumberList> mobileNumberList;
    public String errorDesc;

}