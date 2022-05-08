/**
 * @description Handler class for GetVoucherHistoryOfCustomer service(W-009112)
 * @author Humbelani Denge
 * Created 2021/05/10
 */
public class GetVoucherHistoryOfCustomer_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'Get Voucher History Of Customer v1';

	/**
	 * @description invokes GetVoucherHistoryOfCustomer servivce callout
	 * @param cifKey
	 * @param idnumber
	 * @return GetVoucherHistoryOfCustomer_Resp_IB_v1
	 */
	public static GetVoucherHistoryOfCustomer_Resp_IB_v1 GetVoucherHistoryOfCustomer(String cifKey, String idnumber) {
		GetVoucherHistoryOfCustomer_Req_IB_v1 requestBean = GetVoucherHistoryOfCustomer_IU_v1.mapRequestfields(cifKey, idnumber);
		GetVoucherHistoryOfCustomer_Resp_IB_v1 responseBean = (GetVoucherHistoryOfCustomer_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			null,
			INTEGRATION_SERVICE_NAME,
			GetVoucherHistoryOfCustomer_Resp_IB_v1.class
		);
		return responseBean;
	}
}