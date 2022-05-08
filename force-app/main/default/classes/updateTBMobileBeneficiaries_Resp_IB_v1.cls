/*
* Response Integration Bean for updateTBMobileBeneficiaries Service
* @author Mashudu Raidimi
* @created 2020-07-27
*/
public class updateTBMobileBeneficiaries_Resp_IB_v1 extends Base_IB{
    
    public updateMobileBeneficiariesResp updateMobileBeneficiariesResp;
    public Boolean error;
    public String additionalInfo;
    public List<errorList> errorList;
    
    public class updateMobileBeneficiariesResp{
        public String updateMessage;
    }
    
     public class errorList{
        public String field;
        public String description;
    }

    public updateTBMobileBeneficiaries_Resp_IB_v1(){}

}