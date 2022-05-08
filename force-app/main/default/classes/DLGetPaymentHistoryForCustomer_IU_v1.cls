/**
 * @description Integration Utilities for DLGetPaymentHistoryForCustomer Service
 * @author Jason Quevauvilliers
 * @created 2021-03-17
 */
public class DLGetPaymentHistoryForCustomer_IU_v1 {
	/**
	 * @description Map Request Fields
	 * @param cifCode
	 * @param idNumber
	 * @return DLGetPaymentHistoryForCustomer_Req_IB_v1 Object
	 */
	public static DLGetPaymentHistoryForCustomer_Req_IB_v1 mapRequestFields(String cifCode, String idNumber) {
		DLGetPaymentHistoryForCustomer_Req_IB_v1 requestBean = new DLGetPaymentHistoryForCustomer_Req_IB_v1();
		requestBean.cifKey = cifCode;
		requestBean.idNumber = idNumber;
		requestBean.header = new DLGetPaymentHistoryForCustomer_Req_IB_v1.Header_cls();
		requestBean.header.service = 'DigitalLifestyleRewardsVouchersSFFacade';
		requestBean.header.operation = 'GetPaymentHistoryForCustomer';

		requestBean.header.applicationId = 'SALESFORCE';

		return requestBean;
	}
}