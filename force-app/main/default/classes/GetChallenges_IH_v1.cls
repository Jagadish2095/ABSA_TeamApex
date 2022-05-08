/**
 * @description Handler Class for Get Challenges services (W-009112)
 * @author Humbelani Denge
 * Created 2021/05/10
 */
public class GetChallenges_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Get Challenges v1';
	/**
	 * @description invokes service callout and returns response
	 * @param cifKey
	 * @return GetChallenges_Resp_IB_v1
	 */
	public static GetChallenges_Resp_IB_v1 GetChallenges(String cifKey) {
		GetChallenges_Req_IB_v1 requestBean = GetChallenges_IU_v1.mapRequestFields(cifKey);
		GetChallenges_Resp_IB_v1 responseBean = (GetChallenges_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			GetChallenges_Resp_IB_v1.class
		);

		return responseBean;
	}
}