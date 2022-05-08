/**
 * @description Integration Handler for SAPCancel Service
 * @author Jason Quevauvilliers
 * @created 2020-11-05
 * @modified 202104-19 by Jason Quevauvilliers (W-011270)
 */
public class AvafVapsCancel_IH_v1 extends Base_IB {
	public static final String INTEGRATION_SERVICE_NAME = 'Avaf Vaps Cancel';
	/**
	 * @description Calls AvafVapsCancel Service
	 * @param selectedVAPS
	 * @param authOverride
	 * @return AvafVapsCancel_Resp_IB_v1
	 */
	public static AvafVapsCancel_Resp_IB_v1 cancelInsurance(String selectedVAPS, Boolean authOverride) {
		AvafVapsCancel_Req_IB_v1 requestBean = AvafVapsCancel_IU_v1.mapRequestFields(selectedVAPS, authOverride);
		AvafVapsCancel_Resp_IB_v1 responseBean = (AvafVapsCancel_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			AvafVapsCancel_Resp_IB_v1.class
		);
		return responseBean;
	}
}