/*
 * @description Integration Handler for SiebelGetPolicyDetailsById Service
 * @author Poulami Banerjee
 * @created 2020-11-03
 */
/**
 * @description SiebelGetPolicyDetailsById_IH_v1 Description
 *
 */
public class SiebelGetPolicyDetailsById_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Siebel Get Policy Details By Id';
	/**
	 * @description SiebelGetPolicyDetailsById description
	 *
	 * @param IdType (String): IdType
	 * @param IdNumber (String): IdNumber
	 * @return Return SiebelGetPolicyDetailsById_Resp_IB_v1: Return description
	 */
	public static SiebelGetPolicyDetailsById_Resp_IB_v1 SiebelGetPolicyDetailsById(String IdType, String IdNumber) {
		SiebelGetPolicyDetailsById_Req_IB_v1 requestBean = SiebelGetPolicyDetailsById_IU_v1.mapRequestFields(IdType, IdNumber);
		SiebelGetPolicyDetailsById_Resp_IB_v1 responseBean = (SiebelGetPolicyDetailsById_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			SiebelGetPolicyDetailsById_Resp_IB_v1.class
		);
		return responseBean;
	}
}