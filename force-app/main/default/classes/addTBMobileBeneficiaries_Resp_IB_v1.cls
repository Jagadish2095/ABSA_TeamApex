/*
* Response Integration Bean for addTBMobileBeneficiaries Service
* @author Mashudu Raidimi
* @created 2020-07-27
*/
public class addTBMobileBeneficiaries_Resp_IB_v1 extends Base_IB{
    
    public addMobileBeneficiariesResp addMobileBeneficiariesResp;
    public Boolean error;
    public String additionalInfo;
    public List<errorList> errorList;
    
    public class addMobileBeneficiariesResp{
        public String saveMessage;
    }
    
     public class errorList{
        public String field;
        public String description;
    }

    public addTBMobileBeneficiaries_Resp_IB_v1(){}
}