/**
 *@description Response Integration Bean for RewardsGetlookups request Service
 * @author Jabulani Mashia
 * @created 2021-08-26
 **/

public without sharing class RewardsGetlookups_Req_IB_v1 extends Base_IB {
	public RewardsGetlookupsRequest RewardsGetlookupsRequest;
	/**
	 * @description rewardsGetlookupsRequest
	 * @author Jabulani Mashia
	 **/
	public class RewardsGetlookupsRequest {
		public GetLookups GetLookups;
	}
	/**
	 * @description getLookups
	 * @author Jabulani Mashia
	 **/
	public class GetLookups {
		public String source;
	}

	/**
	 * @description createDummyRequest
	 * @author Jabulani Mashia
	 * @return rewardsGetlookups_Req_IB_v1
	 **/
	public static rewardsGetlookups_Req_IB_v1 createDummyRequest() {
		rewardsGetlookups_Req_IB_v1 requestBean = new rewardsGetlookups_Req_IB_v1();
		rewardsGetlookups_Req_IB_v1.GetLookups getLookups = new rewardsGetlookups_Req_IB_v1.GetLookups();
		//requestBean.GetLookups.source = 'BDP';
		getLookups.source = 'BDP';

		return requestBean;
	}
}