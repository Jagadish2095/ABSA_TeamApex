/**
 * @description Request Integration Bean for DLGetPaymentHistoryForCustomer Service
 * @author Jason Quevauvilliers
 * @created 2021-03-17
 */
public class DLGetPaymentHistoryForCustomer_Req_IB_v1 extends Base_IB {
	public Header_cls header;
	public String cifKey;
	public String idNumber;

	/**
	 * @description inner class
	 */
	public class Header_cls {
		public String service;
		public String operation;
		public String sourceip;
		public String applicationId;
	}

	/**
	 * @description Creates a fake request for testing
	 * @return DLGetPaymentHistoryForCustomer_Req_IB_v1
	 */
	public static DLGetPaymentHistoryForCustomer_Req_IB_v1 createDummyRequest() {
		DLGetPaymentHistoryForCustomer_Req_IB_v1 requestBean = new DLGetPaymentHistoryForCustomer_Req_IB_v1();
		requestBean.cifKey = 'ABC123';
		requestBean.idNumber = '1234567898765';
		requestBean.header = new DLGetPaymentHistoryForCustomer_Req_IB_v1.Header_cls();
		requestBean.header.service = 'DigitalLifestyleRewardsVouchersSFFacade';
		requestBean.header.operation = 'GetPaymentHistoryForCustomer';
		requestBean.header.sourceip = '169.02.201.5';
		requestBean.header.applicationId = 'INTERNETEXPS';
		return requestBean;
	}
}