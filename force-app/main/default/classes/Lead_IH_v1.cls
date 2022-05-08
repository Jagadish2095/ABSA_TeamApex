/** @description Integration Handler Bean for Lead_IH_v1 Service
 * @author Satya Boyenepalli
 * @created 28-07-2021
 */
public with sharing class Lead_IH_v1 extends Base_IB {
	public static final String INTEGRATION_SERVICE_NAME = 'lead';
	/**
	 * @description Quot Absa Instant Life
	 * @return Lead_Res_IB_v1
	 * @param requestBean
	 */

	public static Lead_Res_IB_v1 AbsaInstantLifeLead(Lead_Req_IB_v1 requestBean) {
		Lead_Res_IB_v1 responseBean = (Lead_Res_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			Lead_Res_IB_v1.class
		);
		return responseBean;
	}
}