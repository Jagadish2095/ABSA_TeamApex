/** 
 * @description Request Integration Bean for GetAvailableVouchers Service
 * @author Simangaliso Mathenjwa
 * @created 2021-11-04
 */
public  class GetAvailableVouchers_Req_IB_v1 extends Base_IB{

    public Header header;
	public String txnReference;

    /**
	* @description Header class
	*/
	public class Header {
		public String applicationId;
	}

	/**
	* @description createDummyRequest 
    * @return requestBean
	*/
    public static GetAvailableVouchers_Req_IB_v1 createDummyRequest() {
        GetAvailableVouchers_Req_IB_v1 requestBean = new GetAvailableVouchers_Req_IB_v1();
		requestBean.header = new GetAvailableVouchers_Req_IB_v1.Header();
		requestBean.header.applicationId = 'SALESFORCE';
		requestBean.txnReference = 'cb6abacf-bcb6-48ee-af24-15121a72a533';
		return requestBean;

    }
}