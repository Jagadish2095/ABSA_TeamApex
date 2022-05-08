/**
 * @description Request Integration Bean for DLGetExceptionReport Service
 * @author Jason Quevauvilliers
 * @created 2021-03-29
 */
public class DLGetExceptionReport_Req_IB_v1 extends Base_IB {
	//Used the Header_cls defined in the DLGetPaymentHistoryForCustomer_Req_IB_v1 class as they are the same structure
	public DLGetPaymentHistoryForCustomer_Req_IB_v1.Header_cls header;
	public String cifKey;

	/**
	 * @description Creates a fake request for testing
	 * @return DLGetExceptionReport_Req_IB_v1
	 */
	public static DLGetExceptionReport_Req_IB_v1 createDummyRequest() {
		DLGetExceptionReport_Req_IB_v1 requestBean = new DLGetExceptionReport_Req_IB_v1();
		requestBean.cifKey = 'ABC123';
		requestBean.header = new DLGetPaymentHistoryForCustomer_Req_IB_v1.Header_cls();
		requestBean.header.service = 'DigitalLifestyleRewardsVouchersSFFacade';
		requestBean.header.operation = 'GetExceptionReportForCustomer';
		requestBean.header.sourceip = '169.02.201.5';
		requestBean.header.applicationId = 'INTERNETEXPS';
		return requestBean;
	}
}