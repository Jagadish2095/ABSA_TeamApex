/*
* Request Integration Bean for addTBMobileBeneficiaries Service
* @author Mashudu Raidimi
* @created 2020-07-27
*/
public class addTBMobileBeneficiaries_Req_IB_v1 extends Base_IB {
    
    public String cifKey;
    public String cellNo;
    public String ivrPaymentNo;
    public String description;
    public String cellProvider;
    
    public static addTBMobileBeneficiaries_Req_IB_v1 DummyRequest(){
        
        addTBMobileBeneficiaries_Req_IB_v1 requestBean = new addTBMobileBeneficiaries_Req_IB_v1();
        
        requestBean.cifKey = 'PIERIDO001';
        requestBean.cellNo = '0723935028';
        requestBean.ivrPaymentNo = '1';
        requestBean.description = 'Test';
        requestBean.cellProvider = 'V';
        
        
        return requestBean;
    }
    
}