/**
 * @description Integration Utility for EBSBeneficiaries Service
 * @author Koketso Mpshane
 * @created 2021-07-19
 */
public class EBSBeneficiaries_IU_v1 {
    
     /**
	 * @description method to map request fields to creates a request bean
	 * @param cifKey
	 * @param sourceAccount
	 * @return EBSBeneficiaries_Req_IB_v1
	 */
     public static EBSBeneficiaries_Req_IB_v1 mapRequestFields(String cifKey, String sourceAccount) {
		EBSBeneficiaries_Req_IB_v1 requestBean = new EBSBeneficiaries_Req_IB_v1();
		requestBean.cifKey = cifKey;
		requestBean.sourceAccount = sourceAccount;

        return requestBean;
    }

}