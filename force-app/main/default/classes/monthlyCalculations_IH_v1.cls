/**
 * Intergration Handler for GetTriadsAggregation Service
 *
 * @author  Gopi Budaraju (ZA)
 * @version v1.0n
 * @since   2020/09/20
 * @UserStory W:006253
 *
 * @update Englarmerge Mongwe
 * @date 2021-01-07
 * Complete UserStory W:006253
 */
public class monthlyCalculations_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Get Triads Aggregation';

	public static monthlyCalculations_Resp_IB_v1 getmonthlyCalculations(monthlyCalculations_Req_IB_v1 requestBean) {
		monthlyCalculations_Resp_IB_v1 responseBean = (monthlyCalculations_Resp_IB_v1)Sys_Utilities_Integration.integrationServiceCall(requestBean, null, INTEGRATION_SERVICE_NAME, monthlyCalculations_Resp_IB_v1.class);
		return responseBean;
	}
}