/**
 * @description       : Casa Get analyst comments request bean
 * @author  Thomas Dry : ABSA (IQ Business)
 * @since   2021-02-15
 * @last modified on  : 2021-08-16
 * @last modified by  : PaulJohn.duRand@absa.africa
 **/

public class Wqgetanalystcommentsv7_Req_IB_v2 extends Base_IB {
	public WQgetAnalystCommentsV7Request WQgetAnalystCommentsV7Request;

	/**
	 * @description WQgetAnalystCommentsV7Request
	 **/
	public class WQgetAnalystCommentsV7Request {
		public String refNo;
	}

	/**
	 * @description CreateInstance
	 * @author PaulJohn.duRand@absa.africa | 2021-08-16
	 * @return Wqgetanalystcommentsv7_Req_IB_v2
	 **/
	public static Wqgetanalystcommentsv7_Req_IB_v2 CreateInstance() {
		Wqgetanalystcommentsv7_Req_IB_v2 request = new Wqgetanalystcommentsv7_Req_IB_v2();
		request.WQgetAnalystCommentsV7Request = new Wqgetanalystcommentsv7_Req_IB_v2.WQgetAnalystCommentsV7Request();
		return request;
	}
}