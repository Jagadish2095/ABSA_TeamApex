/**
 * @description Integration Handler for Absa Life get policy schedule
 * @author Bhanumurty Rayala
 * @created 2021-10-19
 */
public class AbsaLifeGetPolicySchedule_IH_v1 {
    	public static final String INTEGRATION_SERVICE_NAME = 'Get Policy Schedule';
	/**
	 * @description Integration Handler method
	 * @param policyNumber String
	 * @return responseBean Object
	 */
	public static AbsaLifeGetPolicySchedule_Resp_IB_v1 policyScheduleGet(
		String policyNumber
	) {
		String endpointSuffix = AbsaLifeGetPolicySchedule_IU_v1.policyScheduleEndPoint(
			policyNumber
		);
		AbsaLifeGetPolicySchedule_Resp_IB_v1 responseBean = (AbsaLifeGetPolicySchedule_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			null,
			endpointSuffix,
			INTEGRATION_SERVICE_NAME,
			AbsaLifeGetPolicySchedule_Resp_IB_v1.class
		);
		return responseBean;
	}
}