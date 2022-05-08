/**
 * @description request bean for call out to get voucher challenges for W-009112
 * @author Humbelani Denge
 * @created 2021/05/10
 */
public class GetChallenges_Req_IB_v1 extends Base_IB {
	public Header header;
	public String cifKey;
	public String idNumber;

	/**
	 * @description Header class
	 */
	public class Header {
		public String applicationId;
	}

	/**
	 * @description method to return dummy request for unit testing
	 * @return GetChallenges_Req_IB_v1
	 */
	public static GetChallenges_Req_IB_v1 createDummyRequest() {
		GetChallenges_Req_IB_v1 requestBean = new GetChallenges_Req_IB_v1();

		requestBean.cifKey = 'FRIENLM001';
		requestBean.idNumber = '9101265784089';
		requestBean.header = new GetChallenges_Req_IB_v1.Header();
		requestBean.header.applicationId = 'SALESFORCE';

		return requestBean;
	}
}