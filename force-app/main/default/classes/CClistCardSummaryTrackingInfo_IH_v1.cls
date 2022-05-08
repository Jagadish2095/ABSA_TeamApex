/**
 * @description Integration Handler for CClistCardSummaryTrackingInfo Service
 * @author Jason Quevauvilliers
 * @created 2021-03-24
 */
public class CClistCardSummaryTrackingInfo_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'CC List Card Summary Tracking Info';
	/**
	 * @description Calls CClistCardSummaryTrackingInfo Service
	 * @param cifCode
	 * @return CClistCardSummaryTrackingInfo_Resp_IB_v1
	 */
	public static CClistCardSummaryTrackingInfo_Resp_IB_v1 getCardDeliveryDetails(String cifCode) {
		CClistCardSummaryTrackingInfo_Req_IB_v1 requestBean = CClistCardSummaryTrackingInfo_IU_v1.mapRequestFields(cifCode); // PIERIDO001	NORMAJ 013
		CClistCardSummaryTrackingInfo_Resp_IB_v1 responseBean = (CClistCardSummaryTrackingInfo_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			CClistCardSummaryTrackingInfo_Resp_IB_v1.class
		);
		return responseBean;
	}
}