/*
 * Integration Utility class for addTBMobileBeneficiaries Service
 * @author Mashudu Raidimi
 * @created 2020-07-27
 */
public class addTBMobileBeneficiaries_IU_v1 {
    
    public static addTBMobileBeneficiaries_Req_IB_v1 mapRequestFields(String cifKey,String cellNo , String ivrPaymentNo ,
                                                                     String description, String cellProvider){
        
        addTBMobileBeneficiaries_Req_IB_v1 requestBean = new addTBMobileBeneficiaries_Req_IB_v1();
        
        requestBean.cifKey = cifKey;
        requestBean.cellNo = cellNo;
        requestBean.ivrPaymentNo = ivrPaymentNo;
        requestBean.description = description;
        requestBean.cellProvider = cellProvider;
        
        return requestBean;
                                                                         
       }

}