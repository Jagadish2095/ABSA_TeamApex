/** 
 * @description Apex contoller for FPPaymentValidation Lightning Component
 * @author Jagadish Thummala
 * @created 16/03/2022
 */
public class MBGetPaymentDetailsCntrl {
    /**
   * @description Method to get payment validation details 
   * @param uniqueEft
   * @return MBgetPaymentDetailV3_Resp_IB_v1 object
   */
    @AuraEnabled
    public static MBgetPaymentDetailV3_Resp_IB_v1 getPaymentDetails(String uniqueEft){
        MBgetPaymentDetailV3_Resp_IB_v1 responseBean = MBgetPaymentDetailV3_IH_v1.MBgetPaymentDetailV3(uniqueEft);

       return responseBean;
    }
}