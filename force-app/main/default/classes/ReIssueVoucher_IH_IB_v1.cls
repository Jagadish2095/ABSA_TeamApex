/**
 * @description Integration Handler bean ReIssueVoucher
 * @author Simangaliso Mathenjwa
 * @created 2021 11 16
 */
public class ReIssueVoucher_IH_IB_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'ReIssueVoucher';

	/**
	 * @description get the select account Information
	 * @param requestFieldsMap
	 * @return ReIssueVoucher_Resp_IB_v1
	 */
	public static ReIssueVoucher_Resp_IB_v1 callReissueVoucher(Map<String, String> requestFieldsMap) {
		ReIssueVoucher_Req_IB_v1 requestBean = ReIssueVoucher_IU_IB_v1.mapRequestFields(requestFieldsMap);
		ReIssueVoucher_Resp_IB_v1 responseBean = (ReIssueVoucher_Resp_IB_v1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			ReIssueVoucher_Resp_IB_v1.class
		);

		return responseBean;
	}
}