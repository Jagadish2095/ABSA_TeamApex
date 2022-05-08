/**
 * @description Integration Utilities for DLGetExceptionReport Service
 * @author Jason Quevauvilliers
 * @created 2021-03-29
 */
public class DLGetExceptionReport_IU_v1 {
	/**
	 * @description Map Request Fields
	 * @param cifCode
	 * @return DLGetExceptionReport_Req_IB_v1 Object
	 */
	public static DLGetExceptionReport_Req_IB_v1 mapRequestFields(String cifCode) {
		DLGetExceptionReport_Req_IB_v1 requestBean = new DLGetExceptionReport_Req_IB_v1();
		requestBean.cifKey = cifCode;
		requestBean.header = new DLGetPaymentHistoryForCustomer_Req_IB_v1.Header_cls();
		requestBean.header.service = 'DigitalLifestyleRewardsVouchersSFFacade';
		requestBean.header.operation = 'GetExceptionReportForCustomer';

		requestBean.header.applicationId = 'SALESFORCE';

		return requestBean;
	}
}