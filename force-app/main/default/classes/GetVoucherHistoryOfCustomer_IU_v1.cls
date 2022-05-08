/**
 * @description utility class for GetVoucherHistoryOfCustomer service(W-009112)
 * @author Humbelani Denge
 * Created 2021/05/10
 */
public class GetVoucherHistoryOfCustomer_IU_v1 {
	/**
	 * @description map request bean fields
	 * @param cifKey 
	 * @param idnumber
	 * @return GetVoucherHistoryOfCustomer_Req_IB_v1
	 */
	public static GetVoucherHistoryOfCustomer_Req_IB_v1 mapRequestfields(String cifKey, String idnumber) {
		GetVoucherHistoryOfCustomer_Req_IB_v1 requestBean = new GetVoucherHistoryOfCustomer_Req_IB_v1();
		requestBean.cifKey = cifKey;
        requestBean.idNumber = idnumber;
		requestBean.header = new GetVoucherHistoryOfCustomer_Req_IB_v1.Header();
		requestBean.header.applicationId = 'SALESFORCE';

		return requestBean;
	}
}