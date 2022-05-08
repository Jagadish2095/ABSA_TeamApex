/**
 * @description Integration Handler for EBSBeneficiaries Service
 * @author Koketso Mpshane
 * @created 2021-07-19
 */
public class EBSBeneficiaries_IH_v1 {
    
    public static final String INTEGRATION_SERVICE_NAME = 'EBS Beneficiaries';
	/**
	 * @description EBSBeneficiaries method 
	 * @param cifKey
	 * @param sourceAccount
	 * @return EBSBeneficiaries_Req_IB_v1
	 */
	public static EBSBeneficiaries_Resp_IB_v1 EBSBeneficiaries(String cifKey, String sourceAccount) {
		EBSBeneficiaries_Req_IB_v1 requestBean = EBSBeneficiaries_IU_v1.mapRequestFields(cifKey, sourceAccount);
		EBSBeneficiaries_Resp_IB_v1 responseBean = (EBSBeneficiaries_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			EBSBeneficiaries_Resp_IB_v1.class
		);

		return responseBean;
	}

}