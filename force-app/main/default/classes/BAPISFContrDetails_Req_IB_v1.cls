/** @description  Request Integration Bean for BAPISFContrDetails Service
 * @author Humbelani Denge
 * @created 2021-01-27
 **/
public class BAPISFContrDetails_Req_IB_v1 extends Base_IB {
	public BAPI_SF_CONTR_DETAILS BAPI_SF_CONTR_DETAILS;

	/** @description  BAPI_SF_CONTR_DETAILS
	 * @author Humbelani Denge
	 * @created 2021-01-27
	 **/
	public class BAPI_SF_CONTR_DETAILS {
		public String I_ACCOUNT;
		public String I_USER;
	}
	/** @description  createDummyRequest
	 * @author Humbelani Denge
	 * @return BAPISFContrDetails_Req_IB_v1
	 **/
	public static BAPISFContrDetails_Req_IB_v1 createDummyRequest() {
		BAPISFContrDetails_Req_IB_v1 requestBean = new BAPISFContrDetails_Req_IB_v1();
		requestBean.BAPI_SF_CONTR_DETAILS = new BAPISFContrDetails_Req_IB_v1.BAPI_SF_CONTR_DETAILS();

		requestBean.BAPI_SF_CONTR_DETAILS.I_ACCOUNT = '00073552449';
		requestBean.BAPI_SF_CONTR_DETAILS.I_USER = 'ab0131R';

		return requestBean;
	}
}