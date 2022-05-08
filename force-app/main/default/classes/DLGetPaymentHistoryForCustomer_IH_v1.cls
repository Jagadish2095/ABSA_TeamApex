/**
 * @description Integration Handler for DLGetPaymentHistoryForCustomer Service
 * @author Jason Quevauvilliers
 * @created 2021-03-17
 */
public class DLGetPaymentHistoryForCustomer_IH_v1 {
	public static final String INTEGRATION_SERVICE_NAME = 'DL Get Payment History For Customer';
	/**
	 * @description Calls DLGetPaymentHistoryForCustomer Service
	 * @param cifCode
	 * @param idNumber
	 * @return DLGetPaymentHistoryForCustomer_Resp_IBv1
	 */
	public static DLGetPaymentHistoryForCustomer_Resp_IBv1 getPaymentHistory(String cifCode, String idNumber) {
		DLGetPaymentHistoryForCustomer_Req_IB_v1 requestBean = DLGetPaymentHistoryForCustomer_IU_v1.mapRequestFields(cifCode, idNumber);
		DLGetPaymentHistoryForCustomer_Resp_IBv1 responseBean = (DLGetPaymentHistoryForCustomer_Resp_IBv1) Sys_Utilities_Integration.integrationServiceCall(
			requestBean,
			INTEGRATION_SERVICE_NAME,
			DLGetPaymentHistoryForCustomer_Resp_IBv1.class
		);
		return responseBean;
	}
}