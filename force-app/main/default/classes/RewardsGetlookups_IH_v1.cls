/**
 * @description       : RewardsGetlookups_IH_v1
 * @author            : Jabulani Mashia
 * @last modified on  : 2021-08-31
 * @last modified by  : André Pietersen (IQ Business)
**/
public class RewardsGetlookups_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'rewardsGetlookups';

	/**
	 * @description rewardsGetlookups
	 * @author Jabulani Mashia
	 * @param requestBean
	 * @return rewardsGetlookups_Resp_IB_v1
	 **/
	public static RewardsGetlookups_Resp_IB_v1 rewardsGetlookups(RewardsGetlookups_Req_IB_v1 requestBean) {
		RewardsGetlookups_Resp_IB_v1 responseBean = (RewardsGetlookups_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			RewardsGetlookups_Resp_IB_v1.class
		);
		return responseBean;
	}
}