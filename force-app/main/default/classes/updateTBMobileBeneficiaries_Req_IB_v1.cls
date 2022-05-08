/*
* Request Integration Bean for updateTBMobileBeneficiaries Service
* @author Mashudu Raidimi
* @created 2020-07-27
*/
public class updateTBMobileBeneficiaries_Req_IB_v1 extends Base_IB {
    
    public String cifKey;
    public String cellNo;
    public String ivrPaymentNo;
    public String description;
    public String cellProvider;
    
    public static updateTBMobileBeneficiaries_Req_IB_v1 DummyRequest(){
        
        updateTBMobileBeneficiaries_Req_IB_v1 requestBean = new updateTBMobileBeneficiaries_Req_IB_v1();
        
        requestBean.cifKey = 'PIERIDO001';
        requestBean.cellNo = '0723935028';
        requestBean.ivrPaymentNo = '5';
        requestBean.description = 'Test';
        requestBean.cellProvider = 'V';
        
        
        return requestBean;
    }

}