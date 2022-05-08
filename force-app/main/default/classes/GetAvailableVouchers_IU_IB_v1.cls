/**
 * @description Integration Utility Bean for GetAvailableVouchers Service
 * @author Simangaliso Mathenjwa
 * @created 2021-11-04
 */
public class GetAvailableVouchers_IU_IB_v1 extends Base_IB {
	/**
	 * @description method to create request and return response
	 * @param txnReference
	 * @return GetAvailableVouchers_Req_IB_v1
	 */
	public static GetAvailableVouchers_Req_IB_v1 mapRequestFields(String txnReference) {
		GetAvailableVouchers_Req_IB_v1 requestBean = new GetAvailableVouchers_Req_IB_v1();
		requestBean.header = new GetAvailableVouchers_Req_IB_v1.Header();
		requestBean.header.applicationId = 'SALESFORCE';
		requestBean.txnReference = txnReference;

		return requestBean;
	}
}