/**
 * @description Integration Handler for GetAvailableVouchers Service
 * @author Simangaliso Mathenjwa
 * @created 2021-11-04
 */
public class GetAvailableVouchers_IH_IB_v1 extends Base_IB {
	public static final String INTEGRATION_SERVICE_NAME = 'GetAvailableVouchers';

	/**
	 * @description get the select account Information
	 * @param txnReference
	 * @return GetAvailableVouchers_Resp_IB_v1
	 */
	public static GetAvailableVouchers_Resp_IB_v1 callGetAvailableVouchers(String txnReference) {
		GetAvailableVouchers_Req_IB_v1 requestBean = GetAvailableVouchers_IU_IB_v1.mapRequestFields(txnReference);
		GetAvailableVouchers_Resp_IB_v1 responseBean = (GetAvailableVouchers_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			GetAvailableVouchers_Resp_IB_v1.class
		);

		return responseBean;
	}
}