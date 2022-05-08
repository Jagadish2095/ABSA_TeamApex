/*
 * Integration Utility class for updateTBMobileBeneficiaries Service
 * @author Mashudu Raidimi
 * @created 2020-07-27
 */
public class updateTBMobileBeneficiaries_IU_v1 {
    
     public static updateTBMobileBeneficiaries_Req_IB_v1 mapRequestFields(String cifKey,String cellNo , String ivrPaymentNo ,
                                                                     String description, String cellProvider){
        
        updateTBMobileBeneficiaries_Req_IB_v1 requestBean = new updateTBMobileBeneficiaries_Req_IB_v1();
        
        requestBean.cifKey = cifKey;
        requestBean.cellNo = cellNo;
        requestBean.ivrPaymentNo = ivrPaymentNo;
        requestBean.description = description;
        requestBean.cellProvider = cellProvider;
        
        return requestBean;
                                                                         
       }

}